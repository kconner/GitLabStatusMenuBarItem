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
        case .created, .waitingForResource, .preparing, .pending:
            return ("ellipsis.circle", .brown)
        case .running:
            return ("arrow.right.circle", .blue)
        case .failed:
            return ("xmark.circle", .red)
        case .success:
            return ("checkmark.circle", .green)
        case .canceled:
            return ("slash.circle", .gray)
        case .skipped:
            return ("chevron.right.circle", .gray)
        case .manual:
            return ("hand.raised.circle", .purple)
        case .scheduled:
            return ("calendar.circle", .brown)
        case .unknown:
            return ("questionmark.circle", .orange)
        }
    }
}

struct PipelineStatusView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 0) {
            ForEach(PipelineStatus.allCases) { status in
                PipelineStatusView(status: status)
            }
        }
        .font(.footnote)
    }
}
