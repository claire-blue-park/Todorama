//
//  SeriesViewModel.swift
//  Todorama
//
//  Created by Claire on 3/23/25.
//

import Foundation
import RxCocoa
import RxSwift

final class SeriesViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    struct Input {
   
    }
    
    struct Output {
        let result: Observable<Series>
        let homepage: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let result = NetworkManager.shared.callRequest(target: .series(id: self.id), model: Series.self)
            .share(replay: 1, scope: .whileConnected)

        let networkDetail = result
            .flatMapLatest { series -> Observable<NetworkDetail> in
                guard let networkId = series.networks.first?.id else {
                    return .just(NetworkDetail(id: -1, homepage: "", logo_path: "", name: "", origin_country: ""))
                }
                return NetworkManager.shared.callRequest(target: .network(id: networkId), model: NetworkDetail.self)
            }
            .share(replay: 1, scope: .whileConnected)
        
        let homepage = networkDetail
            .map { $0.homepage }
            .catchAndReturn("https://www.google.com") // 에러 발생 시
        
        return Output(
            result: result,
            homepage: homepage
        )
    }
}
