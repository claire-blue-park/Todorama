//
//  BackDrop.swift
//  Todorama
//
//  Created by 최정안 on 3/23/25.
//

import Foundation

struct BackDrop {
    let name: String
    let genre: String
    let imagePath: String?
    
    init(modelType: BackDropModel) {
        self.name = modelType.name
        self.imagePath = modelType.backdrop_path
        var genreStr = Strings.Global.empty.text
        if let genreId = modelType.genre_ids.first {
            genreStr = GenreManager.shared.getGenre(genreId) ?? Strings.Global.empty.text
        }
        self.genre = genreStr
    }
}
