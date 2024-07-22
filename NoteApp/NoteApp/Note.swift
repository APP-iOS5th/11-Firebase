//
//  Note.swift
//  NoteApp
//
//  Created by Jungman Bae on 7/22/24.
//

import Foundation
import FirebaseFirestoreSwift

struct Note: Codable {
    @DocumentID var id: String?
    var title: String?
}
