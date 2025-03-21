//
//  HomeViewModel.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewModel {
    let sections: Observable<[SectionModel<String, AnyHashable>]>

    init() {
        let popularMovies: [PopularDetail] = (1...10).map {
            PopularDetail(id: $0, poster: "https://via.placeholder.com/150?text=Popular\($0)")
        }
        
        let trendingMovies: [TrendDetail] = (1...10).map {
            TrendDetail(id: $0,
                        backdrop_path: "https://via.placeholder.com/300x150?text=Trend\($0)",
                        name: "트렌드 영화 \($0)",
                        genre_ids: [28, 12, 16]) // 예시로 액션, 모험, 애니메이션
        }
        
        let recommendations: [RecommandationDetail] = (1...10).map {
            RecommandationDetail(id: $0, poster: "https://via.placeholder.com/150?text=Rec\($0)")
        }

        sections = Observable.just([
            SectionModel(model: "실시간 인기 드라마", items: popularMovies),
            SectionModel(model: "트렌드 영화", items: trendingMovies),
            SectionModel(model: "추천 영화", items: recommendations)
        ])
    }
}

