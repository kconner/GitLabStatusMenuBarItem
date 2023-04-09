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
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] notification in
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
        
        let subscriptionIDs = UserDefaults.standard.subscriptions.map(\.id)
        guard !subscriptionIDs.isEmpty else {
            projects = []
            errorMessage = "No subscriptions. Add them in the corner menu."
            return
        }
        
        isLoading = true
        
        ProjectQuery().fetchData(token: token, projectIDs: subscriptionIDs) { [weak self] result in
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
    
    func searchProjectID(for fullPath: String, completion: @escaping (Result<Subscription?, Error>) -> Void) {
        let token = UserDefaults.standard.gitLabToken
        guard !token.isEmpty else { return }

        ProjectQuery().fetchProjectDetails(token: token, fullPath: fullPath) { result in
            switch result {
            case .success(let subscription):
                DispatchQueue.main.async {
                    completion(.success(subscription))
                }
            case .failure(let error):
                print("Error searching for project: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
