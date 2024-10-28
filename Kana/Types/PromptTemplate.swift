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

extension PromptTemplate.Section {
    func replacingPlaceholders(with values: [String: String]) -> String {
        var content = self.content
        
        // Replace required parameters
        for param in requiredParameters {
            if let value = values[param] {
                content = content.replacingOccurrences(of: "{{\(param)}}", with: value)
            }
        }
        
        // Replace optional parameters
        for param in optionalParameters {
            if let value = values[param] {
                content = content.replacingOccurrences(of: "{{\(param)}}", with: value)
            }
        }
        
        return content
    }
}

//extension PromptTemplate.Message {
//    func build(with values: [String: String]) -> String {
//        sections
//            .filter { section in
//                // Keep section if it has any required parameters
//                !section.requiredParameters.isEmpty ||
//                // Or if it has optional parameters that have values
//                section.optionalParameters.contains(where: values.keys.contains)
//            }
//            .map { section in
//                let processedContent = section.replacingPlaceholders(with: values)
//                    .components(separatedBy: .newlines)
//                    .map { $0.trimmingCharacters(in: .whitespaces) }
//                    .filter { !$0.isEmpty }
//                    .joined(separator: "\n")
//                
//                return """
//                <\(section.name)>
//                \(processedContent)
//                </\(section.name)>
//                """
//            }
//            .joined(separator: "\n\n")
//    }
//}

extension PromptTemplate.Message {
    func build(with values: [String: String]) -> String {
        sections
            .filter { section in
                // Keep section if:
                // 1. It has any content (non-optional sections without parameters)
                // 2. OR if it has required parameters (which we know have values due to validation)
                // 3. OR if it has optional parameters with provided values
                !section.content.trimmingCharacters(in: .whitespaces).isEmpty ||
                !section.requiredParameters.isEmpty ||
                section.optionalParameters.contains(where: values.keys.contains)
            }
            .map { section in
                let processedContent = section.replacingPlaceholders(with: values)
                    .components(separatedBy: .newlines)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
                    .joined(separator: "\n")
                
                return """
                <\(section.name)>
                \(processedContent)
                </\(section.name)>
                """
            }
            .joined(separator: "\n\n")
    }
}
