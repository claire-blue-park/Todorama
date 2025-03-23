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

    }
    
    struct Output {
        var result: PublishSubject<Series>
    }
    
    func transform(input: Input) -> Output {
        let result = PublishSubject<Series>()
        
        NetworkManager.shared.callRequest(target: .series(id: self.id ?? -1), model: Series.self)
            .subscribe(with: self) { owner, response in
                result.onNext(response)
            }
            .disposed(by: disposeBag)

        return Output(
            result: result
        )
    }
    
}
