////
////  Notepad.swift
////  Kana
////
////  Created by Paul Kim on 10/11/24.
////
//
//import Foundation
//
//
//// I'm building an iOS/macOS app to help users learn a new language
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
//// but i have many questions about the best way to organize code
//
//class LanguageAssistantService {
//    private let client: LLMClient
//    private let promptBuilder: PromptBuilder
//    
//    init(client: LLMClient, promptBuilder: PromptBuilder) {
//        self.client = client
//        self.promptBuilder = promptBuilder
//    }
//    
//    // some function(s) the app will call to run some language task on some text
//    // is it better to design this is in a way where we have individual functions for each kind of task? or do we want a single function that takes an instance of a LanguageTask? where do store the parameter values - pass them directly into the function or inside of an implementation of a LanguageTask?
//    
//}
//
//
//class PromptBuilder {
//    
//    // some function(s) to build a prompt for a specific language task
//    // is it better to design this is in a way where we have individual functions for each kind of task? or do we want a single function that can be used for all kinds of tasks the app will have
//}
//
//protocol LLMClient {
//    // i'm not sure if this is an oversimplification, but i'm thinking the responsibility of the LLMClient is really only just to send a prompt to the LLM
//    func send(prompt: Prompt) -> AsyncThrowingStream<String, Error>
//}
//
//// i created LLMResult with the idea of leveraging open ai's ability to respond with structured outputs (json). this way we can directly get typed results
//protocol LLMResult: Codable {
//    static var structureDescription: String { get }
//}
//
//extension LLMClient {
//    
//    func send(prompt: Prompt) async throws -> String {
//        var resultString = ""
//        
//        for try await partialResult in send(prompt: prompt) {
//            resultString += partialResult
//        }
//        return resultString
//    }
//    
//    func send<ResultType: LLMResult>(prompt: LLMPrompt) async throws -> ResultType {
//        var updatedPrompt = prompt
//        
//        let resultString = try await send(prompt: updatedPrompt)
//
//        guard let jsonData = resultString.data(using: .utf8) else {
//            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid JSON Format"))
//        }
//    
//        let decodedResult = try JSONDecoder().decode(ResultType.self, from: jsonData)
//        return decodedResult
//    }
//    
//}
//
//// the following is what i was exploring in how to separate LLM specific task implementations, but there are some potential issues here:
//// on one hand, by using protocols and typing tasks, i can constrain specific input types according to the task i want to perform. for example, i don't want to be able to run a definition task on a sentence.
//// on the other hand, now i've created other places where LLM specific logic can live.
//// then there's the question of who creates these tasks? if i have an OpenAI translation task, who creates it? the original idea was to be able to simplify LanguageAssistantService by having a single function, like performTask(_ task: LanguageTask) that takes any instance of a LanguageTask and knows how to handle it, but now places outside need to know about OpenAI tasks, which is not ideal.
//
//protocol LanguageTask {
//    associatedtype Input: LanguageTaskInput
//    associatedtype Output
//    
//    func execute(input: Input) -> Output
//}
//
//struct ModerationTask<Input: ModerationTaskInput>: LanguageTask {
//
//    func execute(input: Input) -> ModerationResult {
//        // Implementation here
//        return ModerationResult()
//    }
//}
//
//struct CategorizationTask: LanguageTask {
//
//    func execute(input: SimpleText) -> String {
//        // Implementation here
//        return "Category"
//    }
//}
//
//struct TranslationTask<Input: TranslationTaskInput>: LanguageTask {
//
//    let sourceLanguage: Language
//    let targetLanguage: Language
//    
//    func execute(input: Input) -> TranslationResult {
//        // Implementation here
//        return TranslationResult()
//    }
//}
//
//struct TransliterationTask<Input: TransliterationTaskInput>: LanguageTask {
//
//    let targetScript: Script
//    
//    func execute(input: Input) -> TransliterationResult {
//        // Implementation here
//        return TransliterationResult()
//    }
//}
//
//struct AnalysisTask<Input: AnalysisTaskInput>: LanguageTask {
//    let language: Language
//    
//    func execute(input: Input) -> AnalysisResult {
//        // Implementation here
//        return AnalysisResult()
//    }
//}
//
//struct DefinitionTask<Input: DefinitionTaskInput>: LanguageTask {
//    
//    func execute(input: Input) -> DefinitionResult {
//        // Implementation here
//        return DefinitionResult()
//    }
//}
//
//// based on everything i've told you, please suggest an app architecture, data modeling, implementations for all of these entities
//// also if you have any questions, please let me know.
//
//
//
///// A builder for constructing prompts for different language tasks.
////class LLMPromptBuilder {
////    func buildPrompt(for task: LanguageTask) -> LLMPrompt {
////        switch task {
////        case let .translation(text, sourceLanguage, targetLanguage, context):
////            return [
////                LLMMessage(role: .system, content: "You are a helpful translator."),
////                LLMMessage(role: .user, content: "Translate the following text from \(sourceLanguage.name) to \(targetLanguage.name):\n\n\(text)\n\nContext: \(context ?? "None")")
////            ]
////        case let .transliteration(text, targetScript):
////            return [
////                AIMessage(role: .system, content: "You are a helpful transliterator."),
////                AIMessage(role: .user, content: "Transliterate the following text into \(targetScript.name) script:\n\n\(text)")
////            ]
////        case let .vocabularyIdentification(text, language, proficiencyLevel):
////            return [
////                AIMessage(role: .system, content: "You are a helpful language teacher."),
////                AIMessage(role: .user, content: "Identify vocabulary words in the following \(language.name) text, considering a proficiency level of \(proficiencyLevel):\n\n\(text)")
////            ]
////        case let .wordDefinition(word, language):
////            return [
////                AIMessage(role: .system, content: "You are a helpful dictionary."),
////                AIMessage(role: .user, content: "Provide a definition for the following \(language.name) word:\n\n\(word)")
////            ]
////        case let .usage(word, language):
////            return [
////                AIMessage(role: .system, content: "You are a helpful language usage expert."),
////                AIMessage(role: .user, content: "Provide examples of how to use the \(language.name) word '\(word)' in different contexts.")
////            ]
////        case let .sentenceAnalysis(sentence, language):
////            return [
////                AIMessage(role: .system, content: "You are a helpful language analyst."),
////                AIMessage(role: .user, content: "Analyze the following \(language.name) sentence, providing information about its structure, grammar, and any idiomatic expressions:\n\n\(sentence)")
////            ]
////        case let .correction(text, language):
////            return [
////                AIMessage(role: .system, content: "You are a helpful language correction tool."),
////                AIMessage(role: .user, content: "Correct any errors in the following \(language.name) text:\n\n\(text)")
////            ]
////        }
////    }
////}
//
/////// Represents a message in a conversation with an AI language model.
////struct AIMessage {
////    let role: AIMessageRole
////    let content: String
////}
////
/////// Represents the role of a message in a conversation with an AI language model.
////enum AIMessageRole: String {
////    case system
////    case user
////    case assistant
////}
//
//// Example usage:
//// let client = OpenAIClient(apiKey: "your-api-key-here")
//// let promptBuilder = PromptBuilder()
//// let languageAssistant = LanguageAssistantService(client: client, promptBuilder: promptBuilder)
////
//// let task = LanguageTask.translation(text: "Hello, world!", sourceLanguage: .english, targetLanguage: .spanish, context: nil)
//// let responseStream = languageAssistant.performLanguageTask(task)
