//
//  PipelineStatusView.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct PipelineStatusView: View {
    let status: PipelineStatus
    
    var body: some View {
        let (icon, color) = appearance(for: status)
        
        Image(systemName: icon)
            .foregroundColor(color)
    }
    
    func appearance(for status: PipelineStatus) -> (String, Color) {
        switch status {
        case .created:
            return ("dot.circle", .secondary)
        case .waitingForResource, .preparing:
            return ("ellipsis.circle", .brown)
        case .pending:
            return ("pause.circle", .orange)
        case .running:
            return ("arrow.right.circle", .blue)
        case .failed:
            return ("xmark.circle", .red)
        case .success:
            return ("checkmark.circle", .green)
        case .canceled:
            return ("slash.circle", .primary)
        case .skipped:
            return ("chevron.right.circle", .secondary)
        case .manual:
            return ("gearshape.circle", .primary)
        case .scheduled:
            return ("calendar.circle", .brown)
        case .unknown:
            return ("questionmark.circle", .orange)
        }
    }
}

struct PipelineStatusView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack(spacing: 10) {
            views()
                .font(.title2)
            
            views()
                .font(.footnote)
                .bold()
        }
        .previewLayout(.sizeThatFits)
    }
    
    static func views() -> some View {
        HStack(spacing: 1) {
            ForEach(PipelineStatus.allCases) { status in
                PipelineStatusView(status: status)
            }
        }
    }
    
}
