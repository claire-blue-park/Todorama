//
//  SearchViewModel.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class SearchViewModel {
    let sections: Observable<[SectionModel<String, AnyHashable>]>

    init() {
        let popularMovies: [PopularDetail] = (1...20).map {
            PopularDetail(id: $0, poster: "https://via.placeholder.com/150?text=Popular\($0)")
        }
        sections = Observable.just([
            SectionModel(model: "실시간 인기 드라마", items: popularMovies)
        ])
    }
}

