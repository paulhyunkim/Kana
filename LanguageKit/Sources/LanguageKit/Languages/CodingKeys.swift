//// First, make all the enums Codable with simple string values
//extension Japanese.SentenceStructureCategory: Codable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let value = try container.decode(String.self)
//        switch value {
//        case "simple": self = .simple
//        case "compound": self = .compound
//        case "complex": self = .complex
//        case "compoundComplex": self = .compoundComplex
//        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid sentence structure category: \(value)")
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .simple: try container.encode("simple")
//        case .compound: try container.encode("compound")
//        case .complex: try container.encode("complex")
//        case .compoundComplex: try container.encode("compoundComplex")
//        }
//    }
//}
//
//extension Japanese.SentenceFunctionCategory: Codable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let value = try container.decode(String.self)
//        switch value {
//        case "declarative": self = .declarative
//        case "imperative": self = .imperative
//        case "interrogative": self = .interrogative
//        case "exclamatory": self = .exclamatory
//        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid sentence function category: \(value)")
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .declarative: try container.encode("declarative")
//        case .imperative: try container.encode("imperative")
//        case .interrogative: try container.encode("interrogative")
//        case .exclamatory: try container.encode("exclamatory")
//        }
//    }
//}
//
//extension Japanese.ClauseStructureCategory: Codable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let value = try container.decode(String.self)
//        switch value {
//        case "main": self = .main
//        case "subordinate": self = .subordinate
//        case "relative": self = .relative
//        case "nominal": self = .nominal
//        case "adverbial": self = .adverbial
//        case "conditional": self = .conditional
//        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid clause structure category: \(value)")
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .main: try container.encode("main")
//        case .subordinate: try container.encode("subordinate")
//        case .relative: try container.encode("relative")
//        case .nominal: try container.encode("nominal")
//        case .adverbial: try container.encode("adverbial")
//        case .conditional: try container.encode("conditional")
//        }
//    }
//}
//
//extension Japanese.ClauseFunctionCategory: Codable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let value = try container.decode(String.self)
//        switch value {
//        case "unknown": self = .unknown
//        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid clause function category: \(value)")
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .unknown: try container.encode("unknown")
//        }
//    }
//}
//
//extension Japanese.PhraseStructureCategory: Codable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let value = try container.decode(String.self)
//        switch value {
//        case "nounPhrase": self = .nounPhrase
//        case "verbPhrase": self = .verbPhrase
//        case "adjectivePhrase": self = .adjectivePhrase
//        case "adverbPhrase": self = .adverbPhrase
//        case "particlePhrase": self = .particlePhrase
//        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid phrase structure category: \(value)")
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .nounPhrase: try container.encode("nounPhrase")
//        case .verbPhrase: try container.encode("verbPhrase")
//        case .adjectivePhrase: try container.encode("adjectivePhrase")
//        case .adverbPhrase: try container.encode("adverbPhrase")
//        case .particlePhrase: try container.encode("particlePhrase")
//        }
//    }
//}
//
//extension Japanese.WordFunctionCategory: Codable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let value = try container.decode(String.self)
//        switch value {
//        case "noun": self = .noun
//        case "verb": self = .verb
//        case "adjectivalVerb": self = .adjectivalVerb
//        case "adjectivalNoun": self = .adjectivalNoun
//        case "adverb": self = .adverb
//        case "prenominalAdjective": self = .prenominalAdjective
//        case "conjunction": self = .conjunction
//        case "interjection": self = .interjection
//        case "auxilaryVerb": self = .auxilaryVerb
//        case "particle": self = .particle(.init(content: "", function: .caseMarking))
//        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid word function category: \(value)")
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .noun: try container.encode("noun")
//        case .verb: try container.encode("verb")
//        case .adjectivalVerb: try container.encode("adjectivalVerb")
//        case .adjectivalNoun: try container.encode("adjectivalNoun")
//        case .adverb: try container.encode("adverb")
//        case .prenominalAdjective: try container.encode("prenominalAdjective")
//        case .conjunction: try container.encode("conjunction")
//        case .interjection: try container.encode("interjection")
//        case .auxilaryVerb: try container.encode("auxilaryVerb")
//        case .particle: try container.encode("particle")
//        }
//    }
//}
//
//// Update the main type Codable implementations for the flatter structure
//
//extension Japanese.Sentence: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case type, content, structure, function, children
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        // Verify type is "sentence"
//        let type = try container.decode(String.self, forKey: .type)
//        guard type == "sentence" else {
//            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type for Sentence: \(type)")
//        }
//        
//        content = try container.decode(String.self, forKey: .content)
//        structure = try container.decode(StructureCategory.self, forKey: .structure)
//        function = try container.decode(FunctionCategory.self, forKey: .function)
//        children = try container.decode([Japanese.Clause].self, forKey: .children)
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        try container.encode("sentence", forKey: .type)
//        try container.encode(content, forKey: .content)
//        try container.encode(structure, forKey: .structure)
//        try container.encode(function, forKey: .function)
//        try container.encode(children, forKey: .children)
//    }
//}
//
//extension Japanese.Clause: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case type, content, structure, function, children
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        let type = try container.decode(String.self, forKey: .type)
//        guard type == "clause" else {
//            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type for Clause: \(type)")
//        }
//        
//        content = try container.decode(String.self, forKey: .content)
//        structure = try container.decode(StructureCategory.self, forKey: .structure)
//        function = try container.decode(FunctionCategory.self, forKey: .function)
//        children = try container.decode([Japanese.Phrase].self, forKey: .children)
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        try container.encode("clause", forKey: .type)
//        try container.encode(content, forKey: .content)
//        try container.encode(structure, forKey: .structure)
//        try container.encode(function, forKey: .function)
//        try container.encode(children, forKey: .children)
//    }
//}
//
//extension Japanese.Phrase: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case type, content, structure, children
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        let type = try container.decode(String.self, forKey: .type)
//        guard type == "phrase" else {
//            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type for Phrase: \(type)")
//        }
//        
//        content = try container.decode(String.self, forKey: .content)
//        structure = try container.decode(StructureCategory.self, forKey: .structure)
//        children = try container.decode([Japanese.Word].self, forKey: .children)
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        try container.encode("phrase", forKey: .type)
//        try container.encode(content, forKey: .content)
//        try container.encode(structure, forKey: .structure)
//        try container.encode(children, forKey: .children)
//    }
//}
//
//extension Japanese.Word: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case type, content, function, children
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        let type = try container.decode(String.self, forKey: .type)
//        guard type == "word" else {
//            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type for Word: \(type)")
//        }
//        
//        content = try container.decode(String.self, forKey: .content)
//        function = try container.decode(FunctionCategory.self, forKey: .function)
//        children = [] //try container.decode([Japanese.Morpheme].self, forKey: .children)
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        try container.encode("word", forKey: .type)
//        try container.encode(content, forKey: .content)
//        try container.encode(function, forKey: .function)
////        try container.encode(children, forKey: .children)
//    }
//}
//

// First, add Codable requirements to our base category protocols
//public protocol GrammaticalStructureCategory: Codable { }
//public protocol GrammaticalFunctionCategory: Codable { }

// Create a protocol for JSON type identification
//public protocol GrammaticalUnitType {
//    static var typeIdentifier: String { get }
//}

// Add default implementations for our grammatical unit types
extension SentenceCategoryProtocol {
    public static var typeIdentifier: String { "sentence" }
}
extension ClauseCategoryProtocol {
    public static var typeIdentifier: String { "clause" }
}
extension PhraseCategoryProtocol {
    public static var typeIdentifier: String { "phrase" }
}
extension WordCategoryProtocol {
    public static var typeIdentifier: String { "word" }
}
extension ParticleCategoryProtocol {
    public static var typeIdentifier: String { "particle" }
}
extension MorphemeCategoryProtocol {
    public static var typeIdentifier: String { "morpheme" }
}

// Create a generic CodingKeys type that can be reused
public enum GrammaticalUnitCodingKeys: String, CodingKey {
    case type, content, structure, function, children
}

// Create a generic Codable implementation for grammatical units
//public extension GrammaticalUnit where Self: Codable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: GrammaticalUnitCodingKeys.self)
//        
//        // Verify type matches expected type
//        let type = try container.decode(String.self, forKey: .type)
//        guard type == Self.typeIdentifier else {
//            throw DecodingError.dataCorruptedError(
//                forKey: .type,
//                in: container,
//                debugDescription: "Invalid type for \(Self.typeIdentifier): \(type)"
//            )
//        }
//        
//        // Initialize content
//        content = try container.decode(String.self, forKey: .content)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: GrammaticalUnitCodingKeys.self)
//        try container.encode(Self.typeIdentifier, forKey: .type)
//        try container.encode(content, forKey: .content)
//    }
//}
//
//// Add Codable implementation for units with structure categorization
//public extension GrammaticalStructureCategorizable where Self: GrammaticalUnit & Codable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: GrammaticalUnitCodingKeys.self)
//        structure = try container.decode(StructureCategory.self, forKey: .structure)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: GrammaticalUnitCodingKeys.self)
//        try container.encode(structure, forKey: .structure)
//    }
//}
//
//// Add Codable implementation for units with function categorization
//public extension GrammaticalFunctionCategorizable where Self: GrammaticalUnit & Codable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: GrammaticalUnitCodingKeys.self)
//        function = try container.decode(FunctionCategory.self, forKey: .function)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: GrammaticalUnitCodingKeys.self)
//        try container.encode(function, forKey: .function)
//    }
//}
//
//// Add Codable implementation for units with children
//public extension GrammaticalUnitComposable where Self: GrammaticalUnit & Codable, Child: Codable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: GrammaticalUnitCodingKeys.self)
//        children = try container.decode([Child].self, forKey: .children)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: GrammaticalUnitCodingKeys.self)
//        try container.encode(children, forKey: .children)
//    }
//}
//
//// Example implementation for a grammatical unit that combines all features
//public extension GrammaticalUnit where Self: GrammaticalStructureCategorizable & GrammaticalFunctionCategorizable & GrammaticalUnitComposable & Codable, Child: Codable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: GrammaticalUnitCodingKeys.self)
//        
//        // Verify type
//        let type = try container.decode(String.self, forKey: .type)
//        guard type == Self.typeIdentifier else {
//            throw DecodingError.dataCorruptedError(
//                forKey: .type,
//                in: container,
//                debugDescription: "Invalid type for \(Self.typeIdentifier): \(type)"
//            )
//        }
//        
//        // Decode all properties
//        content = try container.decode(String.self, forKey: .content)
//        structure = try container.decode(StructureCategory.self, forKey: .structure)
//        function = try container.decode(FunctionCategory.self, forKey: .function)
//        children = try container.decode([Child].self, forKey: .children)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: GrammaticalUnitCodingKeys.self)
//        
//        try container.encode(Self.typeIdentifier, forKey: .type)
//        try container.encode(content, forKey: .content)
//        try container.encode(structure, forKey: .structure)
//        try container.encode(function, forKey: .function)
//        try container.encode(children, forKey: .children)
//    }
//}
//
//// Now for Japanese specifically, we just need to conform to Codable and the type identifier protocol
//extension Japanese.Sentence: Codable {
//    public func encode(to encoder: any Encoder) throws {
//        
//    }
//    
////    public static var typeIdentifier: String { "sentence" }
//}
//
//extension Japanese.Clause: Codable {
////    public static var typeIdentifier: String { "clause" }
//}
//
//extension Japanese.Phrase: Codable {
////    public static var typeIdentifier: String { "phrase" }
//}
//
//extension Japanese.Word: Codable {
////    public static var typeIdentifier: String { "word" }
//}
//
//
//extension Sentence: Codable {
//    
//}
