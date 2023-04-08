//
//  GitLabDataStore.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import Foundation
import Combine

class GitLabDataStore: ObservableObject {
    
    @Published var gitLabData: [GitLabProject]?
    
    let dataFetcher: GitLabDataFetcher
    
    init(fetcher: GitLabDataFetcher = GitLabDataFetcher()) {
        self.dataFetcher = fetcher
    }
    
    func fetchData(completion: @escaping (Result<[GitLabProject], Error>) -> Void) {
        dataFetcher.fetchData { result in
            completion(result)
        }
    }
    
    func refreshData() {
        fetchData { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.gitLabData = data
                }
            case .failure(let error):
                print("Error fetching GitLab data: \(error)")
            }
        }
    }
    
}
