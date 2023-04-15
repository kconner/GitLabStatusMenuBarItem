//
//  GitLabStatusApp.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

@main
struct GitLabStatusApp: App {
    
    let store: ProjectStore
    
    init() {
        store = ProjectStore()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        MenuBarExtra {
            ProjectsView()
                .environmentObject(store)
        } label: {
            Image(systemName: "square.stack.3d.forward.dottedline.fill")
        }
        .menuBarExtraStyle(.window)
    }
    
}
