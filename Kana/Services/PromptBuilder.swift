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
        case invalidTemplateStructure(String)
        case fileNotFound(String)
        case fileReadError(String)
        
        var errorDescription: String? {
            switch self {
            case .missingRequiredPlaceholders(let names):
                return "Missing required placeholder values: \(names.joined(separator: ", "))"
            case .templateParsingFailed(let reason):
                return "Failed to parse template XML: \(reason)"
            case .unmatchedPlaceholders(let placeholders):
                return "Found placeholders in template that aren't handled: \(placeholders.joined(separator: ", "))"
            case .invalidTemplateStructure(let reason):
                return "Invalid template structure: \(reason)"
            case .fileNotFound(let name):
                return "Could not find template file: \(name)"
            case .fileReadError(let reason):
                return "Failed to read template file: \(reason)"
            }
        }
    }
    
    static func buildPrompt<Task: LanguageTask>(task: Task, bundle: Bundle = .main) throws -> Prompt {
        let template = try loadTemplate(for: Task.templateName, in: bundle)
        try validateTemplate(template, for: task)
        return buildMessages(for: task, from: template)
    }
    
    // MARK: - Private Template Loading & Validation
    
    private static func loadTemplate(for name: String, in bundle: Bundle) throws -> PromptTemplate {
        guard let templateURL = bundle.url(forResource: name, withExtension: "xml") else {
            throw BuilderError.fileNotFound(name)
        }
        
        do {
            let xmlString = try String(contentsOf: templateURL, encoding: .utf8)
            let parser = XMLTemplateParser()
            let template = try parser.parse(xmlString)
            
            guard isValidStructure(template) else {
                throw BuilderError.invalidTemplateStructure("Invalid template structure")
            }
            
            return template
        } catch let error as BuilderError {
            throw error
        } catch {
            throw BuilderError.templateParsingFailed(error.localizedDescription)
        }
    }
    
    private static func isValidStructure(_ template: PromptTemplate) -> Bool {
        let hasValidSystemMessage = !template.systemTemplate.sections.isEmpty &&
            template.systemTemplate.sections.allSatisfy { !$0.name.isEmpty }
        
        let hasValidUserMessage = !template.userTemplate.sections.isEmpty &&
            template.userTemplate.sections.allSatisfy { !$0.name.isEmpty }
        
        let hasValidExamples = template.examples.allSatisfy { example in
            !example.userTemplate.sections.isEmpty &&
            example.userTemplate.sections.allSatisfy { !$0.name.isEmpty } &&
            !example.assistantTemplate.sections.isEmpty &&
            example.assistantTemplate.sections.allSatisfy { !$0.name.isEmpty }
        }
        
        return hasValidSystemMessage && hasValidUserMessage &&
            (template.examples.isEmpty || hasValidExamples)
    }
    
    private static func validateTemplate<Task: LanguageTask>(_ template: PromptTemplate, for task: Task) throws {
        var unmatchedParams = Set<String>()
        var missingRequiredParams = Set<String>()
        var handledParams = Set<Task.PlaceholderKey>()
        
        func validateSection(_ section: PromptTemplate.Section) {
            section.requiredParameters.forEach { param in
                if let key = Task.PlaceholderKey(rawValue: param) {
                    handledParams.insert(key)
                    if task.placeholderValues[key] == nil {
                        missingRequiredParams.insert(param)
                    }
                } else {
                    unmatchedParams.insert(param)
                }
            }
        }
        
        template.systemTemplate.sections.forEach(validateSection)
        template.userTemplate.sections.forEach(validateSection)
        template.examples.forEach { example in
            example.userTemplate.sections.forEach(validateSection)
            example.assistantTemplate.sections.forEach(validateSection)
        }
        
        if !unmatchedParams.isEmpty {
            throw BuilderError.unmatchedPlaceholders(Array(unmatchedParams))
        }
        
        if !missingRequiredParams.isEmpty {
            throw BuilderError.missingRequiredPlaceholders(Array(missingRequiredParams))
        }
    }
    
    // MARK: - Private Message Building
    
    private static func buildMessages<Task: LanguageTask>(for task: Task, from template: PromptTemplate) -> Prompt {
        let validValues = task.placeholderValues
            .compactMapValues { $0 }
            .reduce(into: [:]) { result, pair in
                result[pair.key.rawValue] = pair.value
            }
        
        return Prompt(
            systemMessage: buildMessage(from: template.systemTemplate, with: validValues),
            userMessage: buildMessage(from: template.userTemplate, with: validValues),
            exampleMessagePairs: template.examples.map { example in
                .init(
                    userMessage: buildMessage(from: example.userTemplate, with: validValues),
                    assistantMessage: buildMessage(from: example.assistantTemplate, with: validValues)
                )
            }
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
        if section.requiredParameters.isEmpty && section.optionalParameters.isEmpty {
            return !section.content.trimmingCharacters(in: .whitespaces).isEmpty
        }
        
        if !section.requiredParameters.isEmpty {
            return true
        }
        
        return section.optionalParameters.contains { values[$0] != nil }
    }
    
    private static func buildSection(_ section: PromptTemplate.Section, with values: [String: String]) -> String {
        var content = section.content
        
        let params = section.requiredParameters.union(section.optionalParameters)
        for param in params {
            if let value = values[param] {
                content = content.replacingOccurrences(of: "{{\(param)}}", with: value)
            }
        }
        
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
        case promptTemplate
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
        
        guard parser.parse() else {
            throw PromptBuilder.BuilderError.templateParsingFailed(parser.parserError?.localizedDescription ?? "Unknown parsing error")
        }
        
        // Validate required template components
        guard let systemTemplate = systemTemplate else {
            throw PromptBuilder.BuilderError.invalidTemplateStructure("Missing system message template")
        }
        
        guard let userTemplate = userTemplate else {
            throw PromptBuilder.BuilderError.invalidTemplateStructure("Missing user message template")
        }
        
        // Validate message structures
        guard isValidMessageStructure(systemTemplate) else {
            throw PromptBuilder.BuilderError.invalidTemplateStructure("Invalid system message structure")
        }
        
        guard isValidMessageStructure(userTemplate) else {
            throw PromptBuilder.BuilderError.invalidTemplateStructure("Invalid user message structure")
        }
        
        return PromptTemplate(
            systemTemplate: systemTemplate,
            userTemplate: userTemplate,
            examples: examples
        )
    }

    private func isValidMessageStructure(_ message: PromptTemplate.MessageTemplate) -> Bool {
        !message.sections.isEmpty && message.sections.allSatisfy { !$0.name.isEmpty }
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
        case .promptTemplate:
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
        case .promptTemplate:
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
