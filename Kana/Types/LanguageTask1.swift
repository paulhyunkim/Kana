//
//  LanguageTask.swift
//  Kana
//
//  Created by Paul Kim on 10/11/24.
//

import LanguageKit

/// Represents various language-related tasks that can be performed.
enum LanguageTask1 {
//    case moderation(input: LanguageDescriptor)
//    case categorization(text: String)
//    case grammaticalStructureAnalysis(text: String, structureTypes: String)
//    case jsonStructuredOutput(analysis: String, jsonSchema: String)
//    case translation(text: String, sourceLanguage: LanguageDescriptor.Type, targetLanguage: LanguageDescriptor.Type)
//    case translation(text: any GrammaticalUnit, targetLanguage: LanguageDescriptor.Type)
//    case translation(any PromptBuilder.TranslationTaskInputType)
    case transliteration(text: String, targetScript: Script)
    
//    case vocabularyIdentification(text: String, language: Language, proficiencyLevel: String)
//    case wordDefinition(word: String, language: Language)
//    case usage(word: String, language: Language)
    case sentenceAnalysis(sentence: String, language: LanguageDescriptor)
    case definition(text: String)
//    case correction(text: String, language: Language)

}


enum Language {
    typealias JapaneseLanguage = Japanese
//    typealias EnglishLanguage = English
}
