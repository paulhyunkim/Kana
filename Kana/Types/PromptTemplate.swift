//
//  PromptTemplate.swift
//  Kana
//
//  Created by Paul Kim on 10/27/24.
//

import Foundation
import LanguageKit

// MARK: - Types
struct PromptTemplate  {
    let messages: [Message]
    
    struct Message {
        let role: String
        let sections: [Section]
    }
    
    struct Section {
        let name: String
        let content: String
        let requiredParameters: Set<String>
        let optionalParameters: Set<String>
    }
    
    
}

protocol LanguageTask {
    associatedtype PlaceholderKey: RawRepresentable<String>, Hashable
    static var templateName: String { get }
    var placeholderValues: [PlaceholderKey: String?] { get }
}

// Concrete task types
struct TranslationTask<Language: LanguageDescriptor>: LanguageTask {
    static var templateName: String { "TranslationTemplate" }
    
    enum PlaceholderKey: String {
        case targetLanguage = "TARGET_LANGUAGE"
        case sourceText = "SOURCE_TEXT"
        case additionalGuidelines = "ADDITIONAL_GUIDELINES"
        case additionalParameters = "ADDITIONAL_PARAMETERS"
    }
    
    var sourceText: String
    var additionalGuidelines: String?
    var additionalParameters: String?
    
    init(sourceText: String, additionalGuidelines: String? = nil, additionalParameters: String? = nil) {
        self.sourceText = sourceText
        self.additionalGuidelines = additionalGuidelines
        self.additionalParameters = additionalParameters
    }
    
    var placeholderValues: [PlaceholderKey: String?] {
        [
            .sourceText: sourceText,
            .targetLanguage: Language.name,
            .additionalGuidelines: additionalGuidelines,
            .additionalParameters: additionalParameters
        ]
    }
}

