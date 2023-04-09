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
        Button(action: {
            NSWorkspace.shared.open(mergeRequest.webUrl)
        }) {
            HStack {
                if let headPipeline = mergeRequest.headPipeline {
                    PipelineStatusView(pipeline: headPipeline)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Label {
                        Text(mergeRequest.title)
                    } icon: {
                        if mergeRequest.draft {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(Color.orange)
                        }
                    }
                    .font(.headline)

                    HStack {
                        Text(mergeRequest.author.username)
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text(mergeRequest.sourceBranch)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if mergeRequest.approvalsLeft == 0 && !mergeRequest.shouldBeRebased {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)
                        .foregroundColor(Color.green)
                } else if mergeRequest.approvalsLeft == 0 && mergeRequest.shouldBeRebased {
                    Image(systemName: "arrow.clockwise.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)
                        .foregroundColor(Color.blue)
                } else {
                    Text("\(mergeRequest.approvalsLeft)")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                
                HStack {
                    ForEach(mergeRequest.approvedBy.nodes, id: \.username) { approver in
                        if let avatarUrl = approver.avatarUrl {
                            AsyncImage(url: avatarUrl) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 24, height: 24)
                                }
                            }
                        } else {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MergeRequestRow_Previews: PreviewProvider {
    static var previews: some View {
        MergeRequestRow(mergeRequest: ProjectStore.exampleStore.projects![0].mergeRequests.nodes[0])
    }
}
