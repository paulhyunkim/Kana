////
////  TranslationService.swift
////  Kana
////
////  Created by Paul Kim on 10/11/24.
////
//
//import Foundation
//import Combine
//import RealmSwift
//
///// A service class that manages translation-related operations.
//class TranslationService {
//    /// The client responsible for performing translation operations.
//    private let client: LLMClient
//    
//    /// The group of templates used for various translation tasks.
//    private var templateGroup: ConversationTemplateGroup?
//    
//    /// A set of cancellables to manage subscriptions.
//    private var cancellables: Set<AnyCancellable> = []
//    
//    /// Initializes a new instance of TranslationService.
//    /// - Parameter client: The translation client to use for operations.
//    init(client: LLMClient) {
//        self.client = client
//    }
//    
//    /// Attaches a Realm instance to observe changes in the conversation template group.
//    /// - Parameter realm: The Realm instance to observe.
//    func attachRealm(realm: Realm) {
//        realm.objects(AppConfig.self)
//            .collectionPublisher
//            .freeze()
//            .compactMap { $0.first?.conversationTemplateGroup }
//            .sink { _ in
//                
//            } receiveValue: { templateGroup in
//                self.templateGroup = templateGroup
//            }
//            .store(in: &cancellables)
//    }
//    
//    /// Translates text from one language to another.
//    /// - Parameters:
//    ///   - text: The text to translate.
//    ///   - sourceLanguage: The language of the source text.
//    ///   - targetLanguage: The language to translate the text into.
//    ///   - context: Optional context to improve translation accuracy.
//    /// - Returns: An asynchronous stream of translated text chunks.
//    /// - Throws: ConversationError if the template is missing or the service is invalid.
//    func translate(text: String, from sourceLanguage: Language, to targetLanguage: Language, with context: String?) throws -> AsyncThrowingStream<String, Error> {
//        guard let translationTemplate = templateGroup?.translation else {
//            throw ConversationError.missingTemplate
//        }
//        
//        let placeholderKeyValues = [
//            MessageTemplateKey.sourceText.toKeyValue(with: text),
//            MessageTemplateKey.sourceLanguage.toKeyValue(with: sourceLanguage.name),
//            MessageTemplateKey.targetLanguage.toKeyValue(with: targetLanguage.name),
//            MessageTemplateKey.contextText.toKeyValue(with: context),
//            MessageTemplateKey.speechStyle.toKeyValue(with: "Tameguchi"),
//        ]
//        
//        return try processTemplate(translationTemplate, with: placeholderKeyValues) { [weak self] in
//            guard let self = self else { throw ConversationError.invalidService }
////            return try self.client.translate(text: text, from: sourceLanguage, to: targetLanguage, with: context)
//            return AsyncThrowingStream { continuation in continuation.finish() }
//        }
//    }
//    
//    /// Transliterates text into a different script.
//    /// - Parameters:
//    ///   - text: The text to transliterate.
//    ///   - targetScript: The script to transliterate the text into.
//    /// - Returns: An asynchronous stream of transliterated text chunks.
//    /// - Throws: ConversationError if the template is missing or the service is invalid.
//    func transliterate(text: String, targetScript: Script) throws -> AsyncThrowingStream<String, Error> {
//        guard let transliterationTemplate = templateGroup?.transliteration else {
//            throw ConversationError.missingTemplate
//        }
//        
//        let placeholderKeyValues = [
//            MessageTemplateKey.sourceText.toKeyValue(with: text),
//            MessageTemplateKey.targetScript.toKeyValue(with: targetScript.name)
//        ]
//        
//        return try processTemplate(transliterationTemplate, with: placeholderKeyValues) { [weak self] in
//            guard let self = self else { throw ConversationError.invalidService }
////            return try self.client.transliterate(text: text, targetScript: targetScript)
//            return AsyncThrowingStream { continuation in continuation.finish() }
//        }
//    }
//    
//    /// Identifies vocabulary words in the given text.
//    /// - Parameters:
//    ///   - text: The text to analyze for vocabulary words.
//    ///   - targetLanguage: The language of the text.
//    ///   - proficiencyLevel: The proficiency level of the learner (default is "1").
//    /// - Returns: An asynchronous stream of identified vocabulary words.
//    /// - Throws: ConversationError if the template is missing or the service is invalid.
//    func identifyVocabularyWords(text: String, targetLanguage: Language, proficiencyLevel: String = "1") throws -> AsyncThrowingStream<Vocabulary, Error> {
//        guard let vocabularyTemplate = templateGroup?.vocabulary else {
//            throw ConversationError.missingTemplate
//        }
//        
//        let placeholderKeyValues = [
//            MessageTemplateKey.sourceText.toKeyValue(with: text),
//            MessageTemplateKey.targetLanguage.toKeyValue(with: targetLanguage.name),
//            MessageTemplateKey.proficiencyLevel.toKeyValue(with: proficiencyLevel)
//        ]
//        
//        return try processTemplate(vocabularyTemplate, with: placeholderKeyValues) { [weak self] in
//            guard let self = self else { throw ConversationError.invalidService }
////            return try self.client.identifyVocabularyWords(text: text, targetLanguage: targetLanguage, proficiencyLevel: proficiencyLevel)
//            return AsyncThrowingStream { continuation in continuation.finish() }
//        }
//    }
//    
//    /// Provides definitions for the given text.
//    /// - Parameters:
//    ///   - text: The text to define.
//    ///   - targetLanguage: The language of the text.
//    /// - Returns: An asynchronous stream of definition text chunks.
//    /// - Throws: ConversationError if the template is missing or the service is invalid.
//    func define(text: String, targetLanguage: Language) throws -> AsyncThrowingStream<String, Error> {
//        guard let definitionTemplate = templateGroup?.definition else {
//            throw ConversationError.missingTemplate
//        }
//        
//        let placeholderKeyValues = [
//            MessageTemplateKey.sourceText.toKeyValue(with: text),
//            MessageTemplateKey.targetLanguage.toKeyValue(with: targetLanguage.name)
//        ]
//        
//        return try processTemplate(definitionTemplate, with: placeholderKeyValues) { [weak self] in
//            guard let self = self else { throw ConversationError.invalidService }
////            return try self.client.define(text: text, targetLanguage: targetLanguage)
//            return AsyncThrowingStream { continuation in continuation.finish() }
//        }
//    }
//    
//    /// Processes a template with the given key-value pairs and performs the specified action.
//    /// - Parameters:
//    ///   - template: The conversation template to process.
//    ///   - keyValues: The key-value pairs to use for template processing.
//    ///   - action: The action to perform after processing the template.
//    /// - Returns: The result of the action as an asynchronous stream.
//    /// - Throws: Any error that occurs during template processing or action execution.
//    private func processTemplate<T>(_ template: ConversationTemplate, with keyValues: [MessageTemplateKey.PlaceholderKeyValue], action: () throws -> AsyncThrowingStream<T, Error>) throws -> AsyncThrowingStream<T, Error> {
////        let chatQuery = try template.toChatQuery(with: keyValues)
////        print(chatQuery.description)
//        return try action()
//    }
//}
//
///// Represents errors that can occur during conversation processing.
//enum ConversationError: Error {
//    /// Indicates that the response received is invalid.
//    case invalidResponse
//    /// Indicates that the response received is bad or unexpected.
//    case badResponse
//    /// Indicates that the API key used is invalid.
//    case invalidAPIKey
//    /// Indicates that a required template is missing.
//    case missingTemplate
//    /// Indicates that the service is in an invalid state.
//    case invalidService
//}
