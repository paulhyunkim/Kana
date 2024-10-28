//
//  PromptBuilder.swift
//  Kana
//
//  Created by Paul Kim on 10/24/24.
//

import Foundation

// MARK: - Types
fileprivate struct PromptTemplate {
    let systemTemplate: MessageTemplate
    let userTemplate: MessageTemplate
    let examples: [ExampleTemplate]
    
    struct MessageTemplate {
        let sections: [Section]
    }
    
    struct ExampleTemplate {
        let userTemplate: MessageTemplate
        let assistantTemplate: MessageTemplate
    }
    
    struct Section {
        let name: String
        let content: String
        let requiredParameters: Set<String>
        let optionalParameters: Set<String>
    }
}

// MARK: - Public Interface
struct PromptBuilder {
    enum BuilderError: LocalizedError {
        case missingRequiredPlaceholders([String])
        case templateParsingFailed(String)
        case unmatchedPlaceholders([String])
        case invalidTemplate(String)
        case missingTemplateSection(String)
        case fileNotFound(String)
        case fileReadError(String)
        
        var errorDescription: String? {
            switch self {
            case .missingRequiredPlaceholders(let names):
                return "Missing required placeholders: \(names.joined(separator: ", "))"
            case .templateParsingFailed(let reason):
                return "Failed to parse template: \(reason)"
            case .unmatchedPlaceholders(let placeholders):
                return "Found placeholders in template that aren't handled: \(placeholders.joined(separator: ", "))"
            case .invalidTemplate(let reason):
                return "Invalid template structure: \(reason)"
            case .missingTemplateSection(let section):
                return "Missing required template section: \(section)"
            case .fileNotFound(let name):
                return "Could not find template file: \(name)"
            case .fileReadError(let reason):
                return "Failed to read template file: \(reason)"
            }
        }
    }
    
    static func buildPrompt<Task: LanguageTask>(task: Task) throws -> Prompt {
        let template = try loadTemplate(for: Task.templateName)
        try validateParameters(in: template, for: Task.self)
        try validateRequiredValues(for: task, in: template)
        
        return buildMessages(for: task, from: template)
    }
    
    // MARK: - Private Template Loading
    
    private static func loadTemplate(for name: String) throws -> PromptTemplate {
        guard let templateURL = Bundle.main.url(forResource: name, withExtension: "xml") else {
            throw BuilderError.fileNotFound(name)
        }
        
        do {
            let xmlString = try String(contentsOf: templateURL, encoding: .utf8)
            let parser = XMLTemplateParser()
            return try parser.parse(xmlString)
        } catch let error as BuilderError {
            throw error
        } catch {
            throw BuilderError.fileReadError(error.localizedDescription)
        }
    }
    
    // MARK: - Private Validation
    
    private static func validateParameters<Task: LanguageTask>(in template: PromptTemplate, for taskType: Task.Type) throws {
        var unmatchedParams = Set<String>()
        var handledParams = Set<Task.PlaceholderKey>()
        
        func processSection(_ section: PromptTemplate.Section) {
            section.requiredParameters.forEach { param in
                if let key = Task.PlaceholderKey(rawValue: param) {
                    handledParams.insert(key)
                } else {
                    unmatchedParams.insert(param)
                }
            }
        }
        
        template.systemTemplate.sections.forEach(processSection)
        template.userTemplate.sections.forEach(processSection)
        template.examples.forEach { example in
            example.userTemplate.sections.forEach(processSection)
            example.assistantTemplate.sections.forEach(processSection)
        }
        
        if !unmatchedParams.isEmpty {
            throw BuilderError.unmatchedPlaceholders(Array(unmatchedParams))
        }
    }
    
    private static func validateRequiredValues<Task: LanguageTask>(for task: Task, in template: PromptTemplate) throws {
        var requiredParams = Set<String>()
        
        func addRequiredParams(from sections: [PromptTemplate.Section]) {
            sections.forEach { section in
                section.requiredParameters.forEach { requiredParams.insert($0) }
            }
        }
        
        addRequiredParams(from: template.systemTemplate.sections)
        addRequiredParams(from: template.userTemplate.sections)
        template.examples.forEach { example in
            addRequiredParams(from: example.userTemplate.sections)
            addRequiredParams(from: example.assistantTemplate.sections)
        }
        
        let missingParams = requiredParams
            .compactMap { Task.PlaceholderKey(rawValue: $0) }
            .filter { task.placeholderValues[$0] == nil }
            .map(\.rawValue)
        
        if !missingParams.isEmpty {
            throw BuilderError.missingRequiredPlaceholders(missingParams)
        }
    }
    
    // MARK: - Private Message Building
    
    private static func buildMessages<Task: LanguageTask>(for task: Task, from template: PromptTemplate) -> Prompt {
        let validValues = task.placeholderValues
            .compactMapValues { $0 }
            .reduce(into: [:]) { result, pair in
                result[pair.key.rawValue] = pair.value
            }
        
        let systemMessage = buildMessage(from: template.systemTemplate, with: validValues)
        let userMessage = buildMessage(from: template.userTemplate, with: validValues)
        
        let examplePairs = template.examples.map { example in
            Prompt.ExampleMessagePair(
                userMessage: buildMessage(from: example.userTemplate, with: validValues),
                assistantMessage: buildMessage(from: example.assistantTemplate, with: validValues)
            )
        }
        
        return Prompt(
            systemMessage: systemMessage,
            userMessage: userMessage,
            exampleMessagePairs: examplePairs
        )
    }
    
    private static func buildMessage(from template: PromptTemplate.MessageTemplate, with values: [String: String]) -> String {
        template.sections
            .filter { shouldIncludeSection($0, with: values) }
            .map { buildSection($0, with: values) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
    }
    
    private static func shouldIncludeSection(_ section: PromptTemplate.Section, with values: [String: String]) -> Bool {
        let isEmpty = section.content.trimmingCharacters(in: .whitespaces).isEmpty
        
        // Always include non-empty sections with no parameters
        if section.requiredParameters.isEmpty && section.optionalParameters.isEmpty {
            return !isEmpty
        }
        
        // Include if it has any required parameters (which we know have values due to validation)
        if !section.requiredParameters.isEmpty {
            return true
        }
        
        // For sections with only optional parameters, include only if any parameter has a value
        if !section.optionalParameters.isEmpty {
            return section.optionalParameters.contains { param in
                values[param] != nil
            }
        }
        
        return false
    }
    
    private static func buildSection(_ section: PromptTemplate.Section, with values: [String: String]) -> String {
        var content = section.content
        
        // Replace all parameters that have values
        for param in section.requiredParameters.union(section.optionalParameters) {
            if let value = values[param] {
                content = content.replacingOccurrences(of: "{{\(param)}}", with: value)
            }
        }
        
        // Clean up the content
        let processedContent = content
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
        
        guard !processedContent.isEmpty else { return "" }
        
        return """
        <\(section.name)>
        \(processedContent)
        </\(section.name)>
        """
    }
}

// MARK: - Private XML Parser
fileprivate class XMLTemplateParser: NSObject, XMLParserDelegate {
    private enum Element: String {
        case section
        case message
        case example
        case template = "prompttemplate"
    }
    
    private enum Attribute: String {
        case name
        case role
        case requiredParameters = "required-parameters"
        case optionalParameters = "optional-parameters"
    }
    
    private var currentElement: Element?
    private var currentContent = ""
    private var currentRole = ""
    private var currentName = ""
    private var currentRequiredParams: Set<String> = []
    private var currentOptionalParams: Set<String> = []
    
    private var sections: [PromptTemplate.Section] = []
    private var systemTemplate: PromptTemplate.MessageTemplate?
    private var userTemplate: PromptTemplate.MessageTemplate?
    private var examples: [PromptTemplate.ExampleTemplate] = []
    private var currentExample: (user: PromptTemplate.MessageTemplate?, assistant: PromptTemplate.MessageTemplate?)?
    
    func parse(_ xmlString: String) throws -> PromptTemplate {
        guard let data = xmlString.data(using: .utf8) else {
            throw PromptBuilder.BuilderError.templateParsingFailed("Invalid XML data")
        }
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        guard parser.parse(),
              let systemTemplate = systemTemplate,
              let userTemplate = userTemplate else {
            throw PromptBuilder.BuilderError.templateParsingFailed("Failed to parse required template sections")
        }
        
        return PromptTemplate(
            systemTemplate: systemTemplate,
            userTemplate: userTemplate,
            examples: examples
        )
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        guard let element = Element(rawValue: elementName.lowercased()) else { return }
        currentElement = element
        
        switch element {
        case .section:
            handleSectionStart(attributes: attributeDict)
        case .message:
            handleMessageStart(attributes: attributeDict)
        case .example:
            currentExample = (user: nil, assistant: nil)
        case .template:
            break
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
        case .example:
            finalizeExampleElement()
        case .template:
            break
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
        let message = PromptTemplate.MessageTemplate(sections: sections)
        
        if let example = currentExample {
            switch currentRole {
            case "user":
                currentExample?.user = message
            case "assistant":
                currentExample?.assistant = message
            default:
                break
            }
        } else {
            switch currentRole {
            case "system":
                systemTemplate = message
            case "user":
                userTemplate = message
            default:
                break
            }
        }
        
        sections = []
    }
    
    private func finalizeExampleElement() {
        if let example = currentExample,
           let user = example.user,
           let assistant = example.assistant {
            examples.append(PromptTemplate.ExampleTemplate(
                userTemplate: user,
                assistantTemplate: assistant
            ))
        }
        currentExample = nil
    }
    
    private func resetSectionState() {
        currentRequiredParams = []
        currentOptionalParams = []
    }
}
