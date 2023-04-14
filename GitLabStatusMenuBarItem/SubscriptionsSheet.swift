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
    @State private var errorMessage: String?
    
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
            
            List(selection: $selection) {
                ForEach(subscriptions) { subscription in
                    Text(subscription.fullPath)
                }
                .onMove { offsets, destination in
                    moveSubscriptions(at: offsets, to: destination)
                }
            }
            .onDeleteCommand {
                deleteSelectedSubscriptions()
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
            
            VStack {
                HStack {
                    TextField("organization/path/to/project", text: $newSubscriptionPath)
                        .onSubmit {
                            searchProjectID()
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Search") {
                        searchProjectID()
                    }
                }
                
                if let errorMessage {
                    HStack {
                        Text(errorMessage)
                            .font(.subheadline)
                        Spacer()
                    }
                }
                
                HStack {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .frame(width: 300, height: 300)
    }
    
    func moveSubscriptions(at offsets: IndexSet, to destination: Int) {
        var newValue = subscriptions
        newValue.move(fromOffsets: offsets, toOffset: destination)
        setSubscriptions(newValue)
    }
    
    func deleteSelectedSubscriptions() {
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
        guard !newSubscriptionPath.isEmpty else { return }
        
        store.searchProjectID(for: newSubscriptionPath) { result in
            switch result {
            case .success(let subscription):
                DispatchQueue.main.async {
                    if let subscription {
                        if !subscriptions.contains(where: { $0.id == subscription.id }) {
                            setSubscriptions(subscriptions + [subscription])
                        }
                        
                        errorMessage = nil
                        
                        newSubscriptionPath = ""
                    } else {
                        errorMessage = "Not found."
                    }
                }
            case .failure(let error):
                print("Error searching for project: \(error)")
                DispatchQueue.main.async {
                    errorMessage = "Not found."
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
