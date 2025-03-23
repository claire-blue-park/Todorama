//
//  Trend.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import Foundation

struct Trend: Decodable, Hashable {
    let results: [TrendDetail]
}

struct TrendDetail: Decodable, Hashable, IdentifiableModel, BackDropModel {
    let id: Int
    let backdrop_path: String?
    let name: String
    let genre_ids: [Int]
}
