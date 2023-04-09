//
//  SubscriptionsSheet.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct SubscriptionsSheet: View {
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
    
    @State private var selection: Set<Subscription.ID> = []
    
    var body: some View {
        VStack {
            HStack {
                Text("Subscriptions")
                    .font(.headline)
                
                Spacer()
            }
            .padding(.horizontal)
            
            List(subscriptions, selection: $selection) { subscription in
                HStack {
                    Text(subscription.fullPath)
                }
            }
            .onDeleteCommand {
                removeSelectedSubscriptions()
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
            .frame(height: 170)
            
            HStack {
                TextField("organization/path/to/project", text: $newSubscriptionPath)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Search") {
                    searchProjectID()
                }
            }
            .padding(.horizontal)
            
            if let subscription = subscriptionSearchResult {
                Button("Add \(subscription.fullPath)") {
                    setSubscriptions(subscriptions + [subscription])
                    newSubscriptionPath = ""
                    subscriptionSearchResult = nil
                }
            }
            
            HStack {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .padding(.vertical)
        .frame(width: 300)
    }
    
    func removeSelectedSubscriptions() {
        let newValue = subscriptions.filter { subscription in
            !selection.contains(subscription.id)
        }
        
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

struct SubscriptionsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionsSheet()
            .environmentObject(ProjectStore.exampleStore)
    }
}
