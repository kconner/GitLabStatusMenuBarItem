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
    var emptyListMark: String
    var content: (GitLabProject, NestedItem) -> Content

    init(projects: [GitLabProject]?, nestedItemsKeyPath: KeyPath<GitLabProject, [NestedItem]>, emptyListMark: String, @ViewBuilder content: @escaping (GitLabProject, NestedItem) -> Content) {
        self.projects = projects
        self.nestedItemsKeyPath = nestedItemsKeyPath
        self.emptyListMark = emptyListMark
        self.content = content
    }

    var body: some View {
        List {
            if let projects {
                ForEach(projects) { project in
                    Section {
                        if project[keyPath: nestedItemsKeyPath].isEmpty {
                            HStack {
                                Spacer()
                                
                                Text(emptyListMark)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        } else {
                            ForEach(project[keyPath: nestedItemsKeyPath]) { nestedItem in
                                content(project, nestedItem)
                            }
                        }
                    } header: {
                        Link(destination: project.webUrl) {
                            Text(project.webUrl.lastPathComponent)
                        }
                    }
                }
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .scrollBounceBehavior(.always)
    }
}


struct ProjectItemList_Previews: PreviewProvider {
    static var previews: some View {
        let store = ProjectStore.exampleStore
        
        Group {
            ProjectItemList(
                projects: store.projects,
                nestedItemsKeyPath: \.mergeRequests.nodes,
                emptyListMark: "No merge requests"
            ) { _, mergeRequest in
                MergeRequestRow(mergeRequest: mergeRequest)
            }

            ProjectItemList(
                projects: store.projects,
                nestedItemsKeyPath: \.pipelines.nodes,
                emptyListMark: "No pipeline runs"
            ) { project, pipeline in
                PipelineRow(projectURL: project.webUrl, pipeline: pipeline)
            }
        }
    }
}
