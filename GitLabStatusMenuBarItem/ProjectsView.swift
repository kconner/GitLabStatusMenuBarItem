//
//  StatusBarMenu.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct ProjectsView: View {
    
    enum Tab: Hashable {
        case mergeRequests, pipelines
    }
    
    @EnvironmentObject var store: ProjectStore
    
    @State private var selectedTab: Tab = .mergeRequests
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Picker(selection: $selectedTab) {
                    Text("Merge Requests")
                        .tag(Tab.mergeRequests)
                    
                    Text("Pipelines")
                        .tag(Tab.pipelines)
                } label: {}
                .pickerStyle(.segmented)
                .fixedSize()
                
                Spacer()
                
                Menu {
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
            .padding([.top, .horizontal])
            
            if let message = store.errorMessage {
                Text(message)
                    .padding(.horizontal)
            }
            
            Group {
                switch selectedTab {
                case .mergeRequests:
                    ProjectItemList(
                        projects: store.projects,
                        nestedItemsKeyPath: \.mergeRequests.nodes
                    ) { _, mergeRequest in
                        MergeRequestRow(mergeRequest: mergeRequest)
                    }
                case .pipelines:
                    ProjectItemList(
                        projects: store.projects,
                        nestedItemsKeyPath: \.pipelines.nodes
                    ) { project, pipeline in
                        PipelineRow(projectURL: project.webUrl, pipeline: pipeline)
                    }
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
        .frame(width: 320, height: 700)
        .background(.background)
        .onAppear {
            store.refreshData()
        }
    }
}

struct StatusBarMenu_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
            .environmentObject(ProjectStore.exampleStore)
    }
}
