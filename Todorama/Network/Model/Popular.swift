//
//  Popular.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import Foundation
struct Popular: Decodable, Hashable {
    let results: [PopularDetail]
    let total_pages: Int
    let page: Int
}
struct PopularDetail: Decodable, Hashable, IdentifiableModel {
    let id: Int
    let poster_path: String?
}

