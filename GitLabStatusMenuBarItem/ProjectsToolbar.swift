//
//  ProjectsToolbar.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct ProjectsToolbar: View {
    @Binding var selectedTab: ProjectsView.Tab
    @EnvironmentObject var store: ProjectStore
    @State private var showingTokenSheet = false
    
    var body: some View {
        HStack {
            Picker(selection: $selectedTab) {
                Text("Merge Requests")
                    .tag(ProjectsView.Tab.mergeRequests)
                
                Text("Pipelines")
                    .tag(ProjectsView.Tab.pipelines)
            } label: {}
            .pickerStyle(.segmented)
            .fixedSize()
            
            Spacer()
            
            Menu {
                Button("Set GitLab Token") {
                    showingTokenSheet = true
                }
                Button("Quit") {
                    NSApp.terminate(nil)
                }
            } label: {
                if store.isLoading {
                    Image(systemName: "ellipsis")
                } else {
                    Image(systemName: "arrow.clockwise")
                }
            } primaryAction: {
                store.refreshData()
            }
            .fixedSize()
        }
        .sheet(isPresented: $showingTokenSheet) {
            TokenSheet()
        }
    }
}

struct ProjectsToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsToolbar(selectedTab: .constant(.mergeRequests))
            .environmentObject(ProjectStore())
    }
}
