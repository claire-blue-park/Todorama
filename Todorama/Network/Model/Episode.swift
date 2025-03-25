//
//  Episode.swift
//  Todorama
//
//  Created by Claire on 3/23/25.
//

import Foundation


struct SeasonDetail: Decodable {
    let name: String
    let overview: String
    let id: Int
    let poster_path: String?
    let season_number: Int
    let episodes: [Episode]
}

struct Episode: Decodable, IdentifiableModel {
    let id: Int
    let name: String
    let overview: String
    let air_date: String?
    let episode_number: Int
    let episode_type: String
    let runtime: Int?
    let season_number: Int
    let still_path: String?
}
