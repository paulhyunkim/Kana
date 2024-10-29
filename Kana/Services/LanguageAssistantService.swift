////
////  LanguageAssistantService.swift
////  Kana
////
////  Created by Paul Kim on 10/11/24.
////
//
///// A service that handles various language learning and assistance tasks.
//class LanguageAssistantService {
//    private let client: LLMClient
//    private let promptBuilder: PromptBuilder
//    
//    /// Initializes a new instance of LanguageAssistantService.
//    /// - Parameters:
//    ///   - client: The client used to communicate with the language model.
//    ///   - promptBuilder: The builder used to construct prompts for different tasks.
//    init(client: LLMClient, promptBuilder: PromptBuilder) {
//        self.client = client
//        self.promptBuilder = promptBuilder
//    }
//    
//    func analyze(_ text: String) {
//        // first moderate
//        // then categorize
//        
//    }
//    
//    func analyze<>
//    
//    
//}
//
//
//class PromptBuilder {
//    
//}
//
//enum LanuageTask {
//    case moderation(String)
//    case categorization(String)
//    case translation(text: Translatable, targetLanguage: Language)
//    case transliteration(text: Transliterable, targetScript: Script)
//    case definition(text: Definable)
//    case grammarAnalysis(text: GrammarAnalyzable)
//}
//
//protocol LanguageComponent {
//    var text: String { get }
//}
//
//protocol Definable { }
//
//protocol Translatable { }
//
//protocol Transliterable { }
//
//protocol GrammarAnalyzable { }
//
//struct SimpleText: LanguageComponent {
//    var text: String
//}
//    
//struct Word: LanguageComponent {
//    var text: String
//}
//
//struct DefinitionResult {
//    var sourceLanguage: Language
//    var targetLanguage: Language
//    var teachingLanguage: Language
//    var learningLanguage: Language
//    
//    var sourceText: String
//    var definitions: [Definition]
//    
//    struct Definition {
//        var meaning: String
//        
//        struct Example {
//            var sentence: String
//            var translation: String
//        }
//    }
//}
//
//struct TranslationResult {
//    
//    var sourceLanguage: Language
//    var targetLanguage: Language
//    var instructionalLanguage: Language
//    var studyLanguage: Language
//    
//    var sourceText: String
//    var translations: [Translation]
//    
//    struct Translation {
//        var sentenceComponent: [SentenceComponent]
//
//        var meaning: String
//        
//        struct SentenceComponent {
//            // A part of speech can be comprised of multiple words
//            var words: [Word]
//            var transcription: String?
//            var partOfSpeech: PartOfSpeech
//            var contextualDefinition: String
//            
//            struct Word {
//                var morphemes: [Morpheme]
//                
//                struct Morpheme {
//                    var text: String
//                    var phoneticTranscription: String?
//                    var logographTranscription: String?
//                }
//            }
//        }
//    }
//    
//}
//
//struct GrammarAnalysis {
//    
//    var sourceLanguage: Language
//    var targetLanguage: Language
//    var teachingLanguage: Language
//    var learningLanguage: Language
//    
//    var sourceText: String
//    var components: [Component]
//    
//    struct Component {
//        var partOfSpeech: PartOfSpeech
//        
//    }
//}
