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
    associatedtype Language: LanguageDescriptor
    var content: String { get set }
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
public protocol GrammaticalUnit: LanguageString, Codable {

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
public protocol GrammaticalStructureCategory: CaseIterable, RawRepresentable<String>, Codable {

}

/// A marker protocol representing a category of grammatical function.
/// Used to classify grammatical units based on their functional role.
public protocol GrammaticalFunctionCategory: CaseIterable, RawRepresentable<String>, Codable {

}

/// A protocol for elements that can be associated with a grammatical structure category.
/// Conforming types must specify a structure category, representing their structural classification within the grammar.
public protocol GrammaticalStructureCategorizable {
    /// The category representing the grammatical structure of the element.
    associatedtype StructureCategory: GrammaticalStructureCategory
    var structure: StructureCategory { get set }
}

/// A protocol for elements that can be associated with a grammatical function category.
/// Conforming types must specify a function category, representing their grammatical role within a syntactic unit.
public protocol GrammaticalFunctionCategorizable {
    /// The category representing the grammatical function of the element.
    associatedtype FunctionCategory: GrammaticalFunctionCategory
    var function: FunctionCategory { get set }
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
    associatedtype Child: GrammaticalUnit where Child.Language == Language

    var children: [Child] { get }
    
    /// Returns all descendants of the specified grammatical unit type in the unit's structure.
    /// - Parameter type: The type of grammatical unit to search for
    /// - Returns: An array of all matching grammatical units in the unit's hierarchy
    func descendants<T: GrammaticalUnit>(ofType type: T.Type) -> [T]
}

extension GrammaticalUnitComposable where Self: GrammaticalUnit, Child: GrammaticalUnit {
    public func descendants<T: GrammaticalUnit>(ofType type: T.Type) -> [T] {
        var results: [T] = []

        for child in children {
            if let match = child as? T {
                results.append(match)
            }
            
            if let composableChild = child as? any GrammaticalUnitComposable {
                results.append(contentsOf: composableChild.descendants(ofType: type))
            }
        }

        return results
    }
}

//// Default implementation for composable units
//extension GrammaticalUnitComposable {
//    public func descendants<T: GrammaticalUnit>(ofType type: T.Type) -> [T] {
//        var results: [T] = []
//
//        // Process each child
//        for child in children {
//            // If the child matches the requested type, add it
//            if let match = child as? T {
//                results.append(match)
//            }
//            
//            // Recursively check for descendants if the child is composable
//            if let composableChild = child as? any GrammaticalUnitComposable {
//                results.append(contentsOf: composableChild.descendants(ofType: type))
//            }
//        }
//        
//        return results
//    }
//}


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
    associatedtype TranslationLanguage: LanguageDescriptor
    var translation: String { get }
}

protocol Explainable {
    associatedtype ExplanationLanguage: LanguageDescriptor
    var explanation: String { get }
}


class Analysis<S: SyntacticUnit> {
    let unit: S
    
    init(_ unit: S) {
        self.unit = unit
    }
}

public protocol GrammaticalUnitCodable: Codable, GrammaticalUnit {
    
//    associatedtype CodingKeys: CodingKey
   
//    init(from decoder: Decoder) throws
    
}


extension GrammaticalUnitCodable {
    
//    init<Language: SentenceStructured>(from decoder: Decoder) throws where Language.Sentence == Self {
//        self = try Language.Sentence.init(from: decoder)
//    }
    
}

//extension GrammaticalUnit where Language: SentenceStructured {
//    
//    init(from decoder: Decoder) throws {
//        self.init()
//        
////        let container = try decoder.container(keyedBy: FooCodingKeys.self)
////        self.prop1 = try container.decodeIfPresent(String.self, forKey: .prop1)
////        self.prop2 = try container.decodeIfPresent(Bool.self, forKey: .prop2)
////        self.prop3 = try container.decodeIfPresent(Int.self, forKey: .prop3)
//    }
//}



//extension GrammaticalUnitCodable where Self: GrammaticalStructureCategorizable & GrammaticalFunctionCategorizable {
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        let content = try container.decode(String.self, forKey: .content)
//        let structure = try container.decode(StructureCategory.self, forKey: .structure)
//        let function = try container.decode(FunctionCategory.self, forKey: .function)
//    }
//    
//    
//}
//
//fileprivate enum CodingKeys: String, CodingKey {
//    case content
//    case structure
//    case function
//}


import Foundation

//// MARK: - JSONSchemaProviding Protocol
//
///// A protocol that allows grammatical units to provide their JSON schema.
///// Implementations should include a default schema that specifies all required properties
///// and available categories for encoding the grammatical unit as JSON.
//public protocol JSONSchemaProviding: GrammaticalUnit {
//    
//    /// Returns the JSON schema for the grammatical unit, detailing available properties
//    /// and categories for encoding.
//    static var jsonSchema: [String: Any] { get }
//}
//
//// MARK: - Default Implementation for Grammatical Units
//
//// MARK: - Base Implementation for JSONSchemaProviding
//
//public extension JSONSchemaProviding where Self: GrammaticalUnit {
//    
//    /// Base schema with common properties for all grammatical units.
//    static var jsonSchema: [String: Any] {
//        return [
//            "type": "\(Self.self)",
//            "content": "String"
//        ]
//    }
//}
//
//public extension JSONSchemaProviding where Self: GrammaticalUnitComposable, Self.Child: JSONSchemaProviding {
//    
//    /// Adds children schema for composable units.
//    static var jsonSchema: [String: Any] {
//        var schema = Self.jsonSchema
//        
//        // Add child schemas
//        schema["children"] = [Self.Child.jsonSchema]
//        
//        return schema
//    }
//}
//
//public extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalUnitComposable & GrammaticalStructureCategorizable & GrammaticalFunctionCategorizable, Self.Child: JSONSchemaProviding {
//    
//    /// Combines structure, function, and child schemas.
//    static var jsonSchema: [String: Any] {
//        var schema = Self.jsonSchema
//        
//        // Add structure and function categories
//        schema["structure"] = StructureCategory.allCases.map { "\($0)" }
//        schema["function"] = FunctionCategory.allCases.map { "\($0)" }
//        
//        // Add child schemas
//        schema["children"] = [Self.Child.jsonSchema]
//        
//        return schema
//    }
//}
//// Example usage: Retrieve JSON schema for a Japanese sentence
////let sentenceSchema = Japanese.Sentence.jsonSchema
////print(sentenceSchema)


//// MARK: - Protocol Definition
//
//public protocol JSONSchemaProviding {
//    
//    static var schemaTitle: String { get }
//    static var schemaDescription: String { get }
//    /// Returns the JSON schema for the grammatical unit
//    static var jsonSchema: [String: Any] { get }
//}
//
//extension JSONSchemaProviding {
//    
//    var title: String {
//        String(describing: Self.self)
//    }
//    
//}
//
//// MARK: - Schema Type Definitions
//
//private extension JSONSchemaProviding {
//    static func makeObjectSchema(properties: [String: Any]) -> [String: Any] {
//        [
//            "title": schemaTitle,
//            "description": schemaDescription,
//            "type": "object",
//            "properties": properties
//        ]
//    }
//    
//    static func makeArraySchema(items: [String: Any]) -> [String: Any] {
//        [
//            "type": "array",
//            "items": items
//        ]
//    }
//}
//
//// MARK: - Base Implementation
//
//extension JSONSchemaProviding where Self: GrammaticalUnit {
//    public static var jsonSchema: [String: Any] {
//        makeObjectSchema(properties: [
//            "type": ["type": "string", "const": String(describing: Self.self)],
//            "content": ["type": "string"]
//        ])
//    }
//}
//
//// MARK: - Structure Categorizable Implementation
//
//extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalStructureCategorizable {
//    public static var jsonSchema: [String: Any] {
//        var properties = [
//            "type": ["type": "string", "const": String(describing: Self.self)],
//            "content": ["type": "string"],
//            "structure": makeObjectSchema(properties: [:]) // Structure will be validated at runtime
//        ]
//        
//        return makeObjectSchema(properties: properties)
//    }
//}
//
//// MARK: - Function Categorizable Implementation
//
//extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalFunctionCategorizable {
//    public static var jsonSchema: [String: Any] {
//        var properties = [
//            "type": ["type": "string", "const": String(describing: Self.self)],
//            "content": ["type": "string"],
//            "function": makeObjectSchema(properties: [:]) // Function will be validated at runtime
//        ]
//        
//        return makeObjectSchema(properties: properties)
//    }
//}
//
//// MARK: - Composable Implementation
//
//extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalUnitComposable, Self.Child: JSONSchemaProviding {
//    public static var jsonSchema: [String: Any] {
//        var properties = [
//            "type": ["type": "string", "const": String(describing: Self.self)],
//            "content": ["type": "string"],
//            "children": makeArraySchema(items: Child.jsonSchema)
//        ]
//        
//        return makeObjectSchema(properties: properties)
//    }
//}
//
//// MARK: - Combined Implementations
//
//extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalStructureCategorizable & GrammaticalFunctionCategorizable {
//    public static var jsonSchema: [String: Any] {
//        var properties = [
//            "type": ["type": "string", "const": String(describing: Self.self)],
//            "content": ["type": "string"],
//            "structure": makeObjectSchema(properties: [:]),
//            "function": makeObjectSchema(properties: [:])
//        ]
//        
//        return makeObjectSchema(properties: properties)
//    }
//}
//
//extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalStructureCategorizable & GrammaticalUnitComposable, Self.Child: JSONSchemaProviding {
//    public static var jsonSchema: [String: Any] {
//        var properties = [
//            "type": ["type": "string", "const": String(describing: Self.self)],
//            "content": ["type": "string"],
//            "structure": makeObjectSchema(properties: [:]),
//            "children": makeArraySchema(items: Child.jsonSchema)
//        ]
//        
//        return makeObjectSchema(properties: properties)
//    }
//}
//
//extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalFunctionCategorizable & GrammaticalUnitComposable, Self.Child: JSONSchemaProviding {
//    public static var jsonSchema: [String: Any] {
//        var properties = [
//            "type": ["type": "string", "const": String(describing: Self.self)],
//            "content": ["type": "string"],
//            "function": makeObjectSchema(properties: [:]),
//            "children": makeArraySchema(items: Child.jsonSchema)
//        ]
//        
//        return makeObjectSchema(properties: properties)
//    }
//}
//
//extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalStructureCategorizable & GrammaticalFunctionCategorizable & GrammaticalUnitComposable, Self.Child: JSONSchemaProviding {
//    public static var jsonSchema: [String: Any] {
//        var properties = [
//            "type": ["type": "string", "const": String(describing: Self.self)],
//            "content": ["type": "string"],
//            "structure": makeObjectSchema(properties: [:]),
//            "function": makeObjectSchema(properties: [:]),
//            "children": makeArraySchema(items: Child.jsonSchema)
//        ]
//        
//        return makeObjectSchema(properties: properties)
//    }
//}

//extension Japanese.Sentence: JSONSchemaProviding {}
//extension Japanese.Clause: JSONSchemaProviding {}
//extension Japanese.Phrase: JSONSchemaProviding {}
//extension Japanese.Word: JSONSchemaProviding {}
//extension Japanese.Particle: JSONSchemaProviding {}
//extension Japanese.Morpheme: JSONSchemaProviding {}


/// A protocol that provides a JSON string representation of the schema for a grammatical unit.
//public protocol GrammaticalUnitSchemable: Schemable {
//    /// Returns the JSON string of the schema.
//    static var jsonSchemaString: String { get }
//}

//extension GrammaticalUnitSchemable {
//    public static var jsonSchemaString: String {
//        do {
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            
//            // Convert the schema to JSON data
//            let data = try encoder.encode(schema)
//            
//            // Convert the data to a JSON string
//            if let jsonString = String(data: data, encoding: .utf8) {
//                return jsonString
//            } else {
//                return "{}" // Fallback to empty JSON object if encoding fails
//            }
//        } catch {
//            print("Failed to encode schema: \(error)")
//            return "{}" // Fallback to empty JSON object in case of error
//        }
//    }
//}
