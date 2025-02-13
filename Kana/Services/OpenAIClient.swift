//
//  OpenAIClient.swift
//  Kana
//
//  Created by Paul Kim on 10/11/24.
//

import Foundation
@preconcurrency import OpenAI
import LanguageKit

fileprivate extension LLMPrompt {
 
    func toChatQuery(model: Model) -> ChatQuery {
        ChatQuery(messages: [
            .system(.init(content: systemMessage))
        ], model: model)
    }
    
}

extension Model: @unchecked @retroactive Sendable {}

/// A client that uses OpenAI's API to perform translation-related tasks.
class OpenAIClient: LLMClient, @unchecked Sendable {
    
//    typealias ModelType = Model
    /// The OpenAI service used for API calls.
    private let service: OpenAI
    
    /// Initializes a new instance of OpenAIClient.
    /// - Parameter apiKey: The API key for authenticating with OpenAI.
    init(apiKey: String) {
        self.service = OpenAI(apiToken: apiKey)
    }
    
    func send(prompt: LLMPrompt, model: Model) -> AsyncThrowingStream<String, any Error> {
        AsyncThrowingStream { continuation in
            Task {
                let query = prompt.toChatQuery(model: model)
                var result = ""
                
                do {
                    for try await partialResult in service.chatsStream(query: query) {
                        for choice in partialResult.choices {
                            let messageText = choice.delta.content ?? ""
                            result += messageText
                            continuation.yield(result)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    func send(prompt: LLMPrompt, model: Model) async throws -> String {
        let query = prompt.toChatQuery(model: model)
        let result = try await service.chats(query: query)
        guard let message = result.choices.first?.message else {
            throw LLMClientError.couldNotFindResponse
        }
        switch message {
        case .assistant(let messageParam):
            if let content = messageParam.content {
                return content
            } else {
                throw LLMClientError.couldNotFindResponse
            }
        default:
            throw LLMClientError.couldNotFindResponse
        }
    }
    
    func send<ResultType: Decodable & JSONSchemaProviding>(prompt: LLMPrompt, model: Model) async throws -> ResultType {
        let result = try await send(prompt: prompt, model: model)
        let jsonSchema = ResultType.jsonSchema
        fatalError()
    }
    
}

