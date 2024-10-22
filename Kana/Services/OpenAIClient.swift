//
//  OpenAIClient.swift
//  Kana
//
//  Created by Paul Kim on 10/11/24.
//

import Foundation
import OpenAI

fileprivate extension LLMPrompt {
 
    func toChatQuery() -> ChatQuery {
        ChatQuery(messages: [], model: .gpt3_5Turbo)
    }
    
}

/// A client that uses OpenAI's API to perform translation-related tasks.
class OpenAIClient: LLMClient {
    /// The OpenAI client used for API calls.
    private let client: OpenAI
    
    /// Initializes a new instance of OpenAIClient.
    /// - Parameter apiKey: The API key for authenticating with OpenAI.
    init(apiKey: String) {
        self.client = OpenAI(apiToken: apiKey)
    }
    
    func send(prompt: LLMPrompt) -> AsyncThrowingStream<String, any Error> {
        AsyncThrowingStream { continuation in
            continuation.finish()
        }
//        return AsyncThrowingStream { continuation in
//            Task { [weak client] in
//                guard let client
//                var result = ""
//                for try await partialResult in client.chatsStream(query: prompt.toChatQuery()) {
//                    for choice in partialResult.choices {
//                        let messageText = choice.delta.content ?? ""
//                        result += messageText
//                        continuation.yield(result)
//                    }
//                }
//                continuation.finish()
//            }
//        }
    }
    
}

