//
//  NoteViewModel.swift
//  NoteApp
//
//  Created by Jungman Bae on 7/22/24.
//

import Foundation
import FirebaseFirestore

class NoteViewModel: ObservableObject {
    @Published var notes = [Note]()
    
    @Published var selectedNote = Note()
    private var databaseReference = Firestore.firestore().collection("Notes")
    
    func addData(title: String) {
        let docRef = databaseReference.addDocument(data: ["title": title])
        dump(docRef)
    }
    
    func fetchData() {
        databaseReference.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.notes = documents.compactMap { docSnap -> Note? in
                return try? docSnap.data(as: Note.self)
            }
        }
    }
    
    func updateData(title: String, id: String) {
        databaseReference.document(id).updateData(["title": title]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Note updated successfully")
            }
        }
    }
    
    func deleteData(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let note = notes[index]
            databaseReference.document(note.id ?? "").delete { error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    print("Note with ID \(note.id ?? "") deleted")
                }
            }
        }
    }
}
