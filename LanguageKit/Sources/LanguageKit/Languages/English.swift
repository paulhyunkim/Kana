////
////  English.swift
////  LanguageKit
////
////  Created by Paul Kim on 10/21/24.
////
//
//import Foundation
//
//public struct English: LanguageDescriptor {
//    public var name: String = "English"
//    public var code: String = "en"
//    public var wordOrder: WordOrder = .SVO
//    public var hasGrammaticalGender: Bool = false
//}
//
//// MARK: - Sentence
//
//extension English: SentenceStructured {
//    
//    
//    public struct Sentence: SyntacticUnit, GrammaticalStructureCategorizable, GrammaticalFunctionCategorizable, GrammaticalUnitComposable {
//        public typealias Language = English
//        public typealias StructureCategory = SentenceStructureCategory
//        public typealias FunctionCategory = SentenceFunctionCategory
//        public typealias Child = Clause
//        
//        public var content: String
//        public var structure: StructureCategory
//        public var function: FunctionCategory
//        public var children: [Child]
//        
//        public init(content: String, structure: StructureCategory, function: FunctionCategory, children: [Child]) {
//            self.content = content
//            self.structure = structure
//            self.function = function
//            self.children = children
//        }
//    }
//    
//    public enum SentenceStructureCategory: GrammaticalStructureCategory {
//        /// A simple sentence consists of one independent clause with a subject and predicate.
//        /// It expresses a complete thought in its most basic form.
//        ///
//        /// - Example: "The cat sleeps."
//        case simple
//        
//        /// A compound sentence consists of two or more independent clauses joined by coordinating
//        /// conjunctions (FANBOYS: for, and, nor, but, or, yet, so) or semicolons.
//        ///
//        /// - Example: "The sun is shining, but the wind is cold."
//        case compound
//        
//        /// A complex sentence contains one independent clause and at least one dependent clause.
//        /// The clauses are connected by subordinating conjunctions or relative pronouns.
//        ///
//        /// - Example: "When it rains, I read books."
//        case complex
//        
//        /// A compound-complex sentence has at least two independent clauses and one or more
//        /// dependent clauses.
//        ///
//        /// - Example: "Although it was raining, John went for a run, and Mary stayed home."
//        case compoundComplex
//    }
//    
//    public enum SentenceFunctionCategory: GrammaticalFunctionCategory {
//        /// A declarative sentence makes a statement or declares something as fact.
//        /// It ends with a period.
//        ///
//        /// - Example: "The Earth orbits the Sun."
//        case declarative
//        
//        /// An interrogative sentence asks a question and ends with a question mark.
//        /// It often begins with a question word (who, what, where, when, why, how) or
//        /// auxiliary verb (is, are, do, does, etc.).
//        ///
//        /// - Example: "Where did you go?"
//        case interrogative
//        
//        /// An imperative sentence gives a command or makes a request.
//        /// It often begins with a verb and may have an implied subject (you).
//        ///
//        /// - Example: "Please close the door."
//        case imperative
//        
//        /// An exclamatory sentence expresses strong emotion and ends with an exclamation mark.
//        ///
//        /// - Example: "What a beautiful day!"
//        case exclamatory
//    }
//}
//
//// MARK: - Clause
//
//extension English: ClauseStructured {
//    
//    public struct Clause: SyntacticUnit, GrammaticalStructureCategorizable, GrammaticalFunctionCategorizable, GrammaticalUnitComposable {
//        public typealias Language = English
//        public typealias StructureCategory = ClauseStructureCategory
//        public typealias FunctionCategory = ClauseFunctionCategory
//        public typealias Child = Phrase
//        
//        public var content: String
//        public var structure: StructureCategory
//        public var function: FunctionCategory
//        public var children: [Child]
//        
//        public init(content: String, structure: StructureCategory, function: FunctionCategory, children: [Child]) {
//            self.content = content
//            self.structure = structure
//            self.function = function
//            self.children = children
//        }
//    }
//    
//    public enum ClauseStructureCategory: GrammaticalStructureCategory {
//        /// An independent clause can stand alone as a complete sentence.
//        /// It contains a subject and predicate and expresses a complete thought.
//        ///
//        /// - Example: "The dog barks."
//        case independent
//        
//        /// A dependent clause cannot stand alone as a complete sentence.
//        /// It depends on an independent clause to make sense.
//        ///
//        /// Types include:
//        /// - Adverb clause: "when it rains"
//        /// - Adjective clause: "who lives next door"
//        /// - Noun clause: "what she said"
//        case dependent(DependentClauseType)
//        
//        /// A relative clause provides additional information about a noun.
//        /// It begins with a relative pronoun (who, whom, whose, which, that).
//        ///
//        /// - Example: "The book that I bought"
//        case relative
//        
//        /// A participial clause is a dependent clause that contains a participle
//        /// or participial phrase.
//        ///
//        /// - Example: "Running through the park, ..."
//        case participial
//    }
//    
//    public enum DependentClauseType: GrammaticalFunctionCategory {
//        /// An adverb clause modifies a verb, adjective, or other adverb.
//        /// It answers questions like when, where, why, how, to what extent.
//        ///
//        /// - Example: "because it was raining"
//        case adverbial
//        
//        /// An adjective clause modifies a noun or pronoun.
//        /// It begins with a relative pronoun or relative adverb.
//        ///
//        /// - Example: "who lives next door"
//        case adjectival
//        
//        /// A noun clause functions as a noun in the sentence.
//        /// It can be a subject, object, or complement.
//        ///
//        /// - Example: "what she said"
//        case nominal
//    }
//    
//    public enum ClauseFunctionCategory: GrammaticalFunctionCategory {
//        /// Functions as the main statement of the sentence
//        case main
//        
//        /// Modifies or provides additional information about the main clause
//        case subordinate
//        
//        /// Introduces a condition
//        case conditional
//        
//        /// Expresses purpose or intention
//        case purpose
//        
//        /// States a result or consequence
//        case result
//        
//        /// Provides a reason or cause
//        case reason
//    }
//}
//
//// MARK: - Phrase
//
//extension English: PhraseStructured {
//    
//    public struct Phrase: SyntacticUnit, GrammaticalStructureCategorizable, GrammaticalUnitComposable {
//        public typealias Language = English
//        public typealias StructureCategory = PhraseStructureCategory
//        public typealias Child = Word
//        
//        public var content: String
//        public var structure: StructureCategory
//        public var children: [Child]
//        
//        public init(content: String, structure: StructureCategory, children: [Child]) {
//            self.content = content
//            self.structure = structure
//            self.children = children
//        }
//    }
//    
//    public enum PhraseStructureCategory: GrammaticalStructureCategory {
//        /// A noun phrase consists of a noun and its modifiers.
//        /// It functions as a subject, object, or complement in a sentence.
//        ///
//        /// - Example: "the big red house"
//        case nounPhrase
//        
//        /// A verb phrase consists of a verb and its complements and modifiers.
//        /// It forms the predicate of a clause.
//        ///
//        /// - Example: "was quickly running"
//        case verbPhrase
//        
//        /// An adjective phrase consists of an adjective and its modifiers.
//        /// It modifies nouns or pronouns.
//        ///
//        /// - Example: "very happy"
//        case adjectivePhrase
//        
//        /// An adverb phrase consists of an adverb and its modifiers.
//        /// It modifies verbs, adjectives, or other adverbs.
//        ///
//        /// - Example: "quite slowly"
//        case adverbPhrase
//        
//        /// A prepositional phrase consists of a preposition and its object.
//        /// It functions as an adjective or adverb.
//        ///
//        /// - Example: "in the garden"
//        case prepositionalPhrase
//        
//        /// A gerund phrase consists of a gerund and its modifiers.
//        /// It functions as a noun.
//        ///
//        /// - Example: "reading books"
//        case gerundPhrase
//        
//        /// An infinitive phrase consists of an infinitive and its modifiers.
//        /// It can function as a noun, adjective, or adverb.
//        ///
//        /// - Example: "to win the race"
//        case infinitivePhrase
//        
//        /// A participial phrase consists of a participle and its modifiers.
//        /// It functions as an adjective.
//        ///
//        /// - Example: "running through the park"
//        case participialPhrase
//    }
//}
//
//// MARK: - Word
//
//extension English: WordStructured {
//    
//    public struct Word: SyntacticUnit, GrammaticalFunctionCategorizable, GrammaticalUnitComposable {
//        public typealias Language = English
//        public typealias FunctionCategory = WordFunctionCategory
//        public typealias Child = Morpheme
//        
//        public var content: String
//        public var function: FunctionCategory
//        public var children: [Child]
//        
//        public init(content: String, function: FunctionCategory, children: [Child]) {
//            self.content = content
//            self.function = function
//            self.children = children
//        }
//    }
//    
//    public enum WordFunctionCategory: GrammaticalFunctionCategory {
//        /// A noun names a person, place, thing, or idea.
//        /// Types include:
//        /// - Common nouns: general names (book, city)
//        /// - Proper nouns: specific names (John, London)
//        /// - Abstract nouns: ideas or concepts (love, freedom)
//        /// - Collective nouns: groups (team, family)
//        case noun(NounType)
//        
//        /// A pronoun substitutes for a noun.
//        /// Types include:
//        /// - Personal: I, you, he, she, it, we, they
//        /// - Possessive: my, your, his, her, its, our, their
//        /// - Relative: who, whom, whose, which, that
//        /// - Demonstrative: this, that, these, those
//        /// - Indefinite: anyone, everyone, someone, no one
//        case pronoun(PronounType)
//        
//        /// A verb expresses action or state of being.
//        /// Types include:
//        /// - Action verbs: run, jump, eat
//        /// - Linking verbs: be, seem, appear
//        /// - Helping verbs: have, do, be, can, may
//        case verb(VerbType)
//        
//        /// An adjective modifies nouns or pronouns.
//        /// Types include:
//        /// - Descriptive: beautiful, tall, red
//        /// - Demonstrative: this, that, these, those
//        /// - Possessive: my, your, his, her
//        /// - Numeric: one, first, second
//        case adjective(AdjectiveType)
//        
//        /// An adverb modifies verbs, adjectives, or other adverbs.
//        /// Types include:
//        /// - Manner: quickly, carefully
//        /// - Time: now, soon, never
//        /// - Place: here, there, everywhere
//        /// - Degree: very, quite, too
//        case adverb(AdverbType)
//        
//        /// A preposition shows relationships between nouns/pronouns and other words.
//        /// Examples: in, on, at, by, with, from, to
//        case preposition
//        
//        /// A conjunction connects words, phrases, or clauses.
//        /// Types include:
//        /// - Coordinating: and, but, or, nor, for, yet, so
//        /// - Subordinating: because, although, if, unless
//        /// - Correlative: either/or, neither/nor, both/and
//        case conjunction(ConjunctionType)
//        
//        /// An article is a type of adjective that indicates definiteness.
//        /// - Definite: the
//        /// - Indefinite: a, an
//        case article(ArticleType)
//        
//        /// An interjection expresses emotion or feeling.
//        /// Examples: oh, wow, ouch, hey
//        case interjection
//    }
//    
//    public enum NounType: GrammaticalFunctionCategory {
//        case common
//        case proper
//        case abstract
//        case collective
//        case countable
//        case uncountable
//    }
//    
//    public enum PronounType: GrammaticalFunctionCategory {
//        case personal
//        case possessive
//        case relative
//        case demonstrative
//        case indefinite
//        case reflexive
//        case interrogative
//    }
//    
//    public enum VerbType: GrammaticalFunctionCategory {
//        case action
//        case linking
//        case helping
//        case regular
//        case irregular
//    }
//    
//    public enum AdjectiveType: GrammaticalFunctionCategory {
//        case descriptive
//        case demonstrative
//        case possessive
//        case numeric
//        case quantitative
//    }
//    
//    public enum AdverbType: GrammaticalFunctionCategory {
//        case manner
//        case time
//        case place
//        case degree
//        case frequency
//    }
//    
//    public enum ConjunctionType: GrammaticalFunctionCategory {
//        case coordinating
//        case subordinating
//        case correlative
//    }
//    
//    public enum ArticleType: GrammaticalFunctionCategory {
//        case definite
//        case indefinite
//    }
//}
//
//// MARK: - Morpheme
//
//extension English: MorphemeStructured {
//    
//    public struct Morpheme: MorphologicalUnit, GrammaticalStructureCategorizable, GrammaticalFunctionCategorizable {
//        public typealias Language = English
//        
//        public var content: String
//        public var structure: MorphemeStructureCategory
//        public var function: MorphemeFunctionCategory
//    }
//    
//    public enum MorphemeStructureCategory: GrammaticalStructureCategory {
//        /// A free morpheme can stand alone as a word.
//        /// Examples: cat, run, happy
//        case free
//        
//        /// A bound morpheme must attach to another morpheme.
//        /// Examples: un-, -ing, -ed, -s
//        case bound
//    }
//    
//    public enum MorphemeFunctionCategory: GrammaticalFunctionCategory {
//        /// A root morpheme carries the core meaning of a word.
//        /// Examples: teach (in teacher), care (in careful)
//        case root
//        
//        /// A derivational morpheme creates a new word with a different meaning or part of speech.
//        /// Examples: -er (teacher), un- (unhappy), -ment (development)
//        case derivational
//        
//        /// An inflectional morpheme modifies a word's tense, number, or case without changing
//        /// its basic meaning or part of speech.
//        /// Examples: -s (plural), -ed (past tense), -ing (present participle)
//        case inflectional
//    }
//}
//
//// MARK: - Written Language
//
//extension English: WrittenLanguageProtocol {
//    public var scripts: [Script] {
//        [
//            Script(
//                name: "Latin",
//                code: Script.ISOCode(letterCode: "Latn", numericCode: 215),
//                category: .alphabetic,
//                directionality: .leftToRight,
//                hasCase: true
//            )
//        ]
//    }
//}
//
//// MARK: - Spoken Language
//
//extension English: SpokenLanguageProtocol {
//    public var hasTones: Bool {
//        false
//    }
//}
