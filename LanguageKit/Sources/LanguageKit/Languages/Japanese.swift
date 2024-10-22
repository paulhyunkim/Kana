//
//  Japanese.swift
//  LanguageKit
//
//  Created by Paul Kim on 10/20/24.
//

import Foundation

public struct Japanese: Language {
    
    public var name: String = "Japanese"
    public var code: String = "ja"
    
    public var wordOrder: WordOrder = .SOV
    public var hasGrammaticalGender: Bool = false
    
}


// MARK: - Sentence

extension Japanese: SentenceStructured {
    
    public struct Sentence: SyntacticUnit, GrammaticalStructureCategorizable, GrammaticalFunctionCategorizable, GrammaticalUnitComposable {
        public typealias StructureCategory = SentenceStructureCategory
        public typealias FunctionCategory = SentenceFunctionCategory
        
        public static let childTypes: [GrammaticalUnit.Type] = [Clause.self]
        
        public var content: String
        
        public var structure: StructureCategory
        public var function: FunctionCategory
        
        public init(content: String, structure: StructureCategory, function: FunctionCategory) {
            self.content = content
            self.structure = structure
            self.function = function
        }
    }
    
    // TODO: - review list of sentence structure categories
    public enum SentenceStructureCategory: GrammaticalStructureCategory {
        /// A simple sentence (単文 tanbun) consists of a single independent clause with one subject and one predicate.
        /// It expresses a complete thought in its most basic form.
        ///
        /// - Example: 猫が寝ている。(Neko ga nete iru.): The cat is sleeping.
        case simple
        
        /// A compound sentence (複文 fukubun) consists of two or more independent clauses joined by conjunctions or punctuation.
        /// Each clause can stand alone as a complete thought.
        ///
        /// - Example: 雨が降っているが、私は出かける。(Ame ga futte iru ga, watashi wa dekakeru.): It's raining, but I'm going out.
        case compound
        
        /// A complex sentence (重文 jūbun) contains one independent clause and one or more dependent clauses.
        /// The dependent clauses provide additional information but cannot stand alone.
        ///
        /// - Example: 彼が来たとき、私は本を読んでいた。(Kare ga kita toki, watashi wa hon o yonde ita.): When he came, I was reading a book.
        case complex
        
        case compoundComplex
        
    }
    
    // TODO: - review list of sentence function categories
    public enum SentenceFunctionCategory: GrammaticalFunctionCategory {
        /// A declarative sentence (平叙文 heijobun) makes a statement or expresses an opinion. It's the most common type of sentence.
        ///
        /// - Example: 東京は日本の首都です。(Tōkyō wa Nihon no shuto desu.): Tokyo is the capital of Japan.
        case declarative
        
        /// An interrogative sentence (疑問文 gimonbun) asks a question and typically ends with a question mark or the particle か (ka).
        ///
        /// - Example: あなたは日本語が話せますか？(Anata wa nihongo ga hanasemasu ka?): Can you speak Japanese?
        case imperative
        
        
        case interrogative
        
        /// An imperative sentence (命令文 meireibun) gives a command or makes a request. It often uses the imperative form of verbs.
        ///
        /// - Example: ドアを閉めてください。(Doa o shimete kudasai.): Please close the door.
//        case imperative
        
        /// An exclamatory sentence (感嘆文 kantanbun) expresses strong emotion or sudden feeling. It often ends with an exclamation mark.
        ///
        /// - Example: なんて美しい景色だ！(Nante utsukushii keshiki da!): What a beautiful view!
        case exclamatory
        
    }
    
}


// MARK: - Clause
    
extension Japanese: ClauseStructured {

    public struct Clause: SyntacticUnit, GrammaticalStructureCategorizable, GrammaticalFunctionCategorizable, GrammaticalUnitComposable {
        
        public typealias StructureCategory = ClauseStructureCategory
        public typealias FunctionCategory = ClauseFunctionCategory
//        typealias ChildGrammaticalUnit = Clause
        public static let childTypes: [GrammaticalUnit.Type] = [Phrase.self]
        
        public var content: String
//        public var children: [Phrase]
        
        public var structure: StructureCategory
        public var function: FunctionCategory
        
        public init(content: String, structure: StructureCategory, function: FunctionCategory) {
            self.content = content
            self.structure = structure
            self.function = function
        }
    }
    
    // TODO: - review list of clause structure categories
    public enum ClauseStructureCategory: GrammaticalStructureCategory {
        /// A main clause (主節 shusetsu) is an independent clause that can stand alone as a complete sentence.
        /// It contains the main subject and predicate of a sentence.
        ///
        /// - Example: 私は学校に行く (Watashi wa gakkō ni iku): I go to school.
        case main
        
        /// A subordinate clause (従属節 jūzokusetsu) is a dependent clause that cannot stand alone as a complete sentence.
        /// It provides additional information to the main clause.
        ///
        /// - Example: 雨が降っているので (Ame ga futte iru node): Because it's raining...
        case subordinate
        
        /// A relative clause (関係節 kanketsusetsu) is a type of subordinate clause that modifies a noun in the main clause.
        /// In Japanese, it typically precedes the noun it modifies.
        ///
        /// - Example: 私が買った本 (Watashi ga katta hon): The book that I bought
        case relative
        
        /// A nominal clause (名詞節 meishisetsu) is a subordinate clause that functions as a noun in a sentence.
        /// It can serve as the subject, object, or complement of the main clause.
        ///
        /// - Example: 彼が来ることを知っている (Kare ga kuru koto o shitte iru): I know that he is coming.
        case nominal
        
        /// An adverbial clause (副詞節 fukushisetsu) is a subordinate clause that functions as an adverb,
        /// modifying the verb, adjective, or other adverb in the main clause.
        ///
        /// - Example: 雨が降っているのに (Ame ga futte iru noni): Although it's raining...
        case adverbial
        
        /// A conditional clause (条件節 jōkensetsu) is a type of subordinate clause that expresses a condition.
        /// It typically uses conditional forms like ば、たら、なら、と to indicate "if" or "when" scenarios.
        ///
        /// - Example: 晴れたら (Haretara): If it's sunny...
        case conditional
    }
    
    // TODO: - review list of clause function categories
    public enum ClauseFunctionCategory: GrammaticalFunctionCategory {
        // will implement
    }
}


// MARK: - Phrase

extension Japanese: PhraseStructured {
    
    public struct Phrase: SyntacticUnit, GrammaticalStructureCategorizable {
        public typealias StructureCategory = PhraseStructureCategory
        
//        typealias ChildGrammaticalUnit = Word
        public static let childTypes: [GrammaticalUnit.Type] = [Word.self, Particle.self]
        
        public var content: String
        public var structure: StructureCategory
        
        public init(content: String, structure: StructureCategory) {
            self.content = content
            self.structure = structure
        }
    }
    
    public enum PhraseStructureCategory: GrammaticalStructureCategory {
        
        /// A noun phrase (名詞句 meishiku) is a group of words that function as a noun in a sentence.
        /// It typically consists of a noun and its modifiers.
        ///
        /// - Example: 美しい花 (Utsukushii hana): Beautiful flower
        case nounPhrase
        
        /// A verb phrase (動詞句 dōshiku) is a phrase built around a verb, including the verb and its objects,
        /// complements, and modifiers. In Japanese, it often includes particles and can encompass a significant
        /// portion of the sentence due to the SOV word order.
        ///
        /// - Example: 本を読んでいる (Hon o yonde iru): Reading a book
        case verbPhrase
        
        /// An adjective phrase (形容詞句 keiyōshiku) is a phrase that functions as an adjective, modifying a noun.
        /// In Japanese, this can include い-adjectives, な-adjectives, and their modifiers.
        ///
        /// - Example: とても大きい (Totemo ōkii): Very big
        case adjectivePhrase
        
        /// An adverb phrase (副詞句 fukushiku) is a phrase that functions as an adverb, modifying a verb,
        /// adjective, or another adverb. It can express manner, time, place, degree, or other adverbial concepts.
        ///
        /// - Example: かなり速く (Kanari hayaku): Quite quickly
        case adverbPhrase
        
        /// A particle phrase (助詞句 joshiku) is a phrase centered around a particle, which plays a crucial role
        /// in Japanese grammar. It often includes the particle and the word or phrase it's attached to,
        /// indicating grammatical relationships or nuances.
        ///
        /// - Example: 東京へ (Tōkyō e): To Tokyo
        case particlePhrase
    }
    
}

// MARK: - Word

extension Japanese: WordStructured {
    
    public struct Word: SyntacticUnit, GrammaticalFunctionCategorizable {
        public typealias FunctionCategory = WordFunctionCategory
//        typealias ChildGrammaticalUnit = Morpheme
        
        public var content: String
        public var function: FunctionCategory
        
        public init(content: String, function: FunctionCategory) {
            self.content = content
            self.function = function
        }
    }
    
    public enum WordFunctionCategory: GrammaticalFunctionCategory {
        
        /// A noun (名詞 meishi) is a word that represents a person, place, thing, or idea. In Japanese, nouns do not
        /// have grammatical gender or number, and can often function as other parts of speech when combined with particles.
        ///
        /// - Example: 猫 (neko): cat
        ///     - 猫が好きです。(neko ga suki desu.): I like cats.
        ///     - 私の猫 (watashi no neko): my cat
        case noun
        
        /// A verb (動詞 dōshi) is a word that expresses an action, occurrence, or state of being. Japanese verbs are characterized
        /// by their rich conjugation system and their position at the end of the sentence.
        ///
        /// - Example: 食べる (taberu): to eat
        ///     - りんごを食べます。(ringo wo tabemasu.): I eat an apple.
        ///     - 食べない (tabenai): do not eat
        case verb
        
        /// An adjectival verb (or i-Adjective) (形容詞 keiyōshi) can be considered specialized verbs, in that they inflect for various
        /// aspects such as past tense or negation, and they can be used predicatively to end a sentence, without the need for
        /// any other "to be" verb.
        ///
        /// - Example: 暑い (atsui): hot
        ///     - 暑い日 (atsui hi): a hot day
        ///     - 今日は暑い。(kyō wa atsui.): Today is hot.
        case adjectivalVerb
        
        /// An adjectival noun (or na-Adjective) (形容動詞 keiyō-dōshi) can be considered a form of noun in terms of syntax. These
        /// attach to the copula, which then inflects, but use 〜な (-na) (rather than the genitive 〜の) when modifying a noun.
        ///
        /// - Example: 変 (hen): strange
        ///     - 変な人 (hen-na hito): a strange person
        ///     - 彼は変だ。(kare wa hen da.): He is strange.
        case adjectivalNoun
        
        /// An adverb (副詞 fukushi) is a word that modifies verbs, adjectives, or other adverbs. In Japanese, some adverbs are
        /// derived from adjectives, while others are independent words.
        ///
        /// - Example: とても (totemo): very
        ///     - とても寒い (totemo samui): very cold
        ///     - 彼女はとても速く走る。(kanojo wa totemo hayaku hashiru.): She runs very fast.
        case adverb
        
        /// A prenominal adjective (連体詞 rentaishi) is a word that directly modifies nouns without requiring any particles or
        /// inflection. Unlike other adjectives, they have only one form and cannot be used predicatively.
        ///
        /// - Example: この (kono): this
        ///     - この本 (kono hon): this book
        ///     - あの人 (ano hito): that person
        case prenominalAdjective
        
        /// A conjunction (接続詞 setsuzokushi) is a word used to connect words, phrases, or clauses. In Japanese, conjunctions
        /// often appear at the beginning of a sentence to link it to the previous one.
        ///
        /// - Example: しかし (shikashi): however
        ///     - 雨が降っています。しかし、出かけます。(Ame ga futte imasu. Shikashi, dekakemasu.): It's raining. However, I'm going out.
        case conjunction
        
        /// An interjection (感動詞 kandōshi) is a word used to express strong emotion or sudden feeling. It can stand alone as
        /// a complete utterance and is often used in casual speech.
        ///
        /// - Example: わあ (waa): wow
        ///     - わあ、きれい！(Waa, kirei!): Wow, beautiful!
        case interjection
        
        /// A particle (助詞 joshi) is a word that follows other words to indicate their grammatical function, relationship to other
        /// words, or to add particular meanings. Particles are crucial in Japanese grammar and can change the meaning or
        /// nuance of a sentence.
        ///
        /// - Example: は (wa): topic marker
        ///     - 私は学生です。(Watashi wa gakusei desu.): I am a student.
        case particle(Particle)
        
        /// An auxiliary verb (助動詞 jodōshi) is a verb that adds functional or grammatical meaning to the main verb in a clause.
        /// In Japanese, auxiliary verbs often express aspect, voice, or mood.
        ///
        /// - Example: ます (masu): polite form auxiliary
        ///     - 食べます (tabemasu): eat (polite form)
        ///     - 行きました (ikimashita): went (polite past form)
        case auxilaryVerb
    }
}


// MARK: - Particle

extension Japanese: ParticleUsing {
    
    public struct Particle: SyntacticUnit, GrammaticalFunctionCategorizable {
        
        public var content: String
        public var function: FunctionCategory
        
        public enum FunctionCategory: GrammaticalFunctionCategory {
            /// Case-marking particles (格助詞, kaku-joshi) attach to nouns and noun phrases to indicate their grammatical function
            /// within a sentence.
            ///
            /// - Function:
            ///     - Marking grammatical cases (e.g., subject, object)
            ///     - Specifying semantic roles (e.g., agent, recipient, location)
            ///     - Establishing syntactic structure
            ///
            /// - Examples:
            ///     - が (ga): Subject marker
            ///     - を (wo/o): Direct object marker
            ///     - に (ni): Indirect object, direction, or time marker
            ///     - の (no): Possession or association marker
            ///     - へ (e): Direction indicator
            ///     - で (de): Location of action or means
            ///     - から (kara): Starting point in time or space
            ///     - まで (made): End point in time or space
            ///     - より (yori): Used in comparisons ("than" or "from")
            case caseMarking
            
            /// Listing (or parallelizing) particles (並立助詞, heiritsu-joshi) join words, phrases, or clauses of equal status.
            ///
            /// - Function:
            ///     - Connecting items in lists
            ///     - Showing alternatives
            ///     - Giving examples
            ///
            /// - Examples:
            ///     - と (to): Connects items in an exhaustive list
            ///     - か (ka): Shows alternatives or uncertainty
            ///     - や (ya): Connects items in a non-exhaustive list, implying "and so on"
            ///     - とか (toka): Gives examples in a non-exhaustive list (colloquial)
            ///     - なり (nari): Similar to とか, but more emphatic and often used in pairs
            case listing
            
            /// Sentence-ending particles (終助詞, shū-joshi) express the speaker's attitude or emotion at the end of a sentence.
            ///
            /// - Function:
            ///     - Indicating questions or uncertainty
            ///     - Seeking agreement or confirmation
            ///     - Adding emphasis or conveying new information
            ///     - Softening statements or adding explanatory nuance
            ///
            /// - Examples:
            ///     - か (ka): Indicates a question or uncertainty
            ///     - ね (ne): Seeks agreement or confirmation
            ///     - よ (yo): Adds emphasis or conveys new information
            ///     - の (no): Softens a sentence or adds explanatory nuance (often in casual speech)
            case sentenceEnding
            
            /// Interjecting particles (間投助詞, kantō-joshi) are inserted mid-sentence to express the speaker's attitude or to manage
            /// the flow of conversation.
            ///
            /// - Function:
            ///     - Seeking agreement or confirmation
            ///     - Drawing attention to what's being said
            ///     - Expressing emotion or maintaining conversational rhythm
            ///
            /// - Examples:
            ///     - ね (ne): Seeks agreement or confirmation mid-sentence
            ///     - よ (yo): Draws attention to what's being said
            ///     - な (na): Expresses emotion or seeks agreement (casual)
            ///     - さ (sa): Emphasizes a point or maintains rhythm in speech
            case interjecting
            
            /// Focusing (or adverbial) particles (副助詞, fuku-joshi) modify the meaning of words or phrases.
            ///
            /// - Function:
            ///     - Expressing exclusivity or limitation
            ///     - Indicating extent or degree
            ///     - Showing approximation
            ///     - Giving examples or categories
            ///
            /// - Examples:
            ///     - だけ (dake): Indicates exclusivity ("only", "just")
            ///     - しか (shika): Used with negatives ("nothing but", "only")
            ///     - ばかり (bakari): Indicates exclusivity or excess
            ///     - まで (made): Indicates extent ("even", "as far as")
            ///     - くらい/ぐらい (kurai/gurai): Indicates approximation or degree
            ///     - など (nado): Indicates examples ("et cetera", "and so on")
            ///     - さえ (sae): Indicates extremity ("even", "if only")
            ///     - すら (sura): Similar to さえ but stronger
            ///     - ほど (hodo): Indicates degree ("to the extent that", "as...as")
            case focusing
            
            /// Binding particles (係助詞, kakari-joshi) relate words or phrases to other parts of the sentence.
            ///
            /// - Function:
            ///     - Marking the topic of a sentence
            ///     - Indicating inclusion or contrast
            ///     - Adding emphasis or expressing surprise
            ///
            /// - Examples:
            ///     - は (wa): Marks the topic of a sentence
            ///     - も (mo): Indicates inclusion or addition ("also", "too")
            ///     - でも (demo): Expresses "even" or "or something like"
            ///     - こそ (koso): Adds strong emphasis ("precisely", "indeed")
            ///     - なんて (nante): Expresses emphasis or surprise, often with a negative nuance
            ///     - なんか (nanka): Colloquial version of など ("like", "sort of")
            ///     - など (nado): Indicates examples ("and so on", "etc.")
            case binding
            
            /// Connecting (or conjunctive) particles (接続助詞, setsuzoku-joshi) connect clauses or sentences.
            ///
            /// - Function:
            ///     - Expressing sequence of actions
            ///     - Indicating simultaneous actions
            ///     - Showing conditions
            ///     - Giving reasons or causes
            ///     - Expressing contradictions or contrasts
            ///
            /// - Examples:
            ///     - て/で (te/de): Connects actions or states
            ///     - ながら (nagara): Expresses simultaneous actions
            ///     - たり (tari): Lists representative actions or states
            ///     - ば (ba): Expresses conditional "if" or "when"
            ///     - たら (tara): Another conditional form, often for completed actions
            ///     - なら (nara): Conditional "if", often for suppositions
            ///     - のに (noni): Expresses contradiction ("although", "despite")
            ///     - ので (node): Gives a reason (formal "because", "since")
            ///     - から (kara): Gives a reason ("because", "since")
            ///     - けど/が (kedo/ga): Expresses contradiction or contrast ("but", "although")
            ///     - し (shi): Used to list reasons or qualities
            case connecting
            
            /// Nominalizing (or phrasal) particles (準体助詞, juntai-joshi) turn phrases into noun-like entities.
            ///
            /// - Function:
            ///     - Transforming verbs or adjectives into noun-like structures
            ///     - Creating embedded clauses
            ///
            /// - Examples:
            ///     - の (no): Nominalizes verbs or adjectives
            ///     - ん (n): Colloquial version of の, used in informal speech
            case nominalizing
        }
    
    }
    
}


// MARK: - Morpheme

extension Japanese: MorphemeStructured {

    public struct Morpheme: MorphologicalUnit, GrammaticalStructureCategorizable, GrammaticalFunctionCategorizable {
        public var content: String
        public var structure: MorphemeStructureCategory
        public var function: MorphemeFunctionCategory
        
    }
    
    public enum MorphemeStructureCategory: GrammaticalStructureCategory {
        // will implement
    }
    public enum MorphemeFunctionCategory: GrammaticalFunctionCategory {
        // will implement
    }
    
}


extension Japanese: WrittenLanguageProtocol {
    
    public var scripts: [Script] {
        [
            Script(name: "Hiragana", code: Script.ISOCode(letterCode: "Hira", numericCode: 410), category: .syllabic, directionality: .mixed([.leftToRight, .verticalRightToLeft]), hasCase: false),
            Script(name: "Hiragana", code: Script.ISOCode(letterCode: "Kana", numericCode: 411), category: .syllabic, directionality: .mixed([.leftToRight, .verticalRightToLeft]), hasCase: false),
            Script(name: "Kanji", code: Script.ISOCode(letterCode: "Hani", numericCode: 500), category: .syllabic, directionality: .mixed([.leftToRight, .verticalRightToLeft]), hasCase: false),
        ]
    }
    
}

extension Japanese: SpokenLanguageProtocol {
    
    public var hasTones: Bool {
        false
    }
    
}
