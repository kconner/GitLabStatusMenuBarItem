//
//  SubscriptionsView.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct SubscriptionsView: View {
    @AppStorage("subscriptions") var subscriptionsData: Data = Data()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: ProjectStore
    @State private var newSubscriptionPath: String = ""
    @State private var subscriptionSearchResult: Subscription?
    
    var subscriptions: [Subscription] {
        guard let decodedList = try? JSONDecoder().decode([Subscription].self, from: subscriptionsData) else {
            return []
        }
        return decodedList
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter a project's full path", text: $newSubscriptionPath)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Search") {
                    searchProjectID()
                }
            }
            
            if let subscription = subscriptionSearchResult {
                Button("Add \(subscription.fullPath)") {
                    setSubscriptions(subscriptions + [subscription])
                    newSubscriptionPath = ""
                    subscriptionSearchResult = nil
                }
            }
            
            List {
                ForEach(subscriptions) { subscription in
                    Text(subscription.fullPath)
                }
                .onDelete { indexSet in
                    removeSubscriptions(at: indexSet)
                }
            }
            .listStyle(InsetListStyle())
            
            HStack {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .padding()
    }
    
    func removeSubscriptions(at indexSet: IndexSet) {
        var newValue = subscriptions
        newValue.remove(atOffsets: indexSet)
        setSubscriptions(newValue)
    }
    
    func setSubscriptions(_ newValue: [Subscription]) {
        if let encodedData = try? JSONEncoder().encode(newValue) {
            subscriptionsData = encodedData
        }
    }
    
    func searchProjectID() {
        store.searchProjectID(for: newSubscriptionPath) { result in
            switch result {
            case .success(let subscription):
                DispatchQueue.main.async {
                    self.subscriptionSearchResult = subscription
                }
            case .failure(let error):
                print("Error searching for project: \(error)")
                DispatchQueue.main.async {
                    self.subscriptionSearchResult = nil
                }
            }
        }
    }

}
