//
//  GrammarProtocols.swift
//  Language
//
//  Created by Paul Kim on 10/20/24.
//


// MARK: - Base protocols

/// In linguistics, a string is a sequence of characters, which can include letters, numbers, symbols, or spaces. A string doesn't
/// necessarily need to carry meaning or be functional in any language. It's simply a generic term for any sequence of characters.
///
/// Key points:
/// - They can be of any length, from a single character to multiple words or sentences.
/// - They don't need to follow any grammatical rules or make semantic sense.
/// - They can include characters from any writing system (alphabets, logographs, syllabaries, etc.).
public protocol LanguageString {
    var content: String { get }
}

/// A grammatical unit is a broad term that refers to any meaningful element in the grammatical structure of a language.
/// It encompasses both morphological and syntactic units, ranging from the smallest meaningful parts of words to entire sentences.
///
/// Key points:
/// - Includes both morphological and syntactic units
/// - Represents elements at various levels of linguistic analysis (e.g. morphemes, words, phrases, clauses, sentences)
/// - Provides a framework for analyzing language structure holistically
/// - Useful in discussions of grammar that span both word-internal structure (morphology) and sentence structure (syntax)
/// - Grammatical units form a hierarchy
public protocol GrammaticalUnit: LanguageString {
    
}

/// A syntactic unit is any linguistic element that can play a role in the syntactic structure of a sentence. These units can be words,
/// phrases, or clauses that function as a single entity in relation to other parts of the sentence.
///
/// Key points:
/// - Hierarchy: Syntactic units can be nested within larger units, creating a hierarchical structure in sentences.
/// - Function: They perform specific grammatical functions within a sentence (e.g., subject, predicate, object).
/// - Variability: The size of a syntactic unit can vary from a single word to an entire clause.
/// - Constituent structure: Syntactic units are often referred to as "constituents" in linguistic analysis.
///
/// Examples in English grammar:
/// - Words: The smallest independent syntactic units.
///     - "cat," "run," "quickly"
/// - Phrases: Groups of words that function together as a unit, but don't contain both a subject and a predicate.
///     - Noun phrase: "the big red ball"
///     - Verb phrase: "is running quickly"
///     - Prepositional phrase: "under the table"
/// - Clauses: Units that contain a subject and a predicate.
///     - Indepedent clause: "The cat sleeps."
///     - Dependent clause: "while the dog barks"
/// - Sentences: Complete syntactic units that express a full thought.
///     - "The cat sleeps while the dog barks."
public protocol SyntacticUnit: GrammaticalUnit {
    
}

/// A morphological unit, or morpheme, is the smallest meaningful unit in a language. It is a fundamental concept in morphology,
/// which deals with the internal structure of words and how they are formed.
///
/// Key points:
/// - Smallest unit of meaning: Morphemes cannot be divided into smaller meaningful parts.
/// - Word formation: Morphemes combine to form words.
/// - Types: Can be free (stand alone as words) or bound (must attach to other morphemes).
/// - Function: Can be lexical (carry primary meaning) or grammatical (modify meaning or indicate relationships).
///
/// Examples in English grammar:
/// - Free morphemes: "cat", "run", "happy"
/// - Bound morphemes:
///     - Prefixes: "un-" in "unhappy"
///     - Suffixes: "-s" in "cats", "-ed" in "walked"
/// - Root morphemes: "teach" in "teacher"
/// - Inflectional morphemes: "-s" for plural, "-ed" for past tense
/// - Derivational morphemes: "-er" in "teacher" (changes verb to noun)
public protocol MorphologicalUnit: GrammaticalUnit {
    
}

// MARK: - Grammatical unit categories

/// A marker protocol representing a category of grammatical structure.
/// Used to classify grammatical units based on their structural role.
public protocol GrammaticalStructureCategory { }

/// A marker protocol representing a category of grammatical function.
/// Used to classify grammatical units based on their functional role.
public protocol GrammaticalFunctionCategory { }

/// A protocol for elements that can be associated with a grammatical structure category.
/// Conforming types must specify a structure category, representing their structural classification within the grammar.
public protocol GrammaticalStructureCategorizable {
    /// The category representing the grammatical structure of the element.
    associatedtype StructureCategory: GrammaticalStructureCategory
    var structure: StructureCategory { get }
}

/// A protocol for elements that can be associated with a grammatical function category.
/// Conforming types must specify a function category, representing their grammatical role within a syntactic unit.
public protocol GrammaticalFunctionCategorizable {
    /// The category representing the grammatical function of the element.
    associatedtype FunctionCategory: GrammaticalFunctionCategory
    var function: FunctionCategory { get }
}


public protocol SyntacticCategoryProtocol/*: CaseIterable*/ { }

public protocol SentenceCategoryProtocol: SyntacticCategoryProtocol { }
public protocol ClauseCategoryProtocol: SyntacticCategoryProtocol { }
public protocol PhraseCategoryProtocol: SyntacticCategoryProtocol { }
public protocol WordCategoryProtocol: SyntacticCategoryProtocol { }
public protocol ParticleCategoryProtocol: SyntacticCategoryProtocol { }
public protocol MorphemeCategoryProtocol: SyntacticCategoryProtocol { }


// MARK: - Grammatical unit components

//protocol GrammaticalUnitComposable: GrammaticalUnit {
//    associatedtype GrammaticalComponentUnits: GrammaticalUnitCollection
//    var children: [GrammaticalComponentUnits] { get set }
//}

public protocol GrammaticalUnitComposable: GrammaticalUnit {
    static var childTypes: [GrammaticalUnit.Type] { get }
}

//// Protocol to represent either a single GrammaticalUnit type or an array of them
//protocol GrammaticalUnitCollection {
//    
//}
//
//// Extension to make a single GrammaticalUnit conform to GrammaticalUnitCollection
//extension GrammaticalUnit {
//    func allUnits() -> [any GrammaticalUnit] { [self] }
//}

// Extension to make an array of GrammaticalUnits conform to GrammaticalUnitCollection
//extension Array: GrammaticalUnitCollection where Element: GrammaticalUnit {
//    func allUnits() -> [any GrammaticalUnit] { self }
//}

// MARK: - Grammatical unit typealiases

/// A typealias representing the sentence structure of a given language.
///
/// This typealias allows access to the `Sentence` type associated with languages that conform to `SentenceStructured`.
/// - Parameter Language: A language type that conforms to `SentenceStructured`.
public typealias Sentence<Language: SentenceStructured> = Language.Sentence

/// A typealias representing the clause structure of a given language.
///
/// This typealias allows access to the `Clause` type associated with languages that conform to `ClauseStructured`.
/// - Parameter Language: A language type that conforms to `ClauseStructured`.
public typealias Clause<Language: ClauseStructured> = Language.Clause

/// A typealias representing the phrase structure of a given language.
///
/// This typealias allows access to the `Phrase` type associated with languages that conform to `PhraseStructured`.
/// - Parameter Language: A language type that conforms to `PhraseStructured`.
public typealias Phrase<Language: PhraseStructured> = Language.Phrase

/// A typealias representing the word structure of a given language.
///
/// This typealias allows access to the `Word` type associated with languages that conform to `WordStructured`.
/// - Parameter Language: A language type that conforms to `WordStructured`.
public typealias Word<Language: WordStructured> = Language.Word

/// A typealias representing the morpheme structure of a given language.
///
/// This typealias allows access to the `Morpheme` type associated with languages that conform to `MorphemeStructured`.
/// - Parameter Language: A language type that conforms to `MorphemeStructured`.
public typealias Morpheme<Language: MorphemeStructured> = Language.Morpheme

/// A typealias representing the particle structure of a given language.
///
/// This typealias allows access to the `Particle` type associated with languages that conform to `ParticleUsing`.
/// - Parameter Language: A language type that conforms to `ParticleUsing`.
public typealias Particle<Language: ParticleUsing> = Language.Particle




protocol Translatable {
    associatedtype TranslationLanguage: Language
    var translation: String { get }
}

protocol Explainable {
    associatedtype ExplanationLanguage: Language
    var explanation: String { get }
}


class Analysis<S: SyntacticUnit> {
    let unit: S
    
    init(_ unit: S) {
        self.unit = unit
    }
}
