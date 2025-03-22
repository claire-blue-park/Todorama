//
//  Drama.swift
//  Todorama
//
//  Created by 최정안 on 3/22/25.
//

import Foundation
import RealmSwift

class Drama: Object {
    @Persisted(primaryKey: true) var dramaId: Int
    @Persisted var name: String
    @Persisted var backdropPath: String
    @Persisted var genre: Int

    convenience init(dramaId: Int, name: String, backdropPath: String, genre: Int) {
        self.init()
        self.dramaId = dramaId
        self.name = name
        self.backdropPath = backdropPath
        self.genre = genre
    }
}
