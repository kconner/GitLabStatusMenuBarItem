//
//  ProjectStore.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import Foundation
import Combine

class ProjectStore: ObservableObject {
    
    @Published var projects: [GitLabProject]?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let dataFetcher: ProjectQuery
    
    init(fetcher: ProjectQuery = ProjectQuery()) {
        self.dataFetcher = fetcher
    }
    
    func refreshData() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        
        dataFetcher.fetchData { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                self.isLoading = false
                
                switch result {
                case .success(let data):
                    self.projects = data
                    self.errorMessage = nil
                case .failure(let error):
                    self.errorMessage = "Error fetching GitLab data: \(error)"
                }
            }
        }
    }
    
}
