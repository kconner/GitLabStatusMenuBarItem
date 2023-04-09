//
//  Model.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import Foundation

struct GitLabProjectsResponse: Codable {
    let data: Data
    
    struct Data: Codable {
        let projects: Projects
    }
    
    struct Projects: Codable {
        let nodes: [GitLabProject]
    }
}

struct GitLabSubcriptionResponse: Codable {
    let data: Data
    
    struct Data: Codable {
        let subscription: Subscription
    }
}

struct GitLabProject: Codable, Identifiable {
    let id: String
    let fullPath: String
    let webUrl: URL
    let pipelines: Pipelines
    let mergeRequests: MergeRequests
    
    struct Pipelines: Codable {
        let pageInfo: PageInfo
        let nodes: [Pipeline]
    }
    
    struct MergeRequests: Codable {
        let pageInfo: PageInfo
        let nodes: [MergeRequest]
    }
    
    struct PageInfo: Codable {
        let endCursor: String
    }
}

struct Pipeline: Codable, Identifiable {
    let id: String
    let path: String
    let createdAt: String
    let ref: String
    let queuedDuration: TimeInterval?
    let duration: TimeInterval?
    let status: String
    let stages: Stages
    let testReportSummary: TestReportSummary?
    
    struct Stages: Codable {
        let nodes: [Stage]
    }
}

struct Stage: Codable, Identifiable {
    let id: String
    let name: String
    let status: String
}

struct TestReportSummary: Codable {
    let total: Total
    
    struct Total: Codable {
        let failed: Int
        let count: Int
        let time: TimeInterval
    }
}

struct MergeRequest: Codable, Identifiable {
    let id: String
    let webUrl: URL
    let draft: Bool
    let title: String
    let createdAt: String
    let author: Author
    let sourceBranch: String
    let headPipeline: Pipeline?
    let approvalsLeft: Int
    let approvedBy: ApprovedBy
    let shouldBeRebased: Bool
    
    struct Author: Codable {
        let username: String
    }
    
    struct ApprovedBy: Codable {
        let nodes: [Approver]
    }
}

struct Approver: Codable {
    let username: String
    let avatarUrl: URL?
}

struct Subscription: Identifiable, Codable, Hashable {
    let id: String
    let fullPath: String
}
