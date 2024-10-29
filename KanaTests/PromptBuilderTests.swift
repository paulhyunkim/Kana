//
//  PromptBuilderTests.swift
//  KanaTests
//
//  Created by Paul Kim on 10/28/24.
//

import Testing
import Foundation
@testable import Kana
import LanguageKit

@Suite("PromptBuilder Success Tests")
struct PromptBuilderSuccessTests {
    
    @Test("Succeeds with only required parameters")
    func testPromptBuildingWithoutOptionalParameters() throws {
        struct TestTask: LanguageTask {
            enum PlaceholderKey: String {
                case sourceText = "SOURCE_TEXT"
                case sourceLanguage = "SOURCE_LANGUAGE"
                case targetLanguage = "TARGET_LANGUAGE"
                case optionalParam = "OPTIONAL_PARAM"
            }
            
            static var templateName: String { "TestTemplate" }
            let sourceText = "Test content"
            let sourceLanguage = English.self
            let targetLanguage = Japanese.self
            
            var placeholderValues: [PlaceholderKey: String?] {
                [
                    .sourceText: sourceText,
                    .sourceLanguage: sourceLanguage.name,
                    .targetLanguage: targetLanguage.name,
                    .optionalParam: nil
                ]
            }
        }
        
        let task = TestTask()
        let prompt = try PromptBuilder.buildPrompt(task: task, bundle: .testBundle)
        let expectedSystemMessage = """
        <Role>
        Translation assistant for \(task.targetLanguage.name) from \(task.sourceLanguage.name)
        </Role>
        """
        let expectedUserMessage = """
        <Task>
        \(task.sourceText)
        </Task>
        """
        
        #expect(prompt.messages.contains(.system(expectedSystemMessage)), "System message does not match expectation")
        #expect(prompt.messages.contains(.user(expectedUserMessage)), "User message does not match expectation")
    }
    
    @Test("Succeeds with required paramteres and optional parameters")
    func testPromptBuildingWithOptionalParameters() throws {
        struct TestTask: LanguageTask {
            enum PlaceholderKey: String {
                case sourceText = "SOURCE_TEXT"
                case sourceLanguage = "SOURCE_LANGUAGE"
                case targetLanguage = "TARGET_LANGUAGE"
                case optionalText = "OPTIONAL_PARAM"
            }
            
            static var templateName: String { "TestTemplate" }
            let sourceText = "Test content"
            let optionalText = "Optional value"
            let sourceLanguage = English.self
            let targetLanguage = Japanese.self
            
            var placeholderValues: [PlaceholderKey: String?] {
                [
                    .sourceText: sourceText,
                    .sourceLanguage: sourceLanguage.name,
                    .targetLanguage: targetLanguage.name,
                    .optionalText: optionalText
                ]
            }
        }
        
        let task = TestTask()
        let prompt = try PromptBuilder.buildPrompt(task: task, bundle: .testBundle)
        let expectedSystemMessage = """
        <Role>
        Translation assistant for \(task.targetLanguage.name) from \(task.sourceLanguage.name)
        </Role>
        
        <Optional>
        \(task.optionalText)
        </Optional>
        """
        let expectedUserMessage = """
        <Task>
        \(task.sourceText)
        </Task>
        """
        
        #expect(prompt.messages.contains(.system(expectedSystemMessage)), "System message does not match expectation")
        #expect(prompt.messages.contains(.user(expectedUserMessage)), "User message does not match expectation")
    }

}

@Suite("PromptBuilder Error Tests")
struct PromptBuilderErrorTests {
    
    @Test("Fails with missing required parameters")
    func testMissingRequiredParameters() throws {
        struct TestTask: LanguageTask {
            enum PlaceholderKey: String {
                case sourceText = "SOURCE_TEXT"
                case sourceLanguage = "SOURCE_LANGUAGE"
                case targetLanguage = "TARGET_LANGUAGE"
                case optionalText = "OPTIONAL_PARAM"
            }
            
            static var templateName: String { "TestTemplate" }
            let sourceText = "Test content"
            let optionalText = "Optional value"
            let sourceLanguage = English.self
            let targetLanguage = Japanese.self
            
            var placeholderValues: [PlaceholderKey: String?] {
                [
                    // missing sourceText and sourceLanguage
                    .targetLanguage: targetLanguage.name,
                    .optionalText: optionalText
                ]
            }
        }
        
        do {
            _ = try PromptBuilder.buildPrompt(task: TestTask(), bundle: .testBundle)
            Issue.record("Prompt building should have failed")
        } catch PromptBuilder.BuilderError.missingRequiredPlaceholders(let params) {
            #expect(!params.isEmpty, "Should have missing required parameters")
            #expect(params.contains("SOURCE_TEXT"), "Should require SOURCE_TEXT parameter")
            #expect(params.contains("SOURCE_LANGUAGE"), "Should require TARGET_LANGUAGE parameter")
        } catch let error {
            Issue.record(error, "Caught unexpected error")
        }
    }

    @Test("Fails with file not found")
    func testFileNotFound() throws {
        struct TestTask: LanguageTask {
            enum PlaceholderKey: String {
                case sourceText = "SOURCE_TEXT"
            }
            
            static var templateName: String { "NonexistentTemplate" }
            let sourceText = "Test content"
            
            var placeholderValues: [PlaceholderKey: String?] {
                [
                    .sourceText: sourceText
                ]
            }
        }
        
        do {
            _ = try PromptBuilder.buildPrompt(task: TestTask(), bundle: .testBundle)
            Issue.record("Prompt building should have failed")
        } catch PromptBuilder.BuilderError.fileNotFound(let name) {
            #expect(name == "NonexistentTemplate", "Should identify missing file")
        } catch let error {
            Issue.record(error, "Caught unexpected error")
        }
    }

    @Test("Fails with template parsing error")
    func testTemplateParsingError() throws {
        struct TestTask: LanguageTask {
            enum PlaceholderKey: String {
                case sourceText = "SOURCE_TEXT"
            }
            
            static var templateName: String { "InvalidXMLTemplate" }
            let sourceText = "Test content"
            
            var placeholderValues: [PlaceholderKey: String?] {
                [
                    .sourceText: sourceText
                ]
            }
        }
        
        do {
            _ = try PromptBuilder.buildPrompt(task: TestTask(), bundle: .testBundle)
            Issue.record("Prompt building should have failed")
        } catch PromptBuilder.BuilderError.templateParsingFailed {
            // Expected error
        } catch let error {
            Issue.record(error, "Caught unexpected error")
        }
    }

    @Test("Fails with unhandled placeholders")
    func testUnhandledPlaceholders() throws {
        struct TestTask: LanguageTask {
            enum PlaceholderKey: String {
                case sourceText = "SOURCE_TEXT"
                case sourceLanguage = "SOURCE_LANGUAGE"
                // missing targetLanguage case
                case optionalText = "OPTIONAL_PARAM"
            }
            
            static var templateName: String { "TestTemplate" }
            let sourceText = "Test content"
            let optionalText = "Optional value"
            let sourceLanguage = English.self
            let targetLanguage = Japanese.self
            
            var placeholderValues: [PlaceholderKey: String?] {
                [
                    .sourceText: sourceText,
                    .sourceLanguage: sourceLanguage.name,
                    .optionalText: optionalText
                ]
            }
        }
        
        do {
            _ = try PromptBuilder.buildPrompt(task: TestTask(), bundle: .testBundle)
            Issue.record("Prompt building should have failed")
        } catch PromptBuilder.BuilderError.unhandledPlaceholders(let params) {
            #expect(!params.isEmpty, "Should have unmatched parameters")
            #expect(params.contains("TARGET_LANGUAGE"), "Should identify unmatched parameter")
        } catch let error {
            Issue.record(error, "Caught unexpected error")
        }
    }

    @Test("Fails with invalid template structure")
    func testInvalidTemplateStructure() throws {
        struct TestTask: LanguageTask {
            enum PlaceholderKey: String {
                case sourceText = "SOURCE_TEXT"
            }
            
            static var templateName: String { "InvalidStructureTemplate" }
            let sourceText = "Test content"
            
            var placeholderValues: [PlaceholderKey: String?] {
                [
                    .sourceText: sourceText
                ]
            }
        }

        do {
            _ = try PromptBuilder.buildPrompt(task: TestTask(), bundle: .testBundle)
            #expect(Bool(false), "Expected validation to fail for invalid structure")
        } catch PromptBuilder.BuilderError.invalidTemplateStructure(let reason) {
            #expect(!reason.isEmpty, "Should provide structure error reason")
            #expect(reason.contains("Missing"), "Should indicate missing required section")
        } catch let error {
            Issue.record(error, "Caught unexpected error")
        }
    }
    
}

struct Japanese: LanguageDescriptor {
    static var name: String = "Japanese"
    static var code: String = "ja"
    static var wordOrder: LanguageKit.WordOrder = .SOV
    static var hasGrammaticalGender: Bool = false
}

struct English: LanguageDescriptor {
    static var name: String = "English"
    static var code: String = "en"
    static var wordOrder: LanguageKit.WordOrder = .SVO
    static var hasGrammaticalGender: Bool = false
}

