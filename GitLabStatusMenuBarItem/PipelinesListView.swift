//
//  PipelinesListView.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct PipelinesListView: View {
    @EnvironmentObject var store: GitLabDataStore
    
    var body: some View {
        List {
            if let projects = store.gitLabData {
                ForEach(projects) { project in
                    Section(header: Text(project.fullPath)) {
                        ForEach(project.pipelines.nodes) { pipeline in
                            PipelineRow(projectURL: project.webUrl, pipeline: pipeline)
                        }
                    }
                }
            }
        }
    }
}

struct PipelinesListView_Previews: PreviewProvider {
    static var previews: some View {
        PipelinesListView()
            .environmentObject(GitLabDataStore.exampleStore)
    }
}
