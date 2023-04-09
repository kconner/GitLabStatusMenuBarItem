//
//  PipelineRow.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct PipelineRow: View {
    let projectURL: URL
    let pipeline: Pipeline
    
    var pipelineURL: URL? {
        guard var components = URLComponents(url: projectURL, resolvingAgainstBaseURL: false) else { return nil }
        components.path = pipeline.path
        return components.url
    }
    
    var body: some View {
        Button(action: {
            if let pipelineURL {
                NSWorkspace.shared.open(pipelineURL)
            }
        }) {
            HStack {
                PipelineStatusView(pipeline: pipeline)
                
                Text(pipeline.ref)
                    .font(.headline)
                
                Spacer()
                
                if pipeline.status == "not_started" {
                    Text("Queued: \(pipeline.queuedDuration ?? 0, specifier: "%.2f")s")
                } else {
                    Text("Duration: \(pipeline.duration ?? 0, specifier: "%.2f")s")
                    HStack(spacing: 4) {
                        ForEach(pipeline.stages.nodes) { stage in
                            Text(stage.status.prefix(1))
                                .padding(4)
                                .background(statusColor(for: stage.status))
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .font(.footnote)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())

    }
    
    private func statusColor(for status: String) -> Color {
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

struct PipelineRow_Previews: PreviewProvider {
    static var previews: some View {
        let project = ProjectStore.exampleStore.projects![0]
        
        PipelineRow(projectURL: project.webUrl, pipeline: project.pipelines.nodes[0])
    }
}
