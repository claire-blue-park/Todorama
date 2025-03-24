//
//  GenreManager.swift
//  Todorama
//
//  Created by 최정안 on 3/22/25.
//

import Foundation

class GenreManager {
    static let shared = GenreManager()
    
    let genres: [Int: String] = [
        // 영화 장르
        28: "액션",
        16: "애니메이션",
        80: "범죄",
        18: "드라마",
        14: "판타지",
        27: "공포",
        9648: "미스터리",
        878: "SF",
        53: "스릴러",
        37: "서부",
        12: "모험",
        35: "코미디",
        99: "다큐멘터리",
        10751: "가족",
        36: "역사",
        10402: "음악",
        10749: "로맨스",
        10770: "TV 영화",
        10752: "전쟁",        
        // TV 장르
        10759: "액션 & 어드벤처",
        10762: "어린이",
        10763: "뉴스",
        10764: "리얼리티",
        10765: "SF & 판타지",
        10766: "소프",
        10767: "토크쇼",
        10768: "전쟁 & 정치",
        00: ""
    ]
    private init() { }
    
    func getGenre(_ id: Int) -> String {
        if let result = genres[id] {
            return result
        } else {
            return Strings.Global.none.text
        }

    }
}


