//
//  PromptBuilder.swift
//  Kana
//
//  Created by Paul Kim on 10/24/24.
//

import Foundation
import LanguageKit

//struct PromptBuilder {
//    
////    static func build(for task: LanguageTask) throws -> LLMPrompt {
////        let promptTemplate = try promptTemplate(for: task)
////        fatalError("")
////    }
//    
//    static func build(for taskInput: some LanguageTaskInput) throws -> LLMPrompt {
//        let template = try promptTemplate(for: taskInput)
//        var systemMessage = template.systemMessageTemplate
//        var userMessage = template.userMessageTemplate
//        taskInput.placeholderMap.forEach { key, value in
//            systemMessage.replace(key.rawValue, with: value)
//            userMessage.replace(key.rawValue, with: value)
//        }
//        
//        return LLMPrompt(systemMessage: systemMessage, userMessage: userMessage, fewShotMessages: [])
//    }
//    
//    private static func promptTemplate(for taskInput: any LanguageTaskInput) throws -> LLMPromptTemplate {
//        guard let jsonPath = Bundle.main.path(forResource: taskInput.fileName, ofType: "json") else {
//            throw PromptBuilderError.fileNotFound
//        }
//        let configURL = URL(fileURLWithPath: jsonPath)
//        let data = try Data(contentsOf: configURL)
//        return try JSONDecoder().decode(LLMPromptTemplate.self, from: data)
//
////        guard let yamlString = try? String(contentsOfFile: taskInput.fileName, encoding: .utf8) else {
////            throw NSError(domain: "YAMLError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to read YAML file"])
////        }
////        
////        // Method 1: Decode directly to your type
////        do {
////            let config = try YAMLDecoder().decode(LLMPromptTemplate.self, from: yamlString)
////            return config
////        } catch {
////            throw NSError(domain: "YAMLError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to decode YAML: \(error.localizedDescription)"])
////        }
//    }
//    
//}
//
//
//protocol LanguageTaskInput {
//    associatedtype PlaceholderKey: RawRepresentable<String> & Hashable
//    
//    var fileName: String { get }
////    var placeholderKeys: [PlaceholderKey] { get }
//    var placeholderMap: [PlaceholderKey: String] { get }
//}
//
//public struct TranslationTaskInput<Text: GrammaticalUnit>: LanguageTaskInput {
//    enum PlaceholderKey: String {
//        case sourceText = "{{SOURCE_TEXT}}"
//        case sourceLanguage = "{{SOURCE_LANGUAGE}}"
//        case targetLanguage = "{{TARGET_LANGUAGE}}"
//    }
//    
//    let fileName = "TranslationTemplate"
//    
//    var placeholderMap: [PlaceholderKey: String]
//    
//    public init(sourceText: Text, targetLanguage: LanguageDescriptor.Type) {
//        self.placeholderMap = [
//            .sourceText: sourceText.content,
//            .sourceLanguage: Text.Language.name,
//            .targetLanguage: targetLanguage.name
//        ]
//        
//        Text.Language.code
//    }
//}

//extension PromptBuilder {
//    
//    enum PlaceholderKey: String {
//        // Shared keys that can be used across multiple tasks
//        case inputText = "{{INPUT_TEXT}}"
//        case sourceLanguage = "{{SOURCE_LANGUAGE}}"
//        case targetLanguage = "{{TARGET_LANGUAGE}}"
//        
//        // Task-specific placeholder groups
//        enum Translation: String {
//            case sourceText = "{source_text}"
//            case sourceLanguage = "{source_language}"
//            case targetLanguage = "{target_language}"
//        }
//        
//        enum GrammaticalAnalysis: String {
//            case text = "{text}"
//            case structureTypes = "{structure_types}"
//        }
//        
//        enum Transliteration: String {
//            case text = "{text}"
//            case targetScript = "{target_script}"
//        }
//        
//        // Add more task-specific placeholder groups as needed
//
//        struct Value<T> {
//            let key: PlaceholderKey
//            let value: T
//            
//            init(_ key: PlaceholderKey, _ value: T) {
//                self.key = key
//                self.value = value
//            }
//        }
//        
//    }
//    
//    struct PlaceholderValue {
//        var key: PlaceholderKey
//        var value: String
//    }
//    
////    struct InputTextKeyValue: PlaceholderValue {
////        let key = PlaceholderKey.inputText
////        let value: String
////    }
////    
////    struct SourecLanguageKeyValue: PlaceholderValue {
////        let key = PlaceholderKey.sourceLanguage
////        let value: String
////    }
//    
//    struct ModerationInput {
//        var text: String
//    }
//    
////    struct TranslationInput<Unit: GrammaticalUnit>: TranslationTaskInputType {
////        typealias Unit = GrammaticalUnit
////        typealias TargetLanguage = LanguageDescriptor
////        
////        var sourceUnit: GrammaticalUnit
////        var targetLanguage: TargetLanguage.Type
////        
////        init(sourceUnit: GrammaticalUnit, targetLanguage: TargetLanguage.Type) {
////            self.sourceUnit = sourceUnit
////            self.targetLanguage = targetLanguage
////        }
////        
////        var placeholderValues: [PlaceholderKey: String] {
////            [
////                .inputText: sourceUnit.content,
////                .sourceLanguage: Unit.Language.name,
////                .targetLanguage: TargetLanguage.name
////            ]
////        }
////    }
//    
//    // Define the struct with generic parameters
////    struct TranslationInput<Unit: GrammaticalUnit, TargetLanguage: LanguageDescriptor>: TranslationTaskInputType {
////
////        var sourceUnit: Unit
////        var targetLanguage: TargetLanguage.Type
////
////        init(sourceUnit: Unit, targetLanguage: TargetLanguage.Type) {
////            self.sourceUnit = sourceUnit
////            self.targetLanguage = targetLanguage
////        }
////
////        var placeholderValues: [PlaceholderKey: String] {
////            [
////                .inputText: sourceUnit.content,
////                .sourceLanguage: Unit.Language.name,
////                .targetLanguage: TargetLanguage.name
////            ]
////        }
////    }
//    
////    struct TranslationInput<TargetLanguage: LanguageDescriptor>: TranslationTaskInputType {
////        
////        // Protocol Conformance
//////        typealias Unit = GrammaticalUnit
////        
////        var sourceUnit: Unit
////        var targetLanguage: TargetLanguage.Type
////
////        init<Unit: GrammaticalUnit>(sourceUnit: Unit) where Unit.Language == TargetLanguage {
////            self.sourceUnit = sourceUnit
////            self.targetLanguage = TargetLanguage.self
////        }
////
////        var placeholderValues: [PlaceholderKey: String] {
////            [
////                .inputText: sourceUnit.content,
////                .sourceLanguage: type(of: sourceUnit).Language.name,
////                .targetLanguage: TargetLanguage.name
////            ]
////        }
////    }
//   
//    
////    func whatItLooksLikeAtCallSiteExample() {
////        let japaneseSentence = Japanese.Sentence(
////            content: "猫が寝ている。",
////            structure: .simple,
////            function: .declarative,
////            children: []
////        )
////        
////        let translationInput = TranslationInput<Japanese>(sourceUnit: japaneseSentence)
////        
////        LanguageTask.translation(translationInput)
////    }
//    
//}

//extension LanguageTask {
//    
//    var input:
//    
//}

//public protocol TranslationTaskType {
//    associatedtype SourceLanguage: LanguageDescriptor
//    associatedtype TargetLanguage: LanguageDescriptor
//    associatedtype SourceUnit: GrammaticalUnit where SourceUnit.Language == SourceLanguage
//    
//    var sourceUnit: SourceUnit { get }
////    var targetLanguage: TargetLanguage.Type { get }
//    
//    init(sourceUnit: SourceUnit)
//}
//
//public struct TranslationTask<TargetLanguage: LanguageDescriptor> {
//    public typealias SU = Any
//    public let sourceUnit: SU
//        
//    public init<SU: GrammaticalUnit>(sourceUnit: SU) {
//        self.sourceUnit = sourceUnit
//    }
//}

public protocol TranslationTaskType {
//    associatedtype SourceLanguage: LanguageDescriptor
    associatedtype TargetLanguage: LanguageDescriptor
    associatedtype SourceUnit: GrammaticalUnit // where SourceUnit.Language == SourceLanguage
    
    var sourceUnit: SourceUnit { get }
    
    init(sourceUnit: SourceUnit)
}


struct PromptBuilder {
    
    enum BuilderError: LocalizedError {
        case missingRequiredPlaceholders([String])
        case templateParsingFailed(String)
        case unmatchedPlaceholders([String])
        
        var errorDescription: String? {
            switch self {
            case .missingRequiredPlaceholders(let names):
                return "Missing required placeholders: \(names.joined(separator: ", "))"
            case .templateParsingFailed(let reason):
                return "Failed to parse template: \(reason)"
            case .unmatchedPlaceholders(let placeholders):
                return "Found placeholders in template that aren't handled: \(placeholders.joined(separator: ", "))"
            }
        }
    }
    
    static func buildPrompt<Task: LanguageTask>(task: Task) throws {
        let xmlString = try XMLDocumentReader.document(named: Task.templateName)
        let parser = XMLTemplateParser()
        
        guard let template = parser.parse(xmlString) else {
            throw BuilderError.templateParsingFailed("XML parsing failed")
        }
        
        // Get unmatched and required parameters in one pass
        let (unmatchedParameters, requiredParameters) = template.messages.reduce(into: (Set<String>(), Set<Task.PlaceholderKey>())) { result, message in
            message.sections.forEach { section in
                section.requiredParameters.forEach { param in
                    if let key = Task.PlaceholderKey(rawValue: param) {
                        result.1.insert(key)
                    } else {
                        result.0.insert(param)
                    }
                }
            }
        }
        
        if !unmatchedParameters.isEmpty {
            throw BuilderError.unmatchedPlaceholders(Array(unmatchedParameters))
        }
        
        // Check if all required parameters have values
        let missingParameters = requiredParameters
            .filter { key in
                task.placeholderValues[key] == nil
            }
            .map(\.rawValue)
        
        if !missingParameters.isEmpty {
            throw BuilderError.missingRequiredPlaceholders(missingParameters)
        }
        
        // Filter out nil values and convert to string dictionary
        let validPlaceholderValues: [String: String] = task.placeholderValues
            .compactMapValues { $0 }  // Remove nil values
            .reduce(into: [:]) { result, pair in
                result[pair.key.rawValue] = pair.value
            }

        let systemMessage = template.messages
            .first { $0.role == "system" }?
            .build(with: validPlaceholderValues)

        let userMessage = template.messages
            .first { $0.role == "user" }?
            .build(with: validPlaceholderValues)
        
        print(systemMessage ?? "")
        print(userMessage ?? "")
    }
}
//enum LanguageTaskTest: CaseIterable {
//    
//    case translation
//
//    var name: String {
//        switch self {
//        case .translation: return "TranslationTemplate"
//        }
//    }
//    
//    // Helper type to get the associated placeholder key type
//    var placeholderKeyType: any PromptTemplatePlaceholderKey.Type {
//        switch self {
//        case .translation: return PromptTemplate.TranslationKey.self
//        }
//    }
//    
//    func buildPrompt<Key: PromptTemplatePlaceholderKey>(placeholderValues: [Key: String]) throws {
//        let xmlString = try XMLDocumentReader.document(named: name)
//        let parser = XMLTemplateParser()
//        
//        guard let template = parser.parse(xmlString) else {
//            throw PromptError.templateParsingFailed("XML parsing failed")
//        }
//        
//        // Find all required placeholders in the template
//        let requiredPlaceholders = template.messages.flatMap { message in
//            message.sections
//                .filter { !($0.optional) }
//                .flatMap { section in
//                    findPlaceholders(in: section.content)
//                }
//        }
//        
//        // Check if all required placeholders have values
//        let missingPlaceholders = Set(requiredPlaceholders)
//            .filter { placeholder in
//                !placeholderValues.keys.contains(placeholder)
//            }
//        
//        if !missingPlaceholders.isEmpty {
//            throw PromptError.missingRequiredPlaceholders(Array(missingPlaceholders))
//        }
//        
//        // At this point, all required placeholders have values
//        let systemMessage = template.messages
//            .first { $0.role == "system" }?
//            .build(with: placeholderValues)
//        
//        let userMessage = template.messages
//            .first { $0.role == "user" }?
//            .build(with: placeholderValues)
//        
//        print(systemMessage)
//        print(userMessage)
//        // return Prompt(systemMessage: systemMessage, userMessage: userMessage)
//    }
//    
//    private func findPlaceholders(in text: String) -> [String] {
//        let pattern = "\\{\\{([^}]+)\\}\\}"
//        let regex = try! NSRegularExpression(pattern: pattern)
//        let range = NSRange(text.startIndex..., in: text)
//        
//        return regex.matches(in: text, range: range).map { match in
//            let placeholderRange = Range(match.range(at: 1), in: text)!
//            return String(text[placeholderRange])
//        }
//    }
//    
//}

//protocol PromptTemplateInput {
//    var keys: [PromptTemplatePlaceholderKey] { get }
//}

//protocol PromptTemplatePlaceholderKey: RawRepresentable<String> { }

//enum TranslationPromptTemplatePlaceholderKey: String, PromptTemplatePlaceholderKey {
//    case sourceText = "{{SOURCE_TEXT}}"
//    case sourceLanguage = "{{SOURCE_LANGUAGE}}"
//    case targetLanguage = "{{TARGET_LANGUAGE}}"
//}

//extension LanguageTask {
//    
//    typealias InputDictionary = [Placeholder: String]
//    
//    struct Placeholder: Hashable {
//        var name: String
//        var optional: Bool
//    }
//    
//}

//extension LanguageTask.InputDictionary {
//    var missingRequiredPlaceholders: [LanguageTask.Placeholder] {
//        return self.keys
//            .filter {
//                !$0.optional && self[$0] == nil
//            }
//    }
//    
//    var missingOptionalPlaceholders: [LanguageTask.Placeholder] {
//        return self.keys
//            .filter {
//                $0.optional && self[$0] == nil
//            }
//    }
//}

extension LanguageTask {

    // Statically store XML documents for each template case
//    static let availableTemplateDocuments: [PromptTemplateDocument] = {
//        PromptTemplate.allCases.compactMap { template in
//            do {
//                let xmlDocument = try XMLDocumentReader.document(named: template.name)
//                return PromptTemplateDocument(name: template.name, xmlDocument: xmlDocument)
//            } catch {
//                fatalError()
//            }
//        }
//    }()
    
//    var document: PromptTemplateDocument {
//        guard let document = Self.availableTemplateDocuments.first(where: { $0.name == name }) else {
//            fatalError("missing template")
//        }
//        return document
//    }
    
//    var placeholders: [PromptTemplatePlaceholder] {
//        return document.placeholders
//    }

}


//extension XMLDocument {
//    
//    var templatePlaceholders: [LanguageTask.Placeholder] {
//        guard let rootElement = rootElement() else { return [] }
//        return templatePlaceholders(from: rootElement)
//    }
//    
//    func templatePlaceholders(from element: XMLElement) -> [LanguageTask.Placeholder] {
//        var placeholders: [LanguageTask.Placeholder] = []
//        
//        // Check if the element has a "required" attribute
//        if let placeholderAttr = element.attribute(forName: "required")?.stringValue {
//            let names = placeholderAttr
//                .split(separator: " ")
//                .map { $0.trimmingCharacters(in: .whitespaces) }
//            
//            // Create a Placeholder instance for each placeholder name found
//            for name in names where !name.isEmpty {
//                placeholders.append(LanguageTask.Placeholder(name: name, optional: false))
//            }
//        }
//        
//        // Check if the element has a "required" attribute
//        if let placeholderAttr = element.attribute(forName: "optional")?.stringValue {
//            let names = placeholderAttr
//                .split(separator: " ")
//                .map { $0.trimmingCharacters(in: .whitespaces) }
//            
//            // Create a Placeholder instance for each placeholder name found
//            for name in names where !name.isEmpty {
//                placeholders.append(LanguageTask.Placeholder(name: name, optional: true))
//            }
//        }
//        
//        // Recursively search for placeholders in child elements
//        for child in element.children ?? [] {
//            if let childElement = child as? XMLElement {
//                placeholders.append(contentsOf: templatePlaceholders(from: childElement))
//            }
//        }
//        
//        return placeholders
//    }
//    
//    func findElementsRecursively(in element: XMLElement? = nil, withAttributeName name: String, attributeValue: String? = nil) -> [XMLElement] {
//        guard let element = element ?? rootElement() else {
//            return []
//        }
//        var results: [XMLElement] = []
//
//        // Check if the element matches the criteria
//        if let attrValue = element.attribute(forName: name)?.stringValue {
//            if attributeValue == nil || attrValue == attributeValue {
//                results.append(element)
//            }
//        }
//
//        // Recursively search in child elements
//        for child in element.children ?? [] {
//            if let childElement = child as? XMLElement {
//                results.append(contentsOf: findElementsRecursively(in: childElement, withAttributeName: name, attributeValue: attributeValue))
//            }
//        }
//
//        return results
//    }
//    
//    func findElementsRecursively(
//        in element: XMLElement? = nil,
//        elementName: String? = nil,
//        attributeName: String? = nil,
//        attributeValue: String? = nil
//    ) -> [XMLElement] {
//        // Start with the root element if no element is provided
//        guard let element = element ?? rootElement() else {
//            return []
//        }
//        
//        var results: [XMLElement] = []
//        
//        // Check if the element matches the element name criteria
//        let nameMatches = elementName == nil || element.name == elementName
//        
//        // Check if the element matches the attribute criteria
//        var attributeMatches = false
//        if let attributeName = attributeName {
//            if let attrValue = element.attribute(forName: attributeName)?.stringValue {
//                attributeMatches = (attributeValue == nil || attrValue == attributeValue)
//            }
//        } else {
//            // If attributeName is nil, treat it as a match
//            attributeMatches = true
//        }
//
//        // If the element matches both criteria, add it to results
//        if nameMatches && attributeMatches {
//            results.append(element)
//        }
//
//        // Recursively search in child elements
//        for child in element.children ?? [] {
//            if let childElement = child as? XMLElement {
//                results.append(contentsOf: findElementsRecursively(
//                    in: childElement,
//                    elementName: elementName,
//                    attributeName: attributeName,
//                    attributeValue: attributeValue
//                ))
//            }
//        }
//
//        return results
//    }
//        
//}

extension Array where Element: XMLElement {
//    public var description: String {
//        var result = "[\n"
//        
//        // Format each XMLElement in the array
//        for element in self {
//            // Convert the element to a pretty-printed string
//            let elementString = element.xmlString(options: [.nodePrettyPrint, .nodeCompactEmptyElement])
//            
//            // Split the element into lines and uniformly indent each line by 4 spaces
//            let indentedElement = elementString
//                .split(separator: "\n", omittingEmptySubsequences: false)
//                .map { "    \($0.trimmingCharacters(in: .whitespaces))" }
//                .joined(separator: "\n")
//            
//            result += "\(indentedElement),\n"
//        }
//        
//        // Remove the trailing comma and newline, then add the closing bracket
//        if !isEmpty {
//            result.removeLast(2)
//        }
//        result += "\n]"
//        
//        return result
//    }
    
    func attributeValues(for attributeName: String) -> [String] {
        return self.compactMap { element in
            element.attribute(forName: attributeName)?.stringValue
        }
    }
}

//struct Prompt {
//    var systemMessage: Message
//    var userMessage: Message
//    var fewShotMessages: [Message]
//    
//    struct Message {
//        var role: Role
//        var content: String
//        
//        enum Role {
//            case system
//            case user
//            case assistant
//        }
//    }
//}


//class PromptBuilder {
    
//    static let availableTemplateDocuments: [PromptTemplateDocument] = {
//        PromptTemplate.allCases.compactMap { template in
//            do {
//                let xmlDocument = try XMLDocumentReader.document(named: template.name)
//                return PromptTemplateDocument(name: template.name, xmlDocument: xmlDocument)
//            } catch {
//                fatalError()
//            }
//        }
//    }()
    
//    static func build(from template: LanguageTask, inputDictionary: LanguageTask.InputDictionary) throws {
////        let xmlDocument = try XMLDocumentReader.document(named: template.name)
////        let placeholders = xmlDocument.templatePlaceholders
////        
////        let missingRequiredPlaceholders = placeholders
////            .filter { !$0.optional && inputDictionary[$0] == nil }
////        
////        let requiredPlaceholderNodes = xmlDocument.findElementsRecursively(withAttributeName: "required")
////        requiredPlaceholderNodes.map {
////            let attribute = $0.attribute(forName: "required")
////            
////        }
////        
////        
////        guard missingRequiredPlaceholders.isEmpty else {
////            throw BuilderError.missingRequiredPlaceholderValues(missingRequiredPlaceholders)
////        }
////        
////        let missingOptionalPlaceholders = placeholders
////            .filter { $0.optional && inputDictionary[$0] == nil }
////        
////        removeMissingOptionalNodes(from: xmlDocument, with: inputDictionary)
////        
////        xmlDocument.findElementsRecursively(withAttributeName: "required")
////        
////        // Create a copy of the XML document to avoid mutating the original
//////        let xmlCopy = try document.createXMLTemplateDocument()
////        
////        // Replace placeholders and remove optional nodes if needed
////        replacePlaceholders(in: xmlDocument, with: inputDictionary)
////        removeEmptyOptionalNodes(from: xmlDocument, with: inputDictionary)
//        
//        // TODO: Return a `Prompt` type with the modified XML document
////        print(xmlCopy.xmlString(options: [.nodePrettyPrint, .nodeCompactEmptyElement]))
//    }
    
//    static private func getXMLDocument(for template: PromptTemplate) -> XMLDocument {
//        guard let document = Self.availableTemplateDocuments.first(where: { $0.name == template.name }) else {
//            fatalError("missing template")
//        }
//        return document.getXMLDocumentCopy()
//    }
    
    // Replace placeholders in the XML document
//    static func replacePlaceholders(in xmlDocument: XMLDocument, with inputDictionary: LanguageTask.InputDictionary) {
//        guard let rootElement = xmlDocument.rootElement() else { return }
//        
//        for placeholder in inputDictionary {
//            replacePlaceholder(in: rootElement, placeholder: placeholder.key, with: placeholder.value)
//        }
//    }
    
//    static func replacePlaceholder(in element: XMLElement, placeholder: LanguageTask.Placeholder, with value: String) {
//        // Replace placeholder in the element's content
//        if let content = element.stringValue, content.contains("{{\(placeholder.name)}}") {
//            element.stringValue = content.replacingOccurrences(of: "{{\(placeholder.name)}}", with: value)
//            element.removeAttribute(forName: "placeholders")
//        }
//        
//        // Recursively replace in child elements
//        for child in element.children ?? [] {
//            if let childElement = child as? XMLElement {
//                replacePlaceholder(in: childElement, placeholder: placeholder, with: value)
//            }
//        }
//    }
        
        // Remove optional nodes whose placeholders were not set
//    static func removeEmptyOptionalNodes(from xmlDocument: XMLDocument, with inputDictionary: PromptTemplate.InputDictionary) {
//        let optionalNodes = document.optionalNodes
//        
//        for node in optionalNodes {
//            if let placeholderAttr = node.attribute(forName: "placeholders")?.stringValue {
//                let placeholderNames = placeholderAttr
//                    .split(separator: ",")
//                    .map { $0.trimmingCharacters(in: .whitespaces) }
//                
//                // Check if any placeholder in this node was set
//                let hasSetPlaceholder = placeholderNames.contains { inputDictionary[$0] != nil }
//                
//                // Remove the node if no placeholders were set
//                if !hasSetPlaceholder {
//                    node.detach()
//                }
//            }
//        }
//    }
    
//    enum BuilderError: Error {
//        case missingRequiredPlaceholderValues([LanguageTask.Placeholder])
//    }
      
//}

//struct PromptTemplateDocument: @unchecked Sendable {
//    let name: String
//    private let xmlDocument: XMLDocument
//    
//    func getXMLDocumentCopy() -> XMLDocument {
//        xmlDocument.copy() as! XMLDocument
//    }
//
//    // Computed property to get all optional nodes
////    var optionalNodes: [XMLElement] {
////        return findElementsRecursively(in: _xmlDocument.rootElement(), withAttributeName: "optional", attributeValue: "true")
////    }
////    let placeholders: [PromptTemplatePlaceholder]
//    
//    // Custom initializer to set placeholders
//    init(name: String, xmlDocument: XMLDocument) {
//        self.name = name
//        self.xmlDocument = xmlDocument
//    }
//    
//}
//
//extension PromptTemplateDocument: CustomStringConvertible {
//    var description: String {
//        xmlDocument.xmlString(options: [.nodePrettyPrint, .nodeCompactEmptyElement])
//    }
//}


//class XMLDocumentReader {
//    static func document(named fileName: String) throws -> String {
//        guard let templateURL = Bundle.main.url(forResource: fileName, withExtension: "xml") else {
//            throw XMLTemplateError.fileNotFound("Could not find \(fileName).xml in bundle")
//        }
//        
//        do {
//            return try String(contentsOf: templateURL, encoding: .utf8)
//        } catch {
//            throw XMLTemplateError.fileReadError("Failed to read \(fileName).xml: \(error.localizedDescription)")
//        }
//    }
//}
