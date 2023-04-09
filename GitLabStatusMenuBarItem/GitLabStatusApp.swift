//
//  GitLabStatusApp.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

@main
struct GitLabStatusApp: App {
    
    let store = ProjectStore()

    var body: some Scene {
        MenuBarExtra {
            ProjectsView()
                .environmentObject(store)
            } label: {
            Image(systemName: "target")
        }
        .menuBarExtraStyle(.window)
    }
    
}
