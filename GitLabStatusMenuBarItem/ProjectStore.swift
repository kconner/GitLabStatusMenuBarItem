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
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        UserDefaults.standard.publisher(for: \.gitLabToken)
            .sink { [weak self] _ in
                guard let self else { return }
                self.errorMessage = nil
                self.refreshData()
            }
            .store(in: &cancellables)
    }
    
    func refreshData() {
        guard !isLoading else {
            return
        }
        
        let token = UserDefaults.standard.gitLabToken
        guard !token.isEmpty else {
            errorMessage = "No GitLab token. Set it in the corner menu."
            return
        }
        
        isLoading = true
        
        ProjectQuery().fetchData(token: token) { [weak self] result in
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
