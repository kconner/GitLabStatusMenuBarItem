//
//  ProjectStore+Example.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import Foundation

extension ProjectStore {
    static var exampleStore: ProjectStore {
        let store = ProjectStore()
        store.projects = [
            GitLabProject(id: "1", fullPath: "Example Project", webUrl: URL(string: "https://example.com")!, pipelines: examplePipelines, mergeRequests: exampleMergeRequests)
        ]
        return store
    }
    
    static var examplePipelines: GitLabProject.Pipelines {
        let pageInfo = GitLabProject.PageInfo(endCursor: "cursor")
        let pipeline = Pipeline(id: "1", path: "/path", createdAt: "2023-01-01", ref: "some-ref", queuedDuration: 5, duration: 10, status: .success, stages: exampleStages, testReportSummary: exampleTestReportSummary)
        return GitLabProject.Pipelines(pageInfo: pageInfo, nodes: [pipeline])
    }
    
    static var exampleStages: Pipeline.Stages {
        let stage = Stage(id: "one", name: "Build", status: .success)
        return Pipeline.Stages(nodes: [stage])
    }
    
    static var exampleTestReportSummary: TestReportSummary {
        let total = TestReportSummary.Total(failed: 0, count: 5, time: 12)
        return TestReportSummary(total: total)
    }
    
    static var exampleMergeRequests: GitLabProject.MergeRequests {
        let pageInfo = GitLabProject.PageInfo(endCursor: "cursor")
        let author = MergeRequest.Author(username: "user1")
        let approvedBy = MergeRequest.ApprovedBy(nodes: [Approver(username: "user2", avatarUrl: URL(string: "https://example.com/avatar")!)])
        let mergeRequest = MergeRequest(id: "1", webUrl: URL(string: "https://example.com/mr")!, draft: false, title: "Example Merge Request", createdAt: "2023-01-01", author: author, sourceBranch: "feature/foo", headPipeline: examplePipelines.nodes[0], approvalsLeft: 1, approvedBy: approvedBy, shouldBeRebased: false)
        return GitLabProject.MergeRequests(pageInfo: pageInfo, nodes: [mergeRequest])
    }
}
