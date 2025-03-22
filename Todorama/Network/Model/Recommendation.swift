//
//  Recommendation.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import Foundation

struct Recommendation: Decodable, Hashable {
    let results: [RecommendationDetail]
}
struct RecommendationDetail: Decodable, Hashable, IdentifiableModel {
    let id: Int
    let poster_path: String
}
