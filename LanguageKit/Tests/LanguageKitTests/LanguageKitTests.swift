import Testing
@testable import LanguageKit

@Suite struct LanguageDescriptorTests {
    
    @Test("English language descriptor has correct properties")
    func testEnglishProperties() throws {
        let english = English()
        
        #expect(english.name == "English")
        #expect(english.code == "en")
        #expect(english.wordOrder == .SVO)
        #expect(!english.hasGrammaticalGender)
    }
    
    @Test("Japanese language descriptor has correct properties")
    func testJapaneseProperties() throws {
        let japanese = Japanese()
        
        #expect(japanese.name == "Japanese")
        #expect(japanese.code == "ja")
        #expect(japanese.wordOrder == .SOV)
        #expect(!japanese.hasGrammaticalGender)
    }
    
    // MARK: - Sentence Structure Tests
    
    @Test("English sentences can be properly constructed")
    func testEnglishSentenceConstruction() throws {
        // Setup test data
        let nounPhrase = English.Phrase(
            content: "the cat",
            structure: .nounPhrase,
            children: []
        )
        
        let verbPhrase = English.Phrase(
            content: "sleeps soundly",
            structure: .verbPhrase,
            children: []
        )
        
        let clause = English.Clause(
            content: "the cat sleeps soundly",
            structure: .independent,
            function: .main,
            children: [nounPhrase, verbPhrase]
        )
        
        let sentence = English.Sentence(
            content: "The cat sleeps soundly.",
            structure: .simple,
            function: .declarative,
            children: [clause]
        )
        
        // Verify structure
        #expect(sentence.content == "The cat sleeps soundly.")
        #expect(sentence.structure == .simple)
        #expect(sentence.function == .declarative)
        #expect(sentence.children.count == 1)
        
        // Verify clause composition
        let firstClause = sentence.children[0]
        #expect(firstClause.children.count == 2)
        #expect(firstClause.children[0].structure == .nounPhrase)
        #expect(firstClause.children[1].structure == .verbPhrase)
    }
    
}
 
//@Suite struct WordCategoryTests {
//    
//    @Test("English words are properly categorized")
//    func testEnglishWordCategories() throws {
//        // Test noun categorization
//        let noun = English.Word(
//            content: "cat",
//            function: .noun(.common),
//            children: []
//        )
//        
//        if case .noun(let type) = noun.function {
//            #expect(type == .common)
//        } else {
//            throw XCTestError(.failureWhileWaiting, "Expected noun type")
//        }
//        
//        // Test verb categorization
//        let verb = English.Word(
//            content: "run",
//            function: .verb(.action),
//            children: []
//        )
//        
//        if case .verb(let type) = verb.function {
//            #expect(type == .action)
//        } else {
//            throw XCTestError(.failureWhileWaiting, "Expected verb type")
//        }
//    }
//    
//    @Test("Different word types maintain correct properties")
//    func testWordTypeProperties() throws {
//        let words = [
//            ("happy", English.Word(content: "happy", function: .adjective(.descriptive), children: [])),
//            ("quickly", English.Word(content: "quickly", function: .adverb(.manner), children: [])),
//            ("the", English.Word(content: "the", function: .article(.definite), children: []))
//        ]
//        
//        for (expectedContent, word) in words {
//            #expect(word.content == expectedContent)
//        }
//    }
//    
//}

//@Suite struct JapaneseSpecificTests {
//    
//    @Test("Japanese particles have correct properties")
//    func testJapaneseParticles() throws {
//        let particles = [
//            ("は", Japanese.Particle(content: "は", function: .binding)),
//            ("が", Japanese.Particle(content: "が", function: .caseMarking)),
//            ("を", Japanese.Particle(content: "を", function: .caseMarking))
//        ]
//        
//        for (content, particle) in particles {
//            #expect(particle.content == content)
//        }
//    }
//    
//    // MARK: - Morpheme Tests
//    
//    @Test("Morphemes maintain correct structural and functional properties")
//    func testMorphemeProperties() throws {
//        let morphemes = [
//            English.Morpheme(content: "teach", structure: .free, function: .root),
//            English.Morpheme(content: "er", structure: .bound, function: .derivational),
//            English.Morpheme(content: "s", structure: .bound, function: .inflectional)
//        ]
//        
//        #expect(morphemes[0].structure == .free)
//        #expect(morphemes[0].function == .root)
//        #expect(morphemes[1].structure == .bound)
//        #expect(morphemes[1].function == .derivational)
//        #expect(morphemes[2].function == .inflectional)
//    }
//    
//    // MARK: - Script Tests
//    
//    @Test("Languages have correct script configurations")
//    func testLanguageScripts() throws {
//        let english = English()
//        let japanese = Japanese()
//        
//        // Test English script
//        #expect(english.scripts.count == 1)
//        #expect(english.scripts[0].name == "Latin")
//        #expect(english.scripts[0].category == .alphabetic)
//        #expect(english.scripts[0].hasCase)
//        
//        // Test Japanese scripts
//        #expect(japanese.scripts.count == 3)
//        #expect(japanese.scripts.contains { $0.name == "Hiragana" })
//        #expect(japanese.scripts.contains { $0.name == "Kanji" })
//    }
//    
//}

    
// MARK: - Complex Sentence Tests

//@Test("Complex sentences maintain structural integrity")
//func testComplexSentenceStructure() throws {
//    let sentence = try buildComplexSentence()
//    
//    #expect(sentence.children.count == 1)
//    #expect(sentence.children[0].children.count == 2)
//    
//    let mainClause = sentence.children[0]
//    #expect(mainClause.structure == .independent)
//    
//    // Test phrase structure
//    let subjectPhrase = mainClause.children[0]
//    #expect(subjectPhrase.structure == .nounPhrase)
//    #expect(subjectPhrase.children.count == 3)
//    
//    let verbPhrase = mainClause.children[1]
//    #expect(verbPhrase.structure == .verbPhrase)
//    #expect(verbPhrase.children.count == 4)
//}

// MARK: - Helper Methods

private func buildComplexSentence() throws -> English.Sentence {
    // Create words
    let the1 = English.Word(content: "the", function: .article(.definite), children: [])
    let big = English.Word(content: "big", function: .adjective(.descriptive), children: [])
    let cat = English.Word(content: "cat", function: .noun(.common), children: [])
    let chased = English.Word(content: "chased", function: .verb(.action), children: [])
    let the2 = English.Word(content: "the", function: .article(.definite), children: [])
    let small = English.Word(content: "small", function: .adjective(.descriptive), children: [])
    let mouse = English.Word(content: "mouse", function: .noun(.common), children: [])
    
    // Create phrases
    let subjectPhrase = English.Phrase(
        content: "the big cat",
        structure: .nounPhrase,
        children: [the1, big, cat]
    )
    
    let verbPhrase = English.Phrase(
        content: "chased the small mouse",
        structure: .verbPhrase,
        children: [chased, the2, small, mouse]
    )
    
    // Create clause
    let mainClause = English.Clause(
        content: "The big cat chased the small mouse",
        structure: .independent,
        function: .main,
        children: [subjectPhrase, verbPhrase]
    )
    
    // Create and return sentence
    return English.Sentence(
        content: "The big cat chased the small mouse.",
        structure: .simple,
        function: .declarative,
        children: [mainClause]
    )
}

