//
//  GitLabDataFetcher.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import Foundation

class GitLabDataFetcher {
    
    private let gitLabApiURL = "https://gitlab.com/api/graphql"
    
    func fetchData(completion: @escaping (Result<[GitLabProject], Error>) -> Void) {
        var request = URLRequest(url: URL(string: gitLabApiURL)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(gitLabPersonalAccessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let pipelineFields = """
        id
        path
        createdAt
        ref
        queuedDuration
        duration
        status
        stages {
          nodes {
            id
            name
            status
          }
        }
        testReportSummary {
          total {
            failed
            count
            time
          }
        }
        """
        
        let query = """
        {
          projects(ids: ["gid://gitlab/Project/3472737", "gid://gitlab/Project/250833", "gid://gitlab/Project/10582521"]) {
            nodes {
              id
              fullPath
              webUrl
              pipelines(first: 5, ref: "master") {
                pageInfo {
                  endCursor
                }
                nodes {
                  \(pipelineFields)
                }
              }
              mergeRequests(state: opened, first: 10) {
                pageInfo {
                  endCursor
                }
                nodes {
                  id
                  webUrl
                  draft
                  title
                  createdAt
                  author {
                    username
                  }
                  sourceBranch
                  headPipeline {
                    \(pipelineFields)
                  }
                  approvalsLeft
                  approvedBy {
                    nodes {
                      username
                      avatarUrl
                    }
                  }
                  shouldBeRebased
                }
              }
            }
          }
        }
        """
        
        let requestBody = [
            "query": query
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                // let json = String(data: data, encoding: .utf8)
                // print(json!)
                
                let response = try JSONDecoder().decode(GitLabProjectsResponse.self, from: data)
                completion(.success(response.data.projects.nodes))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
}
