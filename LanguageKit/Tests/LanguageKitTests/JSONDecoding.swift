//
//  JSONDecoding.swift
//  LanguageKit
//
//  Created by Paul Kim on 10/21/24.
//

import Testing
import Foundation
@testable import LanguageKit

/// Tests the encoding and decoding of a simple Japanese sentence
@Test("English language descriptor has correct properties")
func testSimpleJapaneseSentence() throws {
    // GIVEN
    let jsonString = """
    {
      "type": "sentence",
      "content": "私は本を読みます。",
      "structure": "simple",
      "function": "declarative",
      "children": [
        {
          "type": "clause",
          "content": "私は本を読みます",
          "structure": "main",
          "function": "unknown",
          "children": [
            {
              "type": "phrase",
              "content": "私は",
              "structure": "nounPhrase",
              "children":
              [
                {
                  "type": "word",
                  "content": "私",
                  "function": "noun",
                  "children": []
                },
                {
                  "type": "word",
                  "content": "は",
                  "function": "particle",
                  "children": []
                }
              ]
            },
            {
              "type": "phrase",
              "content": "本を",
              "structure": "nounPhrase",
              "children": [
                {
                  "type": "word",
                  "content": "本",
                  "function": "noun",
                  "children": []
                },
                {
                  "type": "word",
                  "content": "を",
                  "function": "particle",
                  "children": []
                }
              ]
            },
            {
              "type": "phrase",
              "content": "読みます",
              "structure": "verbPhrase",
              "children": [
                {
                  "type": "word",
                  "content": "読みます",
                  "function": "verb",
                  "children": []
                }
              ]
            }
          ]
        }
      ]
    }
    """
    
    // WHEN
    let jsonData = jsonString.data(using: .utf8)!
    let decodedSentence = try JSONDecoder().decode(Japanese.Sentence.self, from: jsonData)
    
    // THEN
    #expect(decodedSentence.content == "私は本を読みます。")
    #expect(decodedSentence.structure == .simple)
    #expect(decodedSentence.function == .declarative)
    #expect(decodedSentence.children.count == 1)
    
    // Test main clause
    let mainClause = decodedSentence.children[0]
    #expect(mainClause.content == "私は本を読みます")
    #expect(mainClause.structure == .main)
    #expect(mainClause.function == .unknown)
    #expect(mainClause.children.count == 3)
    
    // Test subject phrase
    let subjectPhrase = mainClause.children[0]
    #expect(subjectPhrase.content == "私は")
    #expect(subjectPhrase.structure == .nounPhrase)
    #expect(subjectPhrase.children.count == 2)
    
    // Test object phrase
    let objectPhrase = mainClause.children[1]
    #expect(objectPhrase.content == "本を")
    #expect(objectPhrase.structure == .nounPhrase)
    #expect(objectPhrase.children.count == 2)
    
    // Test verb phrase
    let verbPhrase = mainClause.children[2]
    #expect(verbPhrase.content == "読みます")
    #expect(verbPhrase.structure == .verbPhrase)
    #expect(verbPhrase.children.count == 1)
    
    // Test round-trip encoding/decoding
    let encodedData = try JSONEncoder().encode(decodedSentence)
    let roundTripSentence = try JSONDecoder().decode(Japanese.Sentence.self, from: encodedData)
    #expect(roundTripSentence.content == decodedSentence.content)
    #expect(roundTripSentence.structure == decodedSentence.structure)
    #expect(roundTripSentence.function == decodedSentence.function)
    #expect(roundTripSentence.children.count == decodedSentence.children.count)
}

/// Tests error handling for invalid JSON
@Test("English language descriptor has correct properties")
func testInvalidJSON() throws {
    // Test invalid sentence type
    let invalidTypeJSON = """
    {
      "type": "invalid",
      "content": "test",
      "structure": {
        "sentence": "simple"
      },
      "function": {
        "sentence": "declarative"
      },
      "children": []
    }
    """
    
    do {
        let jsonData = invalidTypeJSON.data(using: .utf8)!
        _ = try JSONDecoder().decode(Japanese.Sentence.self, from: jsonData)
        assertionFailure("Expected decoding to fail for invalid type")
    } catch {
        // Expected error
        print("✅ Successfully caught invalid type error")
    }
    
    // Test invalid structure category
    let invalidStructureJSON = """
    {
      "type": "sentence",
      "content": "test",
      "structure": {
        "sentence": "invalid"
      },
      "function": {
        "sentence": "declarative"
      },
      "children": []
    }
    """
    
    do {
        let jsonData = invalidStructureJSON.data(using: .utf8)!
        _ = try JSONDecoder().decode(Japanese.Sentence.self, from: jsonData)
        assertionFailure("Expected decoding to fail for invalid structure")
    } catch {
        // Expected error
        print("✅ Successfully caught invalid structure error")
    }
    
    print("✅ All error handling tests passed")
}

/// Tests handling of complex sentence structures
@Test("English language descriptor has correct properties")
func testComplexSentence() throws {
    // GIVEN
    let jsonString = """
    {
      "type": "sentence",
      "content": "雨が降っているが、私は出かける。",
      "structure": {
        "sentence": "compound"
      },
      "function": {
        "sentence": "declarative"
      },
      "children": [
        {
          "type": "clause",
          "content": "雨が降っている",
          "structure": {
            "clause": "main"
          },
          "function": {
            "clause": "unknown"
          },
          "children": [
            {
              "type": "phrase",
              "content": "雨が",
              "structure": {
                "phrase": "nounPhrase"
              },
              "children": [
                {
                  "type": "word",
                  "content": "雨",
                  "function": {
                    "word": "noun"
                  },
                  "children": []
                },
                {
                  "type": "word",
                  "content": "が",
                  "function": {
                    "word": "particle"
                  },
                  "children": []
                }
              ]
            },
            {
              "type": "phrase",
              "content": "降っている",
              "structure": {
                "phrase": "verbPhrase"
              },
              "children": [
                {
                  "type": "word",
                  "content": "降っている",
                  "function": {
                    "word": "verb"
                  },
                  "children": []
                }
              ]
            }
          ]
        },
        {
          "type": "clause",
          "content": "私は出かける",
          "structure": {
            "clause": "main"
          },
          "function": {
            "clause": "unknown"
          },
          "children": [
            {
              "type": "phrase",
              "content": "私は",
              "structure": {
                "phrase": "nounPhrase"
              },
              "children": [
                {
                  "type": "word",
                  "content": "私",
                  "function": {
                    "word": "noun"
                  },
                  "children": []
                },
                {
                  "type": "word",
                  "content": "は",
                  "function": {
                    "word": "particle"
                  },
                  "children": []
                }
              ]
            },
            {
              "type": "phrase",
              "content": "出かける",
              "structure": {
                "phrase": "verbPhrase"
              },
              "children": [
                {
                  "type": "word",
                  "content": "出かける",
                  "function": {
                    "word": "verb"
                  },
                  "children": []
                }
              ]
            }
          ]
        }
      ]
    }
    """
    
    // WHEN
    let jsonData = jsonString.data(using: .utf8)!
    let decodedSentence = try JSONDecoder().decode(Japanese.Sentence.self, from: jsonData)
    
    // THEN
    #expect(decodedSentence.content == "雨が降っているが、私は出かける。")
    #expect(decodedSentence.structure == .compound)
    #expect(decodedSentence.function == .declarative)
    #expect(decodedSentence.children.count == 2)
    
    print("✅ Complex sentence test passed")
}

//
//// Run the tests
//let tests = JapaneseGrammarTests()
//try tests.testSimpleJapaneseSentence()
//try tests.testInvalidJSON()
//try tests.testComplexSentence()
