//
//  TokenSheet.swift
//  GitLabStatusMenuBarItem
//
//  Created by Kevin Conner on 2023-04-08.
//

import SwiftUI

struct TokenSheet: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("gitLabToken") private var gitLabToken: String = ""
    @State private var tokenInput: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter your GitLab Personal Access Token")
                .font(.headline)
            Text("First, [create a token](https://gitlab.com/-/profile/personal_access_tokens) with `read_api` rights.")
                .font(.subheadline)
            
            SecureField("", text: $tokenInput)
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Button("Save") {
                    gitLabToken = tokenInput
                    dismiss()
                }
            }
        }
        .padding()
        .frame(width: 300)
    }
}

struct TokenSheet_Previews: PreviewProvider {
    static var previews: some View {
        TokenSheet()
    }
}
