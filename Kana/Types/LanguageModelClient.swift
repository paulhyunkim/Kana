//
//  TranslationClient.swift
//  Kana
//
//  Created by Paul Kim on 10/11/24.
//

import Foundation
import LanguageKit

public enum LLMMessage: Codable, Sendable {
    
    case system(String)
    case user(String)
    case assistant(String)

}

public struct LLMPromptTemplate: Codable, Sendable {
    var user: String?
    var systemMessageTemplate: String
    var userMessageTemplate: String
    var fewShotMessages: [LLMMessage]
}

struct LLMPrompt: Codable, Sendable {
    var user: String?
    var systemMessage: String
    var userMessage: String
    var fewShotMessages: [LLMMessage]
//    var stream: Bool
}

struct LLMConversation {
    var messages: [LLMMessage]
}

/// Protocol defining the interface for a language model client.
protocol LLMClient {
    associatedtype ModelType
    func send(prompt: LLMPrompt, model: ModelType) -> AsyncThrowingStream<String, Error>
    func send(prompt: LLMPrompt, model: ModelType) async throws -> String
    func send<ResultType: Decodable & JSONSchemaProviding>(prompt: LLMPrompt, model: ModelType) async throws -> ResultType
}

// maybe this needs a different name. im thinking an adjective that describes what the conformance provides. like -ible, -able, -ing protocol suffixes
//protocol LLMResult: Codable {
//    /// A string that tells the LLM the structure of the expected response.
//    static var structureDescription: String { get }
//}

extension LLMClient {
    
//    func send(prompt: LLMPrompt) async throws -> String {
//        var resultString = ""
//        
//        for try await partialResult in send(prompt: prompt) {
//            resultString += partialResult
//        }
//        return resultString
//    }
    
//    func send<ResultType: LLMResult>(prompt: LLMPrompt) async throws -> ResultType {
//        // Step 1: Add the structure description to the prompt
//        var updatedPrompt = prompt
////        updatedPrompt.conversation.messages.append(
////            LLMMessage(role: .system, content: "Please respond with JSON matching this structure: \(ResultType.structureDescription)")
////        )
//        
//        // Step 2: Get the response as a string
//        let resultString = try await send(prompt: updatedPrompt)
//        
//        // Step 3: Convert the string into Data
//        guard let jsonData = resultString.data(using: .utf8) else {
//            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid JSON Format"))
//        }
//        
//        // Step 4: Decode the JSON into the specified result type
//        let decodedResult = try JSONDecoder().decode(ResultType.self, from: jsonData)
//        return decodedResult
//    }
    
}

enum LLMClientError: Error {
    case couldNotFindResponse
}


///// A protocol defining the operations for a translation client.
//protocol TranslationClient {
//    /// Translates text from one language to another.
//    /// - Parameters:
//    ///   - text: The text to translate.
//    ///   - sourceLanguage: The language of the source text.
//    ///   - targetLanguage: The language to translate the text into.
//    ///   - context: Optional context to improve translation accuracy.
//    /// - Returns: An asynchronous stream of translated text chunks.
//    func translate(text: String, from sourceLanguage: Language, to targetLanguage: Language, with context: String?) -> AsyncThrowingStream<String, Error>
//    
//    /// Transliterates text into a different script.
//    /// - Parameters:
//    ///   - text: The text to transliterate.
//    ///   - targetScript: The script to transliterate the text into.
//    /// - Returns: An asynchronous stream of transliterated text chunks.
//    func transliterate(text: String, targetScript: Script) -> AsyncThrowingStream<String, Error>
//    
//    /// Identifies vocabulary words in the given text.
//    /// - Parameters:
//    ///   - text: The text to analyze for vocabulary words.
//    ///   - targetLanguage: The language of the text.
//    ///   - proficiencyLevel: The proficiency level of the learner.
//    /// - Returns: An asynchronous stream of identified vocabulary words.
//    func identifyVocabularyWords(text: String, targetLanguage: Language, proficiencyLevel: String) -> AsyncThrowingStream<Vocabulary, Error>
//    
//    /// Provides definitions for the given text.
//    /// - Parameters:
//    ///   - text: The text to define.
//    ///   - targetLanguage: The language of the text.
//    /// - Returns: An asynchronous stream of definition text chunks.
//    func define(text: String, targetLanguage: Language) -> AsyncThrowingStream<String, Error>
//}
