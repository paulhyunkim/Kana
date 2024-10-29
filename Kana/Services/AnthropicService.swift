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

fileprivate extension Prompt {
 
    func toMessageParameter(model: Model) -> MessageParameter {
        let system: MessageParameter.System? = messages
            .compactMap {
                switch $0 {
                case .system(let content):
                    return content
                default:
                    return nil
                }
            }
            .first
            .map { .text($0) }
        
        let messages: [MessageParameter.Message] = messages.compactMap {
            switch $0 {
            case .user(let content):
                return MessageParameter.Message(role: .user, content: .text(content))
            case .assistant(let content):
                return MessageParameter.Message(role: .assistant, content: .text(content))
            default:
                return nil
            }
        }
        
        return MessageParameter(
            model: model,
            messages: messages,
            maxTokens: 1024,
            system: system,
            metadata: nil,
            stopSequences: nil,
            stream: false,
            temperature: nil,
            topK: nil,
            topP: nil,
            tools: nil,
            toolChoice: nil
        )
    }
    
}

final class AnthropicClient: LLMClient, @unchecked Sendable {
    
    private let service: AnthropicService
    
    init(apiKey: String) {
        self.service = AnthropicServiceFactory.service(apiKey: apiKey, betaHeaders: nil)
    }
    
    func send(prompt: Prompt, model: SwiftAnthropic.Model) -> AsyncThrowingStream<String, any Error> {
        AsyncThrowingStream { continuation in
            // Start a Task that interacts with the continuation
            Task {
                var workingResult = ""
                
                do {
                    // Create the stream inside the Task
                    let stream = try await service.streamMessage(prompt.toMessageParameter(model: model))

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
    
    func send(prompt: Prompt, model: SwiftAnthropic.Model) async throws -> String {
        let response = try await service.createMessage(prompt.toMessageParameter(model: model))
        switch response.content.first {
        case .text(let text):
            return text
        default:
            throw NSError(domain: "", code: 0)
        }
    }
    
    func send<ResultType: Decodable & JSONSchemaProviding>(prompt: Prompt, model: SwiftAnthropic.Model) async throws -> ResultType {
        let result = try await send(prompt: prompt, model: model)
        let jsonSchema = ResultType.jsonSchema
        fatalError()
    }
    
    
}
