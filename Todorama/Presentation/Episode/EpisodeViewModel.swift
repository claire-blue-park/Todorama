//
//  EpisodeViewModel.swift
//  Todorama
//
//  Created by Claire on 3/24/25.
//

import Foundation
import RxCocoa
import RxSwift

final class EpisodeViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    let series: Series
    let season: Int
    let seasonId: Int
    
    init(series: Series, season: Int, seasonId: Int) {
        self.series = series
        self.season = season
        self.seasonId = seasonId
    }
    
    struct Input {
        
    }
    
    struct Output {
        var result: PublishSubject<SeasonDetail>
    }
    
    func transform(input: Input) -> Output {
        let result = PublishSubject<SeasonDetail>()
        
        NetworkManager.shared.callRequest(target: .episode(id: series.id, season: season), model: SeasonDetail.self)
            .share(replay: 1, scope: .whileConnected)
            .subscribe(with: self) { owner, response in
                result.onNext(response)
            }
            .disposed(by: disposeBag)

        return Output(
            result: result
        )
    }
    
}
