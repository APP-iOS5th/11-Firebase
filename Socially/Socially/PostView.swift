//
//  PostView.swift
//  Socially
//
//  Created by Jungman Bae on 7/23/24.
//

import SwiftUI

struct PostView: View {
    @EnvironmentObject private var viewModel: PostViewModel
    
    @State private var description = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Description", text: $description)
                }
                
                Section {
                    Button(action: {
                        // MARK: Post data to Firestore
                        Task {
                            await self.viewModel.addData(description: description,
                                                         datePublished: Date())
                        }
                    }) {
                        Text("Post")
                    }
                }
            }
            .navigationTitle("New Post")
        }
    }
}

#Preview {
    PostView()
        .environmentObject(PostViewModel())
}
