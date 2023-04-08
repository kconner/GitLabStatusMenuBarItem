//
//  GitLabStatusMenuBarItemApp.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

@main
struct GitLabStatusMenuBarItemApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GitLabDataStore.shared)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: StatusBarItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarItem = StatusBarItem(dataStore: GitLabDataStore.shared)
        GitLabDataStore.shared.refreshData()
    }
}

private extension GitLabDataStore {
    static let shared = GitLabDataStore()
}
