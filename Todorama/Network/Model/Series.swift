//
//  Series.swift
//  Todorama
//
//  Created by Claire on 3/23/25.
//

import Foundation


struct Series: Decodable, IdentifiableModel { 
    let id: Int
    let name: String
    let backdrop_path: String?
    let number_of_seasons: Int
    let status: String // 방영 상태 ex. "Ended", "Running"
    let genres: [Genre]
    let overview: String
    let seasons: [Season]
    let networks: [Network]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct Network: Decodable {
    let id: Int
    let logo_path: String
    let name: String
}

struct NetworkDetail: Decodable {
    let id: Int
    let homepage: String
    let logo_path: String
    let name: String
    let origin_country: String
}

struct Season: Decodable {
    let id: Int
    let air_date: String?
    let episode_count: Int
    let name: String
    let overview: String
    let poster_path: String?
    let season_number: Int
}
