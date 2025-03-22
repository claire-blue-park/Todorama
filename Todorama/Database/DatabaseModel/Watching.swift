//
//  Watching.swift
//  Todorama
//
//  Created by 최정안 on 3/22/25.
//

import Foundation
import RealmSwift

class Watching: Object, RealmFetchable {
    @Persisted(primaryKey: true) var dramaId: Int
    @Persisted var episodeIds: List<Int>
    @Persisted var episodeCount: Int
    @Persisted var drama: Drama?
    @Persisted var posterPath: String?

    convenience init(drama: Drama, episodeIds: [Int], episodeCount: Int, posterPath: String?) {
        self.init()
        self.dramaId = drama.dramaId
        self.drama = drama
        self.episodeIds.append(objectsIn: episodeIds)
        self.episodeCount = episodeCount
        self.posterPath = posterPath
    }
}

