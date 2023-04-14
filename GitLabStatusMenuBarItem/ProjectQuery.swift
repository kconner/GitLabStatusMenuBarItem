//
//  ProjectQuery.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import Foundation

class ProjectQuery {
    
    private let gitLabApiURL = "https://gitlab.com/api/graphql"
    
    func fetchData(token: String, projectIDs: [String], completion: @escaping (Result<[GitLabProject], Error>) -> Void) {
        var request = URLRequest(url: URL(string: gitLabApiURL)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
          projects(ids: \(projectIDs)) {
            nodes {
              id
              fullPath
              webUrl
              pipelines(first: 10) {
                pageInfo {
                  endCursor
                }
                nodes {
                  \(pipelineFields)
                }
              }
              mergeRequests(state: opened, first: 5) {
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
                    avatarUrl
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
                #if DEBUG
                let json = String(data: data, encoding: .utf8)
                print(json!)
                #endif
                
                let response = try JSONDecoder().decode(GitLabProjectsResponse.self, from: data)
                completion(.success(response.data.projects.nodes))
            } catch {
                #if DEBUG
                print(error)
                #endif
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchProjectDetails(token: String, fullPath: String, completion: @escaping (Result<Subscription?, Error>) -> Void) {
        var request = URLRequest(url: URL(string: gitLabApiURL)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let query = """
        {
          subscription: project(fullPath: "\(fullPath)") {
            id
            fullPath
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

            #if DEBUG
            let json = String(data: data, encoding: .utf8)
            print(json!)
            #endif
            
            do {
                let response = try JSONDecoder().decode(GitLabSubcriptionResponse.self, from: data)
                completion(.success(response.data.subscription))
            } catch {
                #if DEBUG
                print(error)
                #endif
                completion(.failure(error))
            }
        }

        task.resume()
    }

}
