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
        MenuBarExtra {
            ProjectsView()
                .frame(width: 320, height: 700)
                .environmentObject(store)
        } label: {
            Image(systemName: "square.stack.3d.forward.dottedline.fill")
        }
        .menuBarExtraStyle(.window)
    }
    
}
