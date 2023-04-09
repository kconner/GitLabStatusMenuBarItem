//
//  ProjectItemList.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct ProjectItemList<NestedItem: Identifiable, Content: View>: View {
    var projects: [GitLabProject]?
    var nestedItemsKeyPath: KeyPath<GitLabProject, [NestedItem]>
    var content: (GitLabProject, NestedItem) -> Content

    init(projects: [GitLabProject]?, nestedItemsKeyPath: KeyPath<GitLabProject, [NestedItem]>, @ViewBuilder content: @escaping (GitLabProject, NestedItem) -> Content) {
        self.projects = projects
        self.nestedItemsKeyPath = nestedItemsKeyPath
        self.content = content
    }

    var body: some View {
        List {
            if let projects {
                ForEach(projects) { project in
                    Section(header: Text(project.fullPath)) {
                        ForEach(project[keyPath: nestedItemsKeyPath]) { nestedItem in
                            content(project, nestedItem)
                        }
                    }
                }
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
    }
}


struct ProjectItemList_Previews: PreviewProvider {
    static var previews: some View {
        let store = ProjectStore.exampleStore
        
        Group {
            ProjectItemList(
                projects: store.projects,
                nestedItemsKeyPath: \.mergeRequests.nodes
            ) { _, mergeRequest in
                MergeRequestRow(mergeRequest: mergeRequest)
            }

            ProjectItemList(
                projects: store.projects,
                nestedItemsKeyPath: \.pipelines.nodes
            ) { project, pipeline in
                PipelineRow(projectURL: project.webUrl, pipeline: pipeline)
            }
        }
    }
}
