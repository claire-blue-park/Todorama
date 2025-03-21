//
//  Popular.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import Foundation
struct Popular: Decodable, Hashable {
    let results: [PopularDetail]
}
struct PopularDetail: Decodable, Hashable {
    let id: Int
    let poster: String
}

