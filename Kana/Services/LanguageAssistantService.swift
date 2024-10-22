////
////  LanguageAssistantService.swift
////  Kana
////
////  Created by Paul Kim on 10/11/24.
////
//
//// I'm building an app to help users learn a new language
//// the basic idea is that instead of providing lessons in a linear manner, the app will serve as a translation tool that will teach users language fundamentals for the specific text they want translated. for example, if a user wants to learn how to say "the red fox jumped" in the language they're learning, the app will not only provide the translation but also teach the user things things like how to conjugate verbs to past tense, what the individual words mean, the grammatical order of things, etc.
//
//// i'm going to refer to the multiple languages in the app:
//// - teachingLanguage: the language the user wants to be taught with (in most cases, the native language of the user)
//// - learningLanguage: the language the user wants to learn (i'm not sure if learning language is the best nomenclature, but if you can suggest something better, let me know)
//// - sourceLanguage: the language of the text that the user wants to learn something about (usually some text the user wants translated to the target language). this could be either the teachingLanguage or the learningLanguage
//// - targetLanguage: the language of the text outputted after we run some language task on the source text. this could be either the teachingLanguage or the learningLanguage
//
//// here is an example of how i imagine the app to work.
//// let's say the user is an english speaker who wants to learn japanese. userLanguage is English and the learningLanguage is Japanese.
//
//// the user types in some English text into a text field and hits a button
//// if the text is a group of words made up multiple parts of speech, let's say "The red fox jumped", i want to display the Japanese translation
//// i also want to color the words/components in the Japanese translation according to their part of speech so that the user can learn something about the translation. this way the user can learn which japanese word means "fox" or "jumped"
//// i want the individual Japanese text components tappable so that a modal/popover is displayed that shows the definition of the word and things like, if the part of speech is a verb, what makes the verb past tense (Japanese conjugation), etc.
//
//// this should work for any combination of source and target languages, because as an english speaker who wants to learn japanese, the user may want to type in japanese text that he does not understand and wants to know what it means in english. in this case, i want to provide the english translation, but also provide the same kind of grammar lessons on the source text.
//
//// so far, this is what i have in terms of app architecture:
//// - LanguageAssistantService: an app service that holds a reference to an implememtation of LLMClient and calls it to run some kind of language task on a provided text. LLMClient is a protocol in order to decouple LLM specific logic from LanguageAssistantService, which is agnostic to which LLM we use.
//// - PromptBuilder: builds prompts for specific language tasks using PromptTemplates and provided values.
//// - LLMClient: a protocol that defines the interface for the entity responsible for making requests to an LLM service. in my app, i'm going to start with open ai, OpenAIClient.
//
//// i want the app to be built to be extensible for future features and scalable.
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
