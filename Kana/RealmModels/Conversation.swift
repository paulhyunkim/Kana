//
//  Conversation.swift
//  Kana
//
//  Created by Paul Kim on 10/11/24.
//

import Foundation
//import RealmSwift
//
//class ConversationTemplateGroup: Object, ObjectKeyIdentifiable {
//    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted(indexed: true) var name: String
//    @Persisted var createdAt: Date = Date()
//    
//    @Persisted var vocabulary: ConversationTemplate?
//    @Persisted var translation: ConversationTemplate?
//    @Persisted var transliteration: ConversationTemplate?
//    @Persisted var grammar: ConversationTemplate?
//    @Persisted var context: ConversationTemplate?
//    @Persisted var definition: ConversationTemplate?
//}
//
//class ConversationTemplate: Object, ObjectKeyIdentifiable {
//    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted(indexed: true) var name: String
//    @Persisted var createdAt: Date = Date()
//    @Persisted var intent: Intent
//    
//    @Persisted var systemMessageTemplate: List<TemplateSegment>
//    @Persisted var userMessageTemplate: List<TemplateSegment>
//    @Persisted var fewShotConversation: List<ChatMessage>
//    
//    enum Intent: String, PersistableEnum {
//        /// translates text to a specified language
//        case textTranslation = "TRANSLATION"
//        /// classifies text into defined categories
//        case textClassification = "CLASSIFICATION"
//        case textTransliteration = "TRANSLITERATION"
//        case vocabularyWords = "VOCABULARY_IDENTIFICATION"
//        case wordDefintion = "DEFINITION"
//        // should this be specifically word/phrase usage?
//        case usage = "USAGE"
//        case sentenceAnalysis = "SENTENCE_ANALYSIS"
//    //    case sentenceTone = "SENTENCE_TONE"
//        /// sentence
//        case correction = "CORRECTION"
//    }
//    
//}
//
//class ChatMessage: EmbeddedObject, ObjectKeyIdentifiable {
//    @Persisted var role: ChatRole
//    @Persisted var content: String
//}
//
//enum ChatRole: String, PersistableEnum {
//    case system = "SYSTEM"
//    case user = "USER"
//    case assistant = "ASSISTANT"
//}
//
//class TemplateSegment: EmbeddedObject, ObjectKeyIdentifiable {
//    @Persisted var body: String
//    @Persisted var isRequired: Bool
//    @Persisted var placeholderKeys: List<MessageTemplateKey>
//}

//enum TextClassification {
//    /// Single or compound
//    /// may consist of a single morpheme or a combination of morphemes
//    case word
//    /// A phrase is a group of words, but it doesn't contain a subject and a verb.
//    /// A group of words without a subject-verb unit
//    case phrase
//    /// contains one or more independent clauses
//    case sentence
//}
//
//
//enum MessageTemplateKey: RawRepresentable, CaseIterable, PersistableEnum {
//    static let allCases: [MessageTemplateKey] = [.sourceText]
//    
//    init?(rawValue: String) {
//        switch rawValue {
//        case Identifier.sourceText:
//            self = .sourceText
//        case Identifier.sourceLanguage:
//            self = .sourceLanguage
//        case Identifier.targetLanguage:
//            self = .targetLanguage
//        case Identifier.contextText:
//            self = .contextText
//        case Identifier.speechStyle:
//            self = .speechStyle
//        case Identifier.targetScript:
//            self = .targetScript
//        case Identifier.proficiencyLevel:
//            self = .proficiencyLevel
//        default:
//            self = .custom(rawValue)
//        }
//    }
//    
//    var rawValue: String {
//        switch self {
//        case .sourceText:
//            return Identifier.sourceText
//        case .sourceLanguage:
//            return Identifier.sourceLanguage
//        case .targetLanguage:
//            return Identifier.targetLanguage
//        case .contextText:
//            return Identifier.contextText
//        case .speechStyle:
//            return Identifier.speechStyle
//        case .targetScript:
//            return Identifier.targetScript
//        case .proficiencyLevel:
//            return Identifier.proficiencyLevel
//        case .custom(let string):
//            return string
//        }
//    }
//    
//    case sourceText
//    case sourceLanguage
//    case targetLanguage
//    case contextText
//    case speechStyle
//    case targetScript
//    case proficiencyLevel
//    case custom(String)
//
//    var placeholderString: String {
//        return "{HERMES::\(rawValue)}"
//    }
//    
//    enum Identifier {
//        static let sourceText = "SOURCE_TEXT"
//        static let sourceLanguage = "SOURCE_LANGUAGE"
//        static let targetLanguage = "TARGET_LANGUAGE"
//        static let targetScript = "TARGET_SCRIPT"
//        static let contextText = "SOURCE_CONTEXT"
//        static let speechStyle = "TARGET_SPEECH_STYLE"
//        static let proficiencyLevel = "ILR_LEVEL"
//    }
//    
//    struct PlaceholderKeyValue {
//        var key: MessageTemplateKey
//        var value: String?
//    }
//    
//    func toKeyValue(with value: String?) -> PlaceholderKeyValue {
//        return PlaceholderKeyValue(key: self, value: value)
//    }
//
//}
//
