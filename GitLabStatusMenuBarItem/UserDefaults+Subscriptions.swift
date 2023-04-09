//
//  UserDefaults+Subscriptions.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import Foundation

extension UserDefaults {
    dynamic var subscriptions: [Subscription] {
        get {
            guard let data = data(forKey: "subscriptions") else { return [] }
            return (try? JSONDecoder().decode([Subscription].self, from: data)) ?? []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                set(data, forKey: "subscriptions")
            }
        }
    }
}
