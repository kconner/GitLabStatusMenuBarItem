//
//  PipelineStatusView.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct PipelineStatusView: View {
    let pipeline: Pipeline
    
    var body: some View {
        VStack {
            Image(systemName: statusIcon(pipeline.status))
                .resizable()
                .scaledToFit()
                .frame(height: 24)
                .foregroundColor(statusColor(pipeline.status))
        }
    }
    
    func statusIcon(_ status: String) -> String {
        switch status {
        case "success":
            return "checkmark.circle"
        case "failed":
            return "xmark.circle"
        case "running":
            return "arrow.triangle.2.circlepath.circle"
        default:
            return "questionmark.circle"
        }
    }
    
    func statusColor(_ status: String) -> Color {
        switch status {
        case "success":
            return .green
        case "failed":
            return .red
        case "running":
            return .blue
        default:
            return .gray
        }
    }
}

struct PipelineStatusView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineStatusView(pipeline: GitLabDataStore.exampleStore.gitLabData![0].pipelines.nodes[0])
    }
}
