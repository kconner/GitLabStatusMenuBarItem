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
        Button {
            if let pipelineURL {
                NSWorkspace.shared.open(pipelineURL)
            }
        } label: {
            HStack(spacing: 6) {
                PipelineStatusView(status: pipeline.status)
                    .font(.title2)
                    .fixedSize()
                
                VStack(spacing: 2) {
                    HStack {
                        Text(pipeline.ref)
                        
                        Spacer()
                    }
                    .font(.headline)
                        
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Group {
                            if let duration = pipeline.duration {
                                Text(stringFromDuration(duration))
                            } else if let duration = pipeline.queuedDuration {
                                Text("queued \(stringFromDuration(duration))")
                            }
                        }
                        .foregroundColor(.secondary)
                        
                        
                        Spacer()
                        
                        if let testReportSummary = pipeline.testReportSummary,
                           testReportSummary.total.failed > 0
                        {
                            Text("\(testReportSummary.total.failed) tests")
                                .foregroundColor(.red)
                        }
                        
                        HStack(spacing: 1) {
                            ForEach(pipeline.stages.nodes) { stage in
                                PipelineStatusView(status: stage.status)
                            }
                        }
                    }
                    .font(.footnote)
                    .bold()
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
        
    }
    
    func stringFromDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .default
        return formatter.string(from: duration) ?? ""
    }
    
}

struct PipelineRow_Previews: PreviewProvider {
    static var previews: some View {
        let project = ProjectStore.exampleStore.projects![0]
        
        PipelineRow(projectURL: project.webUrl, pipeline: project.pipelines.nodes[0])
    }
}
