//
//  Post.swift
//  Socially-UIKit
//
//  Created by Jungman Bae on 7/25/24.
//

import Foundation
import FirebaseFirestore

struct Post: Hashable, Identifiable, Decodable {
    @DocumentID var id: String?
    var description: String?
    var imageURL: String?
    @ServerTimestamp var datePublished: Date?
    
    init?(document: QueryDocumentSnapshot) {
        dump(document.data())
        self.id = document.documentID
        self.description = document.data()["description"] as? String
        self.imageURL = document.data()["imageURL"] as? String
    }
}
