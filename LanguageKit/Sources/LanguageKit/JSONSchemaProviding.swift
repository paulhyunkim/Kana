//
//  JSONSchemaProviding.swift
//  LanguageKit
//
//  Created by Paul Kim on 10/23/24.
//

// MARK: - Protocol Definition

public protocol JSONSchemaProviding {
    /// The title of the schema
    static var schemaTitle: String { get }
    
    /// A description of what this schema represents
    static var schemaDescription: String { get }
    
    /// Returns the complete JSON schema for this type
    static var jsonSchema: [String: Any] { get }
}

// MARK: - Helper Methods

private extension JSONSchemaProviding {
    /// Creates a standard JSON Schema object definition
    static func makeObjectSchema(properties: [String: Any], required: [String]? = nil) -> [String: Any] {
        var schema: [String: Any] = [
            "title": schemaTitle,
            "description": schemaDescription,
            "type": "object",
            "properties": properties
        ]
        
        if let required = required {
            schema["required"] = required
        }
        
        return schema
    }
    
    /// Creates a JSON Schema array definition
    static func makeArraySchema(items: [String: Any]) -> [String: Any] {
        [
            "type": "array",
            "items": items
        ]
    }
    
    /// Creates a JSON Schema enum definition
    static func makeEnumSchema<T: CaseIterable & RawRepresentable<String>>(
        for type: T.Type,
        title: String,
        description: String
    ) -> [String: Any] {
        [
            "title": title,
            "description": description,
            "type": "string",
            "enum": type.allCases.map { $0.rawValue }
        ]
    }
}

// MARK: - Base GrammaticalUnit Implementation

extension JSONSchemaProviding where Self: GrammaticalUnit {
    public static var jsonSchema: [String: Any] {
        makeObjectSchema(
            properties: [
                "type": [
                    "type": "string",
                    "const": String(describing: Self.self)
                ],
                "content": [
                    "type": "string",
                    "description": "The textual content of the \(String(describing: Self.self).lowercased())"
                ]
            ],
            required: ["type", "content"]
        )
    }
}

// MARK: - Structure Categorizable Implementation

extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalStructureCategorizable {
    public static var jsonSchema: [String: Any] {
        let properties = [
            "type": [
                "type": "string",
                "const": String(describing: Self.self)
            ],
            "content": [
                "type": "string",
                "description": "The textual content of the \(String(describing: Self.self).lowercased())"
            ],
            "structure": makeEnumSchema(
                for: StructureCategory.self,
                title: "\(String(describing: Self.self)) Structure Category",
                description: "The grammatical structure category of the \(String(describing: Self.self).lowercased())"
            )
        ]
        
        return makeObjectSchema(
            properties: properties,
            required: ["type", "content", "structure"]
        )
    }
}

// MARK: - Function Categorizable Implementation

extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalFunctionCategorizable {
    public static var jsonSchema: [String: Any] {
        let properties = [
            "type": [
                "type": "string",
                "const": String(describing: Self.self)
            ],
            "content": [
                "type": "string",
                "description": "The textual content of the \(String(describing: Self.self).lowercased())"
            ],
            "function": makeEnumSchema(
                for: FunctionCategory.self,
                title: "\(String(describing: Self.self)) Function Category",
                description: "The grammatical function category of the \(String(describing: Self.self).lowercased())"
            )
        ]
        
        return makeObjectSchema(
            properties: properties
//            required: ["type", "content", "function"]
        )
    }
}

// MARK: - Composable Implementation

extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalUnitComposable, Child: JSONSchemaProviding {
    public static var jsonSchema: [String: Any] {
        let properties = [
            "type": [
                "type": "string",
                "const": String(describing: Self.self)
            ],
            "content": [
                "type": "string",
                "description": "The textual content of the \(String(describing: Self.self).lowercased())"
            ],
            "children": makeArraySchema(items: Child.jsonSchema)
        ]
        
        return makeObjectSchema(
            properties: properties
//            required: ["type", "content", "children"]
        )
    }
}

// MARK: - Combined Implementations

extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalStructureCategorizable & GrammaticalFunctionCategorizable {
    public static var jsonSchema: [String: Any] {
        let properties = [
            "type": [
                "type": "string",
                "const": String(describing: Self.self)
            ],
            "content": [
                "type": "string",
                "description": "The textual content of the \(String(describing: Self.self).lowercased())"
            ],
            "structure": makeEnumSchema(
                for: StructureCategory.self,
                title: "\(String(describing: Self.self)) Structure Category",
                description: "The grammatical structure category of the \(String(describing: Self.self).lowercased())"
            ),
            "function": makeEnumSchema(
                for: FunctionCategory.self,
                title: "\(String(describing: Self.self)) Function Category",
                description: "The grammatical function category of the \(String(describing: Self.self).lowercased())"
            )
        ]
        
        return makeObjectSchema(
            properties: properties
//            required: ["type", "content", "structure", "function"]
        )
    }
}

extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalStructureCategorizable & GrammaticalUnitComposable, Child: JSONSchemaProviding {
    public static var jsonSchema: [String: Any] {
        let properties = [
            "type": [
                "type": "string",
                "const": String(describing: Self.self)
            ],
            "content": [
                "type": "string",
                "description": "The textual content of the \(String(describing: Self.self).lowercased())"
            ],
            "structure": makeEnumSchema(
                for: StructureCategory.self,
                title: "\(String(describing: Self.self)) Structure Category",
                description: "The grammatical structure category of the \(String(describing: Self.self).lowercased())"
            ),
            "children": makeArraySchema(items: Child.jsonSchema)
        ]
        
        return makeObjectSchema(
            properties: properties
//            required: ["type", "content", "structure", "children"]
        )
    }
}

extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalFunctionCategorizable & GrammaticalUnitComposable, Child: JSONSchemaProviding {
    public static var jsonSchema: [String: Any] {
        let properties = [
            "type": [
                "type": "string",
                "const": String(describing: Self.self)
            ],
            "content": [
                "type": "string",
                "description": "The textual content of the \(String(describing: Self.self).lowercased())"
            ],
            "function": makeEnumSchema(
                for: FunctionCategory.self,
                title: "\(String(describing: Self.self)) Function Category",
                description: "The grammatical function category of the \(String(describing: Self.self).lowercased())"
            ),
            "children": makeArraySchema(items: Child.jsonSchema)
        ]
        
        return makeObjectSchema(
            properties: properties
//            required: ["type", "content", "function", "children"]
        )
    }
}

extension JSONSchemaProviding where Self: GrammaticalUnit & GrammaticalStructureCategorizable & GrammaticalFunctionCategorizable & GrammaticalUnitComposable, Child: JSONSchemaProviding {
    public static var jsonSchema: [String: Any] {
        let properties = [
            "type": [
                "type": "string",
                "const": String(describing: Self.self)
            ],
            "content": [
                "type": "string",
                "description": "The textual content of the \(String(describing: Self.self).lowercased())"
            ],
            "structure": makeEnumSchema(
                for: StructureCategory.self,
                title: "\(String(describing: Self.self)) Structure Category",
                description: "The grammatical structure category of the \(String(describing: Self.self).lowercased())"
            ),
            "function": makeEnumSchema(
                for: FunctionCategory.self,
                title: "\(String(describing: Self.self)) Function Category",
                description: "The grammatical function category of the \(String(describing: Self.self).lowercased())"
            ),
            "children": makeArraySchema(items: Child.jsonSchema)
        ]
        
        return makeObjectSchema(
            properties: properties
//            required: ["type", "content", "structure", "function", "children"]
        )
    }
}

extension Japanese.Sentence: JSONSchemaProviding {
    public static var schemaTitle: String { "sentence" }
    public static var schemaDescription: String { "The text of the sentence" }
}
extension Japanese.Clause: JSONSchemaProviding {
    public static var schemaTitle: String { "clause" }
    public static var schemaDescription: String { "The text of the clause" }
}
extension Japanese.Phrase: JSONSchemaProviding {
    public static var schemaTitle: String { "phrase" }
    public static var schemaDescription: String { "The text of the phrase" }
}
extension Japanese.Word: JSONSchemaProviding {
    public static var schemaTitle: String { "word" }
    public static var schemaDescription: String { "The text of the word" }
}
extension Japanese.Morpheme: JSONSchemaProviding {
    public static var schemaTitle: String { "morpheme" }
    public static var schemaDescription: String { "The text of the morpheme" }
}
