//
//  SearchViewModel.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class SearchViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    private(set) var internalData: InternalData
    struct Input {
        let cancelButtonTapped: ControlEvent<Void>
        let searchButtonTapped: Observable<ControlProperty<String>.Element>
    }
    struct Output {
        let sections: Observable<[SectionModel<String, AnyHashable>]>
        let cancelButtonTapped: Driver<Void>
        let errorMessage : Driver<(NetworkError, Bool)>
        let resignKeyboardTrigger: Driver<Void>
    }
    struct InternalData {
        let searchData = PublishSubject<[PopularDetail]>()
        let errorMessageTrigger = PublishSubject<(NetworkError, Bool)>()
        let query = BehaviorSubject<String>(value: "")
        let networkStatus : Observable<Bool>
    }
    init() {
        internalData = InternalData(networkStatus: NetworkMonitor.shared.currentStatus)
    }
    func transform(input: Input) -> Output {
        let sectionData = internalData.searchData
            .map { popularList in
                [SectionModel(model: "", items: popularList.map { AnyHashable($0) })]
            }
        let resignKeyboardTrigger = input.searchButtonTapped
            .map { _ in }
            .asDriver(onErrorDriveWith: .empty())
        
        input.searchButtonTapped.bind(to: internalData.query).disposed(by: disposeBag)
        internalData.query.bind(with: self) { owner, query in
            owner.getSearchData()
        }.disposed(by: disposeBag)
        
        return Output(sections: sectionData, cancelButtonTapped: input.cancelButtonTapped.asDriver(), errorMessage: internalData.errorMessageTrigger.asDriver(onErrorJustReturn: (.customError(code: 000, message: "알수없는 에러"), false)), resignKeyboardTrigger: resignKeyboardTrigger)
    }
    private func getSearchData() {
        guard let query = try? internalData.query.value() else {return}
        NetworkMonitor.shared.startNetworkMonitor()
        internalData.networkStatus.take(1)
            .flatMap{[weak self] isConnected in
                if isConnected {
                    return NetworkManager.shared.callRequest(target: .search(query: query, page: 1), model: Popular.self)
                        .catch { error in
                            if let error = error as? NetworkError {
                                self?.internalData.errorMessageTrigger.onNext((error, isConnected))
                            }
                            return Observable.just(Popular(results: []))
                        }
                } else {
                    self?.internalData.errorMessageTrigger.onNext((.networkError, isConnected))
                    return Observable.just(Popular(results: []))
                }
            }
            .subscribe(with: self) { owner, popular in
                let popularDetail = popular.results

                owner.internalData.searchData.onNext(popularDetail)
                NetworkMonitor.shared.stopNetworkMonitor()
            } onError: { _, error in
                print("search error", error)
            } onDisposed: { _ in
                print("search disposed")
                NetworkMonitor.shared.stopNetworkMonitor()
            }.disposed(by: disposeBag)
    }
}

