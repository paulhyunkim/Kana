//
//  ContentView.swift
//  Kana
//
//  Created by Paul Kim on 10/10/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        NavigationSplitView {
            Text("sidebar")
        } content: {
            Text("content")
        } detail: {
            Text("detail")
        }

//#if os(macOS)
//        NavigationSplitView {
//            List {
//                
//            }
//            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
//            .toolbar {
//                //                ToolbarItem {
//                //                    Button(action: addItem) {
//                //                        Label("Add Item", systemImage: "plus")
//                //                    }
//                //                }
//            }
//        } detail: {
//            ContentTabView()
//        }
//#else
//        ContentTabView()
//#endif
    }
}

struct ContentTabView: View {
    
    enum TabSelection: Identifiable {
        var id: Self { self }
        case translate
        case check
        case test
        case converse
        case review
        //        case settings
    }
    
    @State private var selectedTab: TabSelection = .translate
    
    var body: some View {

        TabView(selection: $selectedTab) {
            Tab("Translate", systemImage: "play.circle", value: .translate) {
//                Text("Translate")
                NavigationSplitView {
                    Text("sidebar")
                } content: {
                    Text("content")
                } detail: {
                    Text("detail")
                }
            }
            
            Tab("Check", systemImage: "dot.radiowaves.left.and.right", value: .check) {
//                Text("Check")
                NavigationSplitView {
                    Text("sidebar")
                } content: {
                    Text("content")
                } detail: {
                    Text("detail")
                }
            }
            
            
            Tab("Test", systemImage: "magnifyingglass", value: .test) {
//                Text("Test")
                NavigationSplitView {
                    Text("sidebar")
                } content: {
                    Text("content")
                } detail: {
                    Text("detail")
                }
            }
            
            
        }
    }
    
}

#Preview {
    ContentView()
}
