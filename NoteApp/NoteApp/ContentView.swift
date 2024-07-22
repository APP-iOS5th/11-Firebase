//
//  ContentView.swift
//  NoteApp
//
//  Created by Jungman Bae on 7/22/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet = false
    @State private var postDetent = PresentationDetent.medium
    
    var body: some View {
        NavigationStack {
            List {
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Text(" X notes")
                    Spacer()
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .imageScale(.large)
                    .sheet(isPresented: $showSheet) {
                        FormView().presentationDetents([.large, .medium])
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
