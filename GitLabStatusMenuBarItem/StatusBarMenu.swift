//
//  StatusBarMenu.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct StatusBarMenu: View {
    
    @EnvironmentObject var store: GitLabDataStore
    
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                MergeRequestsListView()
                    .tabItem {
                        Text("Merge Requests")
                        Image(systemName: "list.bullet")
                    }
                    .tag(0)
                
                PipelinesListView()
                    .tabItem {
                        Text("Pipelines")
                        Image(systemName: "square.and.pencil")
                    }
                    .tag(1)
            }
        }
        .padding()
    }
}

struct StatusBarMenu_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarMenu()
            .environmentObject(GitLabDataStore.exampleStore)
    }
}
