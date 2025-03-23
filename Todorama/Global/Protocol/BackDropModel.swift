//
//  BackDropModel.swift
//  Todorama
//
//  Created by 최정안 on 3/23/25.
//

import Foundation
protocol BackDropModel {
    var name: String {get}
    var genre_ids: [Int] {get}
    var backdrop_path: String? {get}
}
