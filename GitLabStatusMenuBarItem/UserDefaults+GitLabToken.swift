//
//  UserDefaults+GitLabToken.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import Foundation

extension UserDefaults {
    @objc dynamic var gitLabToken: String {
        get { string(forKey: "gitLabToken") ?? "" }
        set { set(newValue, forKey: "gitLabToken") }
    }
}
