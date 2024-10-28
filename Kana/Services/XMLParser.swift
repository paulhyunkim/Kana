//
//  XMLParser.swift
//  Kana
//
//  Created by Paul Kim on 10/27/24.
//

import Foundation

// MARK: - Parser
class XMLTemplateParser: NSObject, XMLParserDelegate {
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
        if parser.parse() {
            return PromptTemplate(messages: messages)
        }
        return nil
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        guard let element = Element(rawValue: elementName.lowercased()) else {
            return
        }
        currentElement = element
        
        switch element {
        case .section:
            currentName = attributeDict[Attribute.name.rawValue] ?? ""
            currentRequiredParams = Set(
                (attributeDict[Attribute.requiredParameters.rawValue] ?? "")
                    .split(separator: " ")
                    .map(String.init)
            )
            currentOptionalParams = Set(
                (attributeDict[Attribute.optionalParameters.rawValue] ?? "")
                    .split(separator: " ")
                    .map(String.init)
            )
            currentContent = ""
        case .message:
            currentRole = attributeDict[Attribute.role.rawValue] ?? ""
            sections = []
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == .section {
            currentContent += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let element = Element(rawValue: elementName.lowercased()) else {
            return
        }
        switch element {
        case .section:
            let content = currentContent.trimmingCharacters(in: .whitespacesAndNewlines)
            let section = PromptTemplate.Section(
                name: currentName,
                content: content,
                requiredParameters: currentRequiredParams,
                optionalParameters: currentOptionalParams
            )
            sections.append(section)
            currentRequiredParams = []
            currentOptionalParams = []
        case .message:
            let message = PromptTemplate.Message(role: currentRole, sections: sections)
            messages.append(message)
        }
    }
}

extension XMLTemplateParser {
    enum Element: String {
        case section
        case message
    }
    
    enum Attribute: String {
        case name
        case role
        case requiredParameters = "required-parameters"
        case optionalParameters = "optional-parameters"
    }
}

// MARK: - Extensions
extension PromptTemplate.Section {
    func replacingPlaceholders(with values: [String: String]) -> String {
        var content = self.content
        
        // Replace required parameters
        for param in requiredParameters {
            if let value = values[param] {
                content = content.replacingOccurrences(of: "{{\(param)}}", with: value)
            }
        }
        
        // Replace optional parameters
        for param in optionalParameters {
            if let value = values[param] {
                content = content.replacingOccurrences(of: "{{\(param)}}", with: value)
            }
        }
        
        return content
    }
}

extension PromptTemplate.Message {
    func build(with values: [String: String]) -> String {
        sections
            .filter { section in
                // Keep section if it has any required parameters
                !section.requiredParameters.isEmpty ||
                // Or if it has optional parameters that have values
                section.optionalParameters.contains(where: values.keys.contains)
            }
            .map { section in
                let processedContent = section.replacingPlaceholders(with: values)
                    .components(separatedBy: .newlines)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
                    .joined(separator: "\n")
                
                return """
                <\(section.name)>
                \(processedContent)
                </\(section.name)>
                """
            }
            .joined(separator: "\n\n")
    }
}

struct XMLDocumentReader {
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
