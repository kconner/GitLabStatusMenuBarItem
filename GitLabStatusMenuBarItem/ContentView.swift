//
//  ContentView.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: GitLabDataStore
    
    var body: some View {
        StatusBarMenu()
            .toolbar {
                Button("Refresh") {
                    store.refreshData()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
