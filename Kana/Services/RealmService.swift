//
//  RealmService.swift
//  Kana
//
//  Created by Paul Kim on 10/12/24.
//

import Foundation
//import RealmSwift
//
//struct RealmAppConfig {
//    var appId: String
//    var baseUrl: String
//    var atlasUrl: String?
//}
//
//actor RealmService {
//    
//    let app: App
//    var config: Realm.Configuration?
//    
//    init() {
//        // Read the atlasConfig.plist file and store the app ID and baseUrl to use elsewhere.
//        guard let path = Bundle.main.path(forResource: "AtlasConfig", ofType: "plist") else {
//            fatalError("Could not load atlasConfig.plist file!")
//        }
//        // Any errors here indicate that the atlasConfig.plist file has not been formatted properly.
//        // Expected key/values:
//        //      "appId": "your App Services app ID"
//        let data = NSData(contentsOfFile: path)! as Data
//        let atlasConfigPropertyList = try! PropertyListSerialization.propertyList(from: data, format: nil) as! [String: Any]
//        let appId = atlasConfigPropertyList["appId"]! as! String
//        let baseUrl = atlasConfigPropertyList["baseUrl"]! as! String
//        
//        var config: RealmAppConfig
//        
//        // If you're getting this app code by cloning the repository at
//        // https://github.com/mongodb/template-app-swiftui-todo
//        // it does not contain the data explorer link. Download the
//        // app template from the Atlas UI to view a link to your data.
//        let atlasUrl = atlasConfigPropertyList["dataExplorerLink"]
//        if let atlasUrl = atlasUrl {
//            config = RealmAppConfig(appId: appId, baseUrl: baseUrl, atlasUrl: atlasUrl as? String)
//        } else {
//            config = RealmAppConfig(appId: appId, baseUrl: baseUrl, atlasUrl: nil)
//        }
//        
//        app = App(id: config.appId, configuration: AppConfiguration(baseURL: config.baseUrl, transport: nil))
//        
//        Task {
//            let user = try await login()
//            await openSyncedRealm(user: user)
//        }
//    }
//
//    func login() async throws -> RealmSwift.User {
//        // Authenticate with the instance of the app that points
//        // to your backend. Here, we're using anonymous login.
//        let user = try await app.login(credentials: .anonymous)
//        print("Successfully logged in user: \(user)")
//        return user
//    }
//    
////    @MainActor
//    func openSyncedRealm(user: RealmSwift.User) async {
//        var config = user.flexibleSyncConfiguration { subscriptions in
////            subscriptions.removeAll()
//            
//            if subscriptions.first(named: AppConfig.queryName) == nil {
//                subscriptions.append(AppConfig.subscriptionForAll())
//            }
//            if subscriptions.first(named: Language.queryName) == nil {
//                subscriptions.append(Language.subscriptionForAll())
//            }
//            if subscriptions.first(named: Script.queryName) == nil {
//                subscriptions.append(Script.subscriptionForAll())
//            }
//            if subscriptions.first(named: ConversationTemplate.queryName) == nil {
//                subscriptions.append(ConversationTemplate.subscriptionForAll())
//            }
//            if subscriptions.first(named: ConversationTemplateGroup.queryName) == nil {
//                subscriptions.append(ConversationTemplateGroup.subscriptionForAll())
//            }
//            if subscriptions.first(named: ColorSystem.queryName) == nil {
//                subscriptions.append(ColorSystem.subscriptionForAll())
//            }
//            if subscriptions.first(named: TranslationItem.queryName) == nil {
//                subscriptions.append(TranslationItem.subscriptionForAll())
//            }
//        }
//        
//        config.objectTypes = [
//            Language.self,
//            Script.self,
//            SpeechStyle.self,
//            ConversationTemplate.self,
//            AppConfig.self,
//            ConversationTemplateGroup.self,
//            ColorSystem.self,
//            ColorSet.self,
//            ChatMessage.self,
//            TemplateSegment.self,
//            TranslationItem.self,
//            Vocabulary.self,
//            AccentColorGroup.self,
//            BackgroundColorGroup.self,
//            LabelColorGroup.self,
//            FillColorGroup.self,
//            FeedbackColorGroup.self,
//        ]
//        
//        self.config = config
//    }
//    
//}
