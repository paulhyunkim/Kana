//
//  AnthropicService.swift
//  Kana
//
//  Created by Paul Kim on 10/24/24.
//

@preconcurrency import SwiftAnthropic
import Foundation
import LanguageKit

extension SwiftAnthropic.Model: @unchecked @retroactive Sendable {}

final class AnthropicClient: LLMClient, @unchecked Sendable {
    
    private let service: AnthropicService
    
    init(apiKey: String) {
        self.service = AnthropicServiceFactory.service(apiKey: apiKey, betaHeaders: nil)
    }
    
    func send(prompt: LLMPrompt, model: SwiftAnthropic.Model) -> AsyncThrowingStream<String, any Error> {
        AsyncThrowingStream { continuation in
            // Start a Task that interacts with the continuation
            Task {
                // Create the message parameter outside the Task
                let message = MessageParameter(
                    model: model,
                    messages: [],
                    maxTokens: 1024,
                    system: nil,
                    metadata: nil,
                    stopSequences: nil,
                    stream: false,
                    temperature: nil,
                    topK: nil,
                    topP: nil,
                    tools: nil,
                    toolChoice: nil
                )
                
                var workingResult = ""
                
                do {
                    // Create the stream inside the Task
                    let stream = try await service.streamMessage(message)

                    for try await result in stream {
                        let content = result.delta?.text ?? ""
                        workingResult += content
                        continuation.yield(workingResult)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
//    func send(prompt: LLMPrompt) async throws -> AsyncThrowingStream<String, any Error> {
//        let message = MessageParameter(
//            model: .claude35Sonnet,
//            messages: [],
//            maxTokens: 1024,
//            system: nil,
//            metadata: nil,
//            stopSequences: nil,
//            stream: false,
//            temperature: nil,
//            topK: nil,
//            topP: nil,
//            tools: nil,
//            toolChoice: nil
//        )
//        
//        let stream = try await service.streamMessage(message)
//        
//        return AsyncThrowingStream { continuation in
//            Task {
//                do {
//                    var workingResult = ""
//                    for try await result in stream {
//                        let content = result.delta?.text ?? ""
//                        workingResult += content
//                        continuation.yield(workingResult)
//                    }
//                    continuation.finish()
//                } catch {
//                    continuation.finish(throwing: error)
//                }
//            }
//        }
//    }
    
    func send(prompt: LLMPrompt, model: SwiftAnthropic.Model) async throws -> String {
        let message = MessageParameter(
            model: .claude35Sonnet,
            messages: [],
            maxTokens: 1024,
            system: nil,
            metadata: nil,
            stopSequences: nil,
            stream: false,
            temperature: nil,
            topK: nil,
            topP: nil,
            tools: nil,
            toolChoice: nil
        )
        let response = try await service.createMessage(message)
        switch response.content.first {
        case .text(let text):
            return text
        default:
            throw NSError(domain: "", code: 0)
        }
    }
    
    func send<ResultType: Decodable & JSONSchemaProviding>(prompt: LLMPrompt, model: SwiftAnthropic.Model) async throws -> ResultType {
        let result = try await send(prompt: prompt, model: model)
        let jsonSchema = ResultType.jsonSchema
        fatalError()
    }
    
    
}
