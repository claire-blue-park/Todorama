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

class HomeViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    let headerTitle = [Strings.SectionTitle.popularDrama.text, Strings.SectionTitle.similarContents.text]
    struct Input {
        
    }
    struct Output {
        let sections: Observable<[SectionModel<String, AnyHashable>]>
    }
    func transform(input: Input) -> Output {
        let popularMovies: [PopularDetail] = (1...10).map {
            PopularDetail(id: $0, poster: "https://via.placeholder.com/150?text=Popular\($0)")
        }
        
        let trendingMovies: [TrendDetail] = (1...10).map {
            TrendDetail(id: $0,
                        backdrop_path: "https://via.placeholder.com/300x150?text=Trend\($0)",
                        name: "트렌드 영화 \($0)",
                        genre_ids: [28, 12, 16]) // 예시로 액션, 모험, 애니메이션
        }
        
        let recommendations: [RecommendationDetail] = (1...10).map {
            RecommendationDetail(id: $0, poster: "https://via.placeholder.com/150?text=Rec\($0)")
        }

        let sections: Observable<[SectionModel<String, AnyHashable>]> = Observable.just([
            SectionModel(model: "", items: popularMovies),
            SectionModel(model: headerTitle[0], items: trendingMovies),
            SectionModel(model: headerTitle[1], items: recommendations)
        ])
        return Output(sections: sections)
    }

}

