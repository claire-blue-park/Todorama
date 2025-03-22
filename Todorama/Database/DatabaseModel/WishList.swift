//
//  WishList.swift
//  Todorama
//
//  Created by 최정안 on 3/22/25.
//

import Foundation
import RealmSwift

class WishList: Object, RealmFetchable {
    @Persisted(primaryKey: true) var dramaId: Int
    @Persisted var drama: Drama?

    convenience init(drama: Drama) {
        self.init()
        self.dramaId = drama.dramaId
        self.drama = drama
    }
}
