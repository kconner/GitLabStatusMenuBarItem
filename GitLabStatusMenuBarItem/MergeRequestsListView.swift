//
//  MergeRequestsListView.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct MergeRequestsListView: View {
    @EnvironmentObject var store: GitLabDataStore
    
    var body: some View {
        List {
            if let projects = store.gitLabData {
                ForEach(projects) { project in
                    Section(header: Text(project.fullPath)) {
                        ForEach(project.mergeRequests.nodes) { mergeRequest in
                            MergeRequestRow(mergeRequest: mergeRequest)
                        }
                    }
                }
            }
        }
    }
}

struct MergeRequestsListView_Previews: PreviewProvider {
    static var previews: some View {
        MergeRequestsListView()
            .environmentObject(GitLabDataStore.exampleStore)
    }
}
