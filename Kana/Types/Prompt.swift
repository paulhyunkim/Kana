//
//  Prompt.swift
//  Kana
//
//  Created by Paul Kim on 10/28/24.
//

import Foundation

struct Prompt {
    private var systemMessage: String
    private var userMessage: String
    private var exampleMessagePairs: [ExampleMessagePair]

    init(systemMessage: String, userMessage: String, exampleMessagePairs: [ExampleMessagePair] = []) {
        self.systemMessage = systemMessage
        self.userMessage = userMessage
        self.exampleMessagePairs = exampleMessagePairs
    }
    
    struct ExampleMessagePair {
        var userMessage: String
        var assistantMessage: String
    }
    
    enum Message {
        case system(String)
        case user(String)
        case assistant(String)
    }
    
    var messages: [Message] {
        let exampleMessages = exampleMessagePairs
            .map { [Message.user($0.userMessage), Message.assistant($0.assistantMessage)] }
            .flatMap { $0 }
        return [.system(systemMessage)] + exampleMessages + [.user(userMessage)]
    }
}
