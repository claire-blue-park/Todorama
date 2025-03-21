//
//  RateViewModel.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class RateViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    struct Input {
        let sortButtonTapped: ControlEvent<Void>
    }
    struct Output {
        let sections: Observable<[SectionModel<String, AnyHashable>]>
        let sortChanged: Driver<Void>
    }
    func transform(input: Input) -> Output {
        
        let popularMovies: [PopularDetail] = (1...20).map {
            PopularDetail(id: $0, poster: "https://via.placeholder.com/150?text=Popular\($0)")
        }
        let sections: Observable<[SectionModel<String, AnyHashable>]> = Observable.just([
            SectionModel(model: "실시간 인기 드라마", items: popularMovies)
        ])
        
        input.sortButtonTapped.bind(with: self) { owner, _ in
            owner.sortData()
        }.disposed(by: disposeBag)
        return Output(sections: sections, sortChanged: input.sortButtonTapped.asDriver())
    }
    private func sortData() {
        // sortData
    }

}

