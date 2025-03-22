//
//  Comment.swift
//  Todorama
//
//  Created by 최정안 on 3/22/25.
//

import Foundation
import RealmSwift

class Comment: Object, RealmFetchable {
    @Persisted(primaryKey: true) var dramaId: Int
    @Persisted var comment: String
    @Persisted var drama: Drama?

    convenience init(drama: Drama, comment: String) {
        self.init()
        self.dramaId = drama.dramaId
        self.drama = drama
        self.comment = comment
    }
}


