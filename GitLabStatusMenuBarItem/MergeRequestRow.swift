//
//  MergeRequestRow.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct MergeRequestRow: View {
    
    let mergeRequest: MergeRequest
    
    var body: some View {
        Button {
            NSWorkspace.shared.open(mergeRequest.webUrl)
        } label: {
            HStack(spacing: 6) {
                AvatarView(avatar: mergeRequest.author.avatarUrl, relativeTo: mergeRequest.webUrl)
                    .font(.title2)
                
                VStack(spacing: 2) {
                    HStack {
                        Text(mergeRequest.title)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .font(.headline)

                    HStack(spacing: 2) {
                        PipelineStatusView(status: mergeRequest.headPipeline?.status ?? .canceled)
                        
                        Text(mergeRequest.sourceBranch)
                            .foregroundColor(.secondary)
                            .marquee()
                        
                        Spacer()
                        
                        if mergeRequest.draft {
                            Image(systemName: "pencil.and.outline")
                                .foregroundColor(.brown)
                        } else {
                            if mergeRequest.approvalsLeft == 0 && mergeRequest.shouldBeRebased {
                                Text("rebase")
                                    .foregroundColor(.red)
                            }
                            
                            HStack(spacing: 1) {
                                ForEach(0..<mergeRequest.approvalsLeft, id: \.self) { _ in
                                    Image(systemName: "circle")
                                        .foregroundColor(.red)
                                }
                                
                                ForEach(mergeRequest.approvedBy.nodes, id: \.username) { approver in
                                    AvatarView(avatar: approver.avatarUrl, relativeTo: mergeRequest.webUrl)
                                }
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
    
}

struct AvatarView: View {
    
    private var url: URL?
    
    init(avatar: URL?, relativeTo basis: URL?) {
        url = avatar.flatMap {
            URL(string: $0.path, relativeTo: basis)
        }
    }
    
    var body: some View {
        Image(systemName: "person.circle")
            .foregroundColor(.secondary)
            .overlay {
                if let url {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .padding(1)
                        }
                    }
                }
            }
    }
}

struct MergeRequestRow_Previews: PreviewProvider {
    static var previews: some View {
        MergeRequestRow(mergeRequest: ProjectStore.exampleStore.projects![0].mergeRequests.nodes[0])
    }
}
