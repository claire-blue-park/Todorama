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
    let id: Int?
    
    init(id: Int) {
        self.id = id
    }
    
    struct Input {
//        let onViewDidLoad: Observable<Void>
    }
    
    struct Output {
        var result: PublishRelay<Series>
    }
    
    func transform(input: Input) -> Output {
        let result = PublishRelay<Series>()
        
        NetworkManager.shared.callRequest(target: .series(id: self.id ?? -1), model: Series.self)
            .subscribe(with: self) { owner, response in
                result.accept(response)
            }
            .disposed(by: disposeBag)

        return Output(
            result: result
        )
    }
    
//    private func callRequest(id: Int) -> Observable<Series> {
//        return
//    }
}
