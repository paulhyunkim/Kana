//
//  PromptBuilder.swift
//  Kana
//
//  Created by Paul Kim on 10/24/24.
//

import Foundation
import LanguageKit

// MARK: - Public Interface
struct PromptBuilder {
    
    enum BuilderError: LocalizedError {
        case missingRequiredPlaceholders([String])
        case templateParsingFailed(String)
        case unmatchedPlaceholders([String])
        case invalidTemplate(String) // New error case
        
        public var errorDescription: String? {
            switch self {
            case .missingRequiredPlaceholders(let names):
                return "Missing required placeholders: \(names.joined(separator: ", "))"
            case .templateParsingFailed(let reason):
                return "Failed to parse template: \(reason)"
            case .unmatchedPlaceholders(let placeholders):
                return "Found placeholders in template that aren't handled: \(placeholders.joined(separator: ", "))"
            case .invalidTemplate(let reason):
                return "Invalid template structure: \(reason)"
            }
        }
    }
    
    static func buildPrompt<Task: LanguageTask>(task: Task) throws -> Prompt {
        // Load and parse template XML
        let template = try loadTemplate(for: Task.templateName)

        // Validate all template parameters are handled by the task
        try validateParameters(in: template, for: Task.self)
        
        // Ensure all required parameters have values
        try validateRequiredValues(for: task, in: template)

        // Build messages with validated parameters
        return try buildMessages(for: task, from: template)
    }
    
    // MARK: - Private Helpers
    
    private static func loadTemplate(for name: String) throws -> PromptTemplate {
        let xmlString = try XMLDocumentReader.document(named: name)
        let parser = XMLTemplateParser()
        
        guard let template = parser.parse(xmlString) else {
            throw BuilderError.templateParsingFailed("XML parsing failed")
        }
        
        return template
    }
    
    private static func validateParameters<Task: LanguageTask>(in template: PromptTemplate, for taskType: Task.Type) throws {
        // Extract all required parameters and check if they're valid for this task
        let (unmatchedParams, _) = template.messages.reduce(into: (Set<String>(), Set<Task.PlaceholderKey>())) { result, message in
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
        
        if !unmatchedParams.isEmpty {
            throw BuilderError.unmatchedPlaceholders(Array(unmatchedParams))
        }
    }
    
    private static func validateRequiredValues<Task: LanguageTask>(for task: Task, in template: PromptTemplate) throws {
        // Extract required parameters and ensure they have values
        let requiredParams = Set(template.messages.flatMap { message in
            message.sections.flatMap { $0.requiredParameters }
        })
        
        let missingParams = requiredParams
            .compactMap { Task.PlaceholderKey(rawValue: $0) }
            .filter { task.placeholderValues[$0] == nil }
            .map(\.rawValue)
        
        if !missingParams.isEmpty {
            throw BuilderError.missingRequiredPlaceholders(missingParams)
        }
    }

    private static func buildMessages<Task: LanguageTask>(for task: Task, from template: PromptTemplate) throws -> Prompt {
        // Convert placeholder values to string dictionary, removing nil values
        let validValues: [String: String] = task.placeholderValues
            .compactMapValues { $0 }
            .reduce(into: [:]) { result, pair in
                result[pair.key.rawValue] = pair.value
            }
    
        // Get system and user messages
        guard let systemMessage = template.messages.first(where: { $0.role == "system" })?.build(with: validValues) else {
            throw BuilderError.invalidTemplate("Missing system message")
        }
        
        guard let userMessage = template.messages.first(where: { $0.role == "user" })?.build(with: validValues) else {
            throw BuilderError.invalidTemplate("Missing user message")
        }
        
        return Prompt(
            systemMessage: systemMessage,
            userMessage: userMessage
        )
    }
}

// MARK: - Private XML Handling
fileprivate struct XMLDocumentReader {
    enum ReaderError: Error {
        case fileNotFound(String)
        case fileReadError(String)
    }
    
    static func document(named fileName: String) throws -> String {
        guard let templateURL = Bundle.main.url(forResource: fileName, withExtension: "xml") else {
            throw ReaderError.fileNotFound("Could not find \(fileName).xml in bundle")
        }
        
        do {
            return try String(contentsOf: templateURL, encoding: .utf8)
        } catch {
            throw ReaderError.fileReadError("Failed to read \(fileName).xml: \(error.localizedDescription)")
        }
    }
}

fileprivate class XMLTemplateParser: NSObject, XMLParserDelegate {
    // XML element types
    private enum Element: String {
        case section
        case message
    }
    
    // XML attribute names
    private enum Attribute: String {
        case name
        case role
        case requiredParameters = "required-parameters"
        case optionalParameters = "optional-parameters"
    }
    
    // Parser state
    private var currentElement: Element?
    private var currentContent = ""
    private var currentRole = ""
    private var currentName = ""
    private var currentRequiredParams: Set<String> = []
    private var currentOptionalParams: Set<String> = []
    
    private var sections: [PromptTemplate.Section] = []
    private var messages: [PromptTemplate.Message] = []
    
    func parse(_ xmlString: String) -> PromptTemplate? {
        guard let data = xmlString.data(using: .utf8) else { return nil }
        let parser = XMLParser(data: data)
        parser.delegate = self
        return parser.parse() ? PromptTemplate(messages: messages) : nil
    }
    
    // MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        guard let element = Element(rawValue: elementName.lowercased()) else { return }
        currentElement = element
        
        switch element {
        case .section:
            handleSectionStart(attributes: attributeDict)
        case .message:
            handleMessageStart(attributes: attributeDict)
        }
    }
    
    private func handleSectionStart(attributes: [String: String]) {
        currentName = attributes[Attribute.name.rawValue] ?? ""
        currentRequiredParams = Set(
            (attributes[Attribute.requiredParameters.rawValue] ?? "")
                .split(separator: " ")
                .map(String.init)
        )
        currentOptionalParams = Set(
            (attributes[Attribute.optionalParameters.rawValue] ?? "")
                .split(separator: " ")
                .map(String.init)
        )
        currentContent = ""
    }
    
    private func handleMessageStart(attributes: [String: String]) {
        currentRole = attributes[Attribute.role.rawValue] ?? ""
        sections = []
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == .section {
            currentContent += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let element = Element(rawValue: elementName.lowercased()) else { return }
        
        switch element {
        case .section:
            finalizeSectionElement()
        case .message:
            finalizeMessageElement()
        }
    }
    
    private func finalizeSectionElement() {
        let content = currentContent.trimmingCharacters(in: .whitespacesAndNewlines)
        let section = PromptTemplate.Section(
            name: currentName,
            content: content,
            requiredParameters: currentRequiredParams,
            optionalParameters: currentOptionalParams
        )
        sections.append(section)
        resetSectionState()
    }
    
    private func finalizeMessageElement() {
        let message = PromptTemplate.Message(role: currentRole, sections: sections)
        messages.append(message)
    }
    
    private func resetSectionState() {
        currentRequiredParams = []
        currentOptionalParams = []
    }
}
