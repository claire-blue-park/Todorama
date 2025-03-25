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

class Watching2: Object, RealmFetchable {
    @Persisted(primaryKey: true) var dramaId: Int // 시리즈 아이디
    @Persisted var dramaName: String // 시리즈 이름
    @Persisted var seasonNumber: Int // 시즌 넘버
    @Persisted var episodeIds: List<Int> // 체크된 에피소드
    @Persisted var episodeCount: Int // 총 에피소드 갯수
    @Persisted var stillCutPath: String? // 에피소드 1화 이미지

    convenience init(dramaId: Int, dramaName: String, seasonNumber: Int, episodeIds: [Int], episodeCount: Int, stillCutPath: String? = nil) {
        self.init()
        self.dramaId = dramaId
        self.dramaName = dramaName
        self.seasonNumber = seasonNumber
        self.episodeIds.append(objectsIn: episodeIds)
        self.episodeCount = episodeCount
        self.stillCutPath = stillCutPath
    }
    
}


struct Watching3 {
    let dramaId: Int // 시리즈 아이디
    let dramaName: String // 시리즈 이름
    let seasonNumber: Int // 시즌 넘버
    let episodeId: Int // 체크된 에피소드
    let episodeCount: Int // 총 에피소드 갯수
    let stillCutPath: String? // 에피소드 1화 이미지
    
}
