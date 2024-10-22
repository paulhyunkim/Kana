////
////  Analysis.swift
////  Kana
////
////  Created by Paul Kim on 10/15/24.
////
//
//// NOTE: - need to think about bi-directional translations
//
//class ClauseAnalysis {
//    
//    var sourceText: String
//    var sourceLanguage: Language
//    var targetLanguage: Language
//    var explanationLanguage: Language
//    var learningLanguage: Language
//    
//    var transcription: ClauseTranscription? // optional because the source text may not need to transcribed if the source text is the explanation language (e.g. if the source text is english, there is no need to transcribe to latin)
//    var translations: [ClauseTranslation] // array because there may be multiple translations if the source text is ambiguous
//    
//}
//
//class ClauseTranslation {
//    var text: String // the translated text
//    var meaning: String // overall meaning of the clause
//    var note: String? // optional property if there are additional notes about the translation
//    
//    var transcription: ClauseTranscription
//    
//    var components: [Component]
//    
//    class Component {
//        var text: String
//        var partOfSpeech: PartOfSpeech
//        var definition: String
//        var grammaticalFunction: String
//    }
//}
//
//class ClauseTranscription {
//    var components: [Component]
//    
//    class Component {
//        var text: String
//        var explanationLanguageTranscription: String // for transcriptions of a text to the explanation language (e.g. japanese to latin (romanization))
//        var learningLanguageTranscription: String? // for transcribing logographs to a syllabic script in the learning language (e.g. Kanji to hiragna). optional because there is no need to transcribe syllablic script (e.g. hiragana to hiragana)
//    }
//
//}
//
//class ClauseGrammar {
//    
//    var components: [GrammarComponent]
//    
//    
//}
//
//
//class ClauseComponent {
//    var words: [Word]
//    
//}
//
//
//
//
////class Analysis {
////    var transcription: [Transcription]
////    
////    class Transcription {
////        var text: String
////        var explanationLanguageTranscription: String
////        var learningLanguageTranscription: String
////    }
////    
////    class Translatation {
////        var text: String
////        v
////    }
////}
//
//class Analysis {
//    var sourceText: String
//    var sourceLanguage: Language
//    var targetLanguage: Language
//    var explanationLanguage: Language
//    var learningLanguage: Language
//    
//    var sourceClause: Clause
//    var resultCauses: [Clause]
//}
//
//class Clause {
//
//    var translation: Translation
//    var words: [Word]
//    
//    class Word {
//        var text: String
//        var translation: Translation
//        var transcription: String
//        var
//        var partOfSpeech: PartOfSpeech
//        var grammaticalFunction: String
//        var notes: String
//    }
//}
//
//class Word {
//    var text: String
//    var translation: Translation
//    var transcription: String
//    var
//    var partOfSpeech: PartOfSpeech
//    var grammaticalFunction: String
//    var notes: String
//}
//
//class TranscriptionGroup {
//    
//    var items: [TranscriptionItem]
//    
//}
//
//class Transcription {
//    var sourceText: String
//    var transcription:
//}
//
//class Translation { // generic so it can be used on words or clauses
//    var sourceText: String
//    var translation: String
//    var meaning: String?
//}
//
//class Sentence {
//    
//    var text: String
//    var clauses: [Clause]
//    
//    class Clause {
//        var text: String
//        var partsOfSpeech: [PartOfSpeech]
//    
//        class PartOfSpeech {
//            var text: String
//            var category: String
//            var morphemes: [Morpheme]
//            
//            class Morpheme {
//                var text: String
//                var function: String
//            }
//        }
//        
//    }
//}
//
//
