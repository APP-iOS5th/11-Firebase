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
    
    @StateObject private var viewModel = NoteViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.notes, id: \.id) { note in
                    NavigationLink(destination: DetailsView(note: note)) {
                        VStack(alignment: .leading) {
                            Text(note.title ?? "")
                                .font(.system(size: 22, weight: .regular))
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteData(at:))
            }
            .onAppear {
                viewModel.fetchData()
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Text(" \(viewModel.notes.count) notes")
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
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
