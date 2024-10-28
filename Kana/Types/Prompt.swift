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

extension Prompt: CustomStringConvertible {
    var description: String {
        let systemPart = formatPart(title: "[SYSYTEM MESSAGE]", content: systemMessage)
        let userPart = formatPart(title: "[USER MESSAGE]", content: userMessage)
        let exampleParts = exampleMessagePairs.isEmpty ? "" : formatExamples()
        
        return [systemPart, exampleParts, userPart]
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")  // Add double line break between major sections
    }
    
    private func formatPart(title: String, content: String) -> String {
        let sections = formatSections(content)
        return "\(title)\n\(sections)"
    }
    
    private func formatExamples() -> String {
        var parts = ["Example Pairs:"]
        
        for (index, example) in exampleMessagePairs.enumerated() {
            parts.append("  Example \(index + 1):")
            parts.append("    User:")
            parts.append(formatSections(example.userMessage).indent(by: 4))
            parts.append("    Assistant:")
            parts.append(formatSections(example.assistantMessage).indent(by: 4))
        }
        
        return parts.joined(separator: "\n")
    }
    
    private func formatSections(_ content: String) -> String {
        content
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .reduce(into: [String]()) { result, line in
                if line.starts(with: "<") && line.hasSuffix(">") {
                    // Add a blank line before new section unless it's the first section
                    if !line.starts(with: "</") && !result.isEmpty {
                        result.append("")
                    }
                    result.append(line)
                } else {
                    result.append(line)
                }
            }
            .joined(separator: "\n")
    }
}

fileprivate extension String {
    func indent(by spaces: Int) -> String {
        let indent = String(repeating: " ", count: spaces)
        return self.components(separatedBy: .newlines)
            .map { $0.isEmpty ? $0 : indent + $0 }
            .joined(separator: "\n")
    }
}
