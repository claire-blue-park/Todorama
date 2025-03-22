//
//  Rating.swift
//  Todorama
//
//  Created by 최정안 on 3/22/25.
//

import Foundation
import RealmSwift

class Rating: Object, RealmFetchable {
    @Persisted(primaryKey: true) var dramaId: Int
    @Persisted var rate: Double
    @Persisted var date: Date
    @Persisted var posterPath: String?
    @Persisted var drama: Drama?

    convenience init(drama: Drama, rate: Double, posterPath: String?) {
        self.init()
        self.dramaId = drama.dramaId
        self.drama = drama
        self.rate = rate
        self.date = Date()
        self.posterPath = posterPath
    }
}

