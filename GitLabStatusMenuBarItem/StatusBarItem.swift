//
//  StatusBarItem.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI
import Combine

class StatusBarItem: NSObject {
    
    private(set) var dataStore: GitLabDataStore
    
    private var statusBar: NSStatusBar
    private var statusBarItem: NSStatusItem
    private var popover: NSPopover
    
    init(dataStore: GitLabDataStore) {
        statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        popover = NSPopover()
        self.dataStore = dataStore
        
        super.init()
        
        // Set up the Menu Bar Item
        if let button = statusBarItem.button {
            button.image = NSImage(systemSymbolName: "target", accessibilityDescription: nil)
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
        
        // Set up the popover content
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(
            rootView:
                StatusBarMenu()
                .frame(width: 320, height: 700)
                .environmentObject(dataStore)
        )
    }
    
    @objc func togglePopover(_ sender: AnyObject) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let button = statusBarItem.button {
                dataStore.refreshData()
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
    
}
