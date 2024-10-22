//
//  ColorSystem.swift
//  Kana
//
//  Created by Paul Kim on 10/11/24.
//

//import Foundation
//import RealmSwift
//
////https://uxdesign.cc/guide-on-creating-ui-design-for-ios-apps-5bed644b1667
//
//class ColorSystem: Object, ObjectKeyIdentifiable {
//    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted(indexed: true) var name: String
//    @Persisted var createdAt: Date = Date()
//
//    @Persisted var accent: AccentColorGroup?
//    @Persisted var label: LabelColorGroup?
//    @Persisted var background: BackgroundColorGroup?
//    @Persisted var fill: FillColorGroup?
//    @Persisted var feedback: FeedbackColorGroup?
//    
//    @Persisted var separator: ColorSet?
////    @Persisted var border: ColorSet
//}
//
///// Accent colors are best for:
///// - Selection controls, like sliders and switches
///// - Highlighting selected text
///// - Progress bars
///// - Links and headlines
//class AccentColorGroup: EmbeddedObject, ObjectKeyIdentifiable {
//    @Persisted var primary: ColorSet?
//    @Persisted var secondary: ColorSet?
//}
//
///// Colors to differentiate grouping content and elements.
//class BackgroundColorGroup: EmbeddedObject, ObjectKeyIdentifiable {
//    /// For the overall view, the main background of your app.
//    @Persisted var primary: ColorSet?
//    /// For grouping content or elements within the overall view.
//    @Persisted var secondary: ColorSet?
//    /// For grouping content or elements within secondary elements.
//    @Persisted var tertiary: ColorSet?
//}
//
//class LabelColorGroup: EmbeddedObject, ObjectKeyIdentifiable {
//    /// For highlighting important text or content that needs to be displayed prominently to the user.
//    /// For example, you can use primary color for titles and headlines, labels of the pages in the navigation bars, field labels,
//    /// or input control in forms.
//    @Persisted var primary: ColorSet?
//    /// For displaying captions or supporting information.
//    /// A secondary label can be used in forms and input fields to provide additional context or instructions for fields or
//    /// input controls, and in lists or tables to display secondary information and details about a list or table items.
//    @Persisted var secondary: ColorSet?
//    /// For displaying even less important text or content, such as supplementary information or details
//    /// that are not essential to the user’s understanding of the app.
//    @Persisted var tertiary: ColorSet?
//}
//
///// Fill colors are used for UI elements, that allow the background color to show through.
///// The fill colors share the same color value, but with varying levels of opacity for each color variant.
//class FillColorGroup: EmbeddedObject, ObjectKeyIdentifiable {
//    /// For thin and small shapes, such as slider's track.
//    @Persisted var primary: ColorSet?
//    /// For medium-size shapes, such as the background of a switch.
//    @Persisted var secondary: ColorSet?
//    /// For large shapes, such as input fields, search bars, or buttons.
////    @Persisted var tertiary: ColorSet
//}
//
////class ActionColorGroup: EmbeddedObject, ObjectKeyIdentifiable {
////    @Persisted var primary: ColorSet
////    @Persisted var secondary: ColorSet
////    @Persisted var destructive: ColorSet
////}
//
//class FeedbackColorGroup: EmbeddedObject, ObjectKeyIdentifiable {
//    @Persisted var success: ColorSet?
//    @Persisted var warning: ColorSet?
//    @Persisted var error: ColorSet?
//}
//
////class SeparatorColorGroup: EmbeddedObject, ObjectKeyIdentifiable {
////    @Persisted var translucent: ColorSet
////    @Persisted var opaque: ColorSet
////}
//
//class ColorSet: EmbeddedObject, ObjectKeyIdentifiable {
//    @Persisted var lightHex: String
//    @Persisted var darkHex: String?
//}
//
