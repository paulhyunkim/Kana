//
//  LanguageProtocols.swift
//  Language
//
//  Created by Paul Kim on 10/20/24.
//

import Foundation

public enum WordOrder {
    // list languages that have these patterns
    case SVO
    case SOV
    case VSO
    case VOS
    case OVS
    case OSV
}


public struct Script {
    var name: String
    var code: ISOCode
    var category: Category
    var directionality: Directionality
    var hasCase: Bool
    
    // ISO 15924 defines codes for the representation of names of scripts.
    struct ISOCode {
        var letterCode: String
        var numericCode: Int
    }
    
    enum Category {
        case alphabetic, syllabic, logographic
    }
    
    enum Directionality {
        case leftToRight, rightToLeft, verticalLeftToRight, verticalRightToLeft, mixed([Directionality])
    }
}

public protocol HonorificCategoryProtocol: CaseIterable { }
public protocol SpeechStyleProtocol: SyntacticCategoryProtocol { }
public protocol LanguageProficiencyLevelProtocol: SyntacticCategoryProtocol { }
public protocol LanguageFeaturesProtocol { }

public protocol HonorificBasedLanguage {
    associatedtype HonorificCategory: HonorificCategoryProtocol
}

public protocol WrittenLanguageProtocol {
    var scripts: [Script] { get }
}

public protocol SpokenLanguageProtocol {
    var hasTones: Bool { get }
}

public extension LanguageDescriptor {
    var hasHonorifics: Bool {
        self is (any HonorificBasedLanguage)
    }
}

/// A protocol indicating that a language has sentences as part of its syntactic structure.
/// Conforming types must define a `Sentence` type that represents a complete syntactic structure in the language.
public protocol SentenceStructured {
    /// The type representing a sentence in the language.
    associatedtype Sentence: SyntacticUnit
}

/// A protocol indicating that a language has clauses as part of its syntactic structure.
/// Conforming types must define a `Clause` type that represents a grammatical clause.
public protocol ClauseStructured {
    /// The type representing a clause in the language.
    associatedtype Clause: SyntacticUnit
}

/// A protocol indicating that a language has phrases as part of its syntactic structure.
/// Conforming types must define a `Phrase` type that represents a group of words functioning as a unit.
public protocol PhraseStructured {
    /// The type representing a phrase in the language.
    associatedtype Phrase: SyntacticUnit
}

/// A protocol indicating that a language has words as part of its syntactic structure.
/// Conforming types must define a `Word` type that represents a word in the language.
public protocol WordStructured {
    /// The type representing a word in the language.
    associatedtype Word: SyntacticUnit
}

/// A protocol indicating that a language has morphemes as part of its syntactic structure.
/// Conforming types must define a `Morpheme` type that represents a morphological unit in the language.
public protocol MorphemeStructured {
    /// The type representing a morpheme in the language.
    associatedtype Morpheme: MorphologicalUnit
}

/// A protocol indicating that a language uses particles as part of its syntactic structure.
/// Conforming types must define a `Particle` type that represents these grammatical markers.
public protocol ParticleUsing {
    /// The type representing a particle in the language.
    associatedtype Particle: SyntacticUnit
}

/// A protocol representing a language and its fundamental characteristics.
/// Conforming types must specify language attributes.
public protocol LanguageDescriptor {

    /// The name of the language (e.g., "English", "Japanese").
    var name: String { get }

    /// The ISO 639-1 code of the language (e.g., "en" for English, "ja" for Japanese).
    var code: String { get }

    /// The typical word order of the language, such as SOV (Subject-Object-Verb) or SVO (Subject-Verb-Object).
    var wordOrder: WordOrder { get }

    /// Indicates whether the language has grammatical gender distinctions (e.g., masculine, feminine).
    var hasGrammaticalGender: Bool { get }
}



//typealias SentenceAnalysis<S: Sentence> = SentenceAnalysis<Sentence<Language: SentenceAware>>



///// Represents a sentence in a specific language.
///// A sentence is typically a group of words that expresses a complete thought.
//struct Sentence<Language: SentenceStructuredLanguage> {
//
//    /// The textual content of the sentence.
//    var content: String
//
//    /// The grammatical category of the sentence, as defined by the language.
//    var category: Language.SentenceCategory
//}
//
///// Represents a clause in a specific language.
///// A clause is a group of words that contains a subject and a predicate.
//struct Clause<Language: ClauseStructuredLanguage> {
//
//    /// The textual content of the clause.
//    var content: String
//
//    /// The grammatical category of the clause, as defined by the language.
//    var category: Language.ClauseCategory
//}
//
///// Represents a phrase in a specific language.
///// A phrase is a group of words that functions as a single unit within a sentence.
//struct Phrase<Language: PhraseStructuredLanguage> {
//
//    /// The textual content of the phrase.
//    var content: String
//
//    /// The grammatical category of the phrase, as defined by the language.
//    var category: Language.PhraseCategory
//}
//
///// Represents a word in a specific language.
///// A word is the smallest unit of language that can stand alone and convey meaning.
//struct Word<Language: WordStructuredLanguage> {
//
//    /// The textual content of the word.
//    var content: String
//
//    /// The grammatical category of the word, as defined by the language.
//    var category: Language.WordCategory
//}
//
///// Represents a particle in a specific language.
///// Particles are distinguished from words in this structure due to their unique grammatical role, particularly in languages like
///// Japanese where they are crucial for indicating grammatical relationships but may not be considered full words in a traditional sense.
///// In linguistic terms, particles belong to a special class of “function words” (as opposed to “content words”) because they serve a
///// grammatical purpose rather than carrying specific lexical meaning.
//struct Particle<Language: ParticleStructuredLanguage> {
//    /// The textual content of the particle.
//    var content: String
//
//    /// The grammatical category of the particle, as defined by the language.
//    var category: Language.ParticleCategory
//}
//
//
//struct Morpheme<Language: MorphemeStructuredLanguage> {
//    var content: String
//    var category: Language.MorphemeCategory
////    var function: String
////    var usage: String?
////    var examples: [String]
//}
