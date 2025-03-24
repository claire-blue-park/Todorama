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
    
    let id: Int
    let season: Int
    
    init(id: Int, season: Int) {
        self.id = id
        self.season = season
    }
    
    struct Input {
        
    }
    
    struct Output {
        var result: PublishSubject<SeasonDetail>
    }
    
    func transform(input: Input) -> Output {
        let result = PublishSubject<SeasonDetail>()
        
        NetworkManager.shared.callRequest(target: .episode(id: id, season: season), model: SeasonDetail.self)
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
