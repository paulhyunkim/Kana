//
//  PartOfSpeech.swift
//  Kana
//
//  Created by Paul Kim on 10/11/24.
//

/// Enum that broadly categorizes parts of speech, providing coverage for most languages.
/// Each case represents a broad grammatical category used to classify words based on their function in a sentence.
enum PartOfSpeech {
    /// Captures both nouns and pronouns, which can function as the subject, direct object, or indirect object in a sentence.
    /// Example: "The **cat** is sleeping."
    /// Japanese word: 名詞, めいし, meishi
    case noun
    
    /// Represents the action in a sentence, including its root form and modifiers (conjugation, tense, meaning, politeness).
    /// Example: "She **runs** every morning."
    /// Japanese word: 動詞, どうし, doushi
    case verb
    
    /// Describes or modifies nouns.
    /// Example: "The **blue** sky is clear."
    /// Japanese word: 形容詞, けいようし, keiyoushi (i-adjectives), 形容動詞, けいようどうし, keiyoudoushi (na-adjectives)
    case adjective
    
    /// Modifies verbs, adjectives, or other adverbs, describing the manner, degree, frequency, or time of an action.
    /// Example: "He ran **quickly**."
    /// Japanese word: 副詞, ふくし, fukushi
    case adverb
    
    /// Connects words, phrases, or clauses to form more complex sentences.
    /// Example: "I like coffee **and** tea."
    /// Japanese word: 接続詞, せつぞくし, setsuzokushi
    case conjunction
    
    /// Captures exclamations or fillers, expressing emotions, reactions, or pauses.
    /// Example: "**Wow**, that's amazing!"
    /// Japanese word: 感動詞, かんどうし, kandoushi
    case interjection
    
    /// Captures words like articles, possessives, and quantifiers, providing context about a noun’s specificity, quantity, or possession.
    /// Example: "**The** book is on the table."
    /// Japanese word: 限定詞, げんていし, genteishi
    case determiners
    
    /// Language-specific part of speech: captures elements specific to a particular language that do not fit into broader categories.
    case languageSpecific(LanguageSpecificPartOfSpeech)
    
    /// A generic case to capture non-standard, undefined, or miscellaneous categories.
    /// This allows for flexibility in adding new or rare parts of speech that don't fit elsewhere.
    case other(String)
    
    
    case something
    
    
    /// sdfsd
    /// 
    func some() {
        
    }
}

/// Protocol that defines language-specific parts of speech.
/// This protocol allows for the extension of `PartOfSpeech` to support specific language elements.
protocol LanguageSpecificPartOfSpeech {}

enum EnglishSpecificPartOfSpeech: LanguageSpecificPartOfSpeech {
    /// Preposition: a word that shows the relationship between a noun (or pronoun) and another element in the sentence.
    /// Example: "The book is **on** the table."
    /// Japanese word: 前置詞, ぜんちし, zenchishi
    case preposition
}

enum JapaneseSpecificPartOfSpeech: LanguageSpecificPartOfSpeech {
    /// Particle: a function word that indicates the grammatical relationship between parts of the sentence.
    /// Example: "わたし**は**学生です。" (I am a student.)
    /// Japanese word: 助詞, じょし, joshi
    case particle
}

/*
enum JapanesePartOfSpeech {
    case noun                // 名詞 (meishi)
    case verb(VerbType)      // 動詞 (doushi)
    case adjective(AdjectiveType)
    case adverb              // 副詞 (fukushi)
    case particle            // 助詞 (joshi)
    case conjunction         // 接続詞 (setsuzokushi)
    case interjection        // 感動詞 (kandoushi)
    case prenominalAdjective // 連体詞 (rentaishi)
    case auxiliaryVerb       // 助動詞 (jodoushi)
    case other(String)       // For cases that don't fit other categories

    enum VerbType {
        case u         // 五段動詞 (godan)
        case ru        // 一段動詞 (ichidan)
        case irregular // 不規則動詞 (fukisoku doushi)
    }

    enum AdjectiveType {
        case i  // 形容詞 (keiyoushi)
        case na // 形容動詞 (keiyoudoushi)
    }
    
//    enum ParticleType {
//        // Case particles (格助詞 kaku-joshi)
//        case topic           // は (wa)
//        case subject         // が (ga)
//        case object   // を (wo)
//        case direction // に/へ (ni/he)
//        case possessive      // の (no)
////        case direction       // へ (e)
//        case location        // で (de)
//        case from            // から (kara)
//        case to              // まで (made)
//
//        // Binding particles (係助詞 kakari-joshi)
//        case emphasis        // も (mo)
//        case inclusive       // と (to)
//        case alternative     // や (ya)
//
//        // Sentence-ending particles (終助詞 shuu-joshi)
//        case question        // か (ka)
//        case emphatic        // よ (yo)
//        case confirmative    // ね (ne)
//
//        // Conjunctive particles (接続助詞 setsuzoku-joshi)
//        case te_form         // て/で (te/de)
//        case conditional     // ば (ba)
//
//        // Adverbial particles (副助詞 fuku-joshi)
//        case only            // だけ (dake)
//        case about           // くらい/ぐらい (kurai/gurai)
//
//        // This list is not exhaustive and can be expanded further
//        case other(String)
//    }
}

enum EnglishPartOfSpeech {
    
    case noun
//    case pronoun
    case verb
    case adjective
    case adverb
    case preposition
    case conjunction
    case interjection
    case determiners
    case other(String)
    
}

*/
