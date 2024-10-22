//
//  Analysis.swift
//  Kana
//
//  Created by Paul Kim on 10/20/24.
//

import Observation
import LanguageKit


@Observable
class AnalysisViewModel<T: GrammaticalUnit> {
    var rootUnit: T
//    var availableAnalyses: [T.StructureCategory] = []
    var analyses: [any GrammaticalUnitAnalysis] = []
    init(rootUnit: T) {
        self.rootUnit = rootUnit
//        self.availableAnalyses = Self.determineAvailableAnalyses(for: T.self)
    }
    
//    static func determineAvailableAnalyses<U: GrammaticalUnitComposable>(for type: U.Type) -> [U.StructureCategory] {
//        var analyses = [type.StructureCategory.sentence]
//        var currentType: Any.Type = U.self
//        
//        while let composableType = currentType as? GrammaticalUnitComposable.Type {
//            if let subUnitType = composableType.SubUnits.self as? GrammaticalUnitComposable.Type {
//                analyses.append(subUnitType.StructureCategory.sentence)
//                currentType = subUnitType
//            } else {
//                break
//            }
//        }
//        
//        return analyses
//    }
    
//    var availableAnalysisOptions: [String] {
//        if let composable = T.self as? GrammaticalUnitComposable {
//            return composable.childTypes.map { String(describing: $0) }
//        } else {
//            return []
//        }
//    }
    
}

protocol GrammaticalUnitAnalysis<Unit> {
    associatedtype Unit: GrammaticalUnit
//    associatedtype L: Language
    typealias Language = Unit.Language
    
    var name: String { get }
    
    var unit: Unit { get }
    var translation: String { get }
    var transcription: String { get }
}

//@Observable
class SentenceAnalysis<Language: SentenceStructured>: GrammaticalUnitAnalysis {
    
    let name: String = ""
//    var sentence: Language.Sentence
    var unit: Language.Sentence
    
    var translation: String = ""
    var transcription: String = ""
    
    init(unit: Language.Sentence) {
        self.unit = unit
    }
}

class ClauseAnalysis<Language: ClauseStructured>: GrammaticalUnitAnalysis {
    let name: String = ""
    var unit: Language.Clause
    
    var translation: String = ""
    var transcription: String = ""
    
    init(unit: Language.Clause) {
        self.unit = unit
    }
}

class PhraseAnalysis<Language: PhraseStructured>: GrammaticalUnitAnalysis {
    let name: String = ""
    var unit: Language.Phrase
    
    var translation: String = ""
    var transcription: String = ""
    
    init(unit: Language.Phrase) {
        self.unit = unit
    }
}

class WordAnalysis<Language: WordStructured>: GrammaticalUnitAnalysis {
    let name: String = ""
    var unit: Language.Word
    
    var translation: String = ""
    var transcription: String = ""
    
    var category: String = ""
    
    init(unit: Language.Word) {
        self.unit = unit
    }
}

func test() {
    let word = Japanese.Word(content: "私は、あなたには、私の名前を呼んでください。", function: .adjectivalNoun)
    let analysis = WordAnalysis<Japanese>(unit: word)
    
    analysis.transcription = ""
}


protocol SentenceAnalyzable: Language {
    associatedtype SentenseAnalysis: GrammaticalUnitAnalysis
}

extension Japanese: SentenceAnalyzable {
    class SentenseAnalysis: GrammaticalUnitAnalysis {
        
        var unit: Japanese.Sentence
        
        var name: String = ""
        var translation: String = ""
        var transcription: String = ""
        
        init(unit: Japanese.Sentence, name: String, translation: String, transcription: String) {
            self.unit = unit
            self.name = name
            self.translation = translation
            self.transcription = transcription
        }
    }
}

