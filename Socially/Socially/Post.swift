//
//  Post.swift
//  Socially
//
//  Created by Jungman Bae on 7/23/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Post: Identifiable, Decodable {
    @DocumentID var id: String?
    var description: String?
    var imageURL: String?
    @ServerTimestamp var datePublished: Date?
}
