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
    }
    struct Output {
        let sections: Observable<[SectionModel<String, AnyHashable>]>
        let cancelButtonTapped: Driver<Void>
        let errorMessage : Driver<(NetworkError, Bool)>
    }
    struct InternalData {
        let searchData = PublishSubject<[PopularDetail]>()
        let errorMessageTrigger = PublishSubject<(NetworkError, Bool)>()
        //let query : BehaviorSubject<String>
        let networkStatus : Observable<Bool>
    }
    init() {
        internalData = InternalData(networkStatus: NetworkMonitor.shared.currentStatus)
    }
    func transform(input: Input) -> Output {
        getSearchData()

        let sectionData = internalData.searchData
            .map { popularList in
                [SectionModel(model: "실시간 인기 드라마", items: popularList.map { AnyHashable($0) })]
            }
        return Output(sections: sectionData, cancelButtonTapped: input.cancelButtonTapped.asDriver(), errorMessage: internalData.errorMessageTrigger.asDriver(onErrorJustReturn: (.customError(code: 000, message: "알수없는 에러"), false)))
    }
    private func getSearchData() {
        NetworkMonitor.shared.startNetworkMonitor()
        internalData.networkStatus.take(1)
            .flatMap{[weak self] isConnected in
                if isConnected {
                    return NetworkManager.shared.callRequest(target: .search(query: "바람", page: 1), model: Popular.self)
                        .catch { error in
                            
                            if let error = error as? NetworkError {
                                //error가 NetworkError 타입인 경우
                                self?.internalData.errorMessageTrigger.onNext((error, isConnected))
                                // NetworkError중 해당 error와 network가 연결 된 상태인지 전달
                            }
                            return Observable.just(Popular(results: []))
                        }
                } else {
                    // 네트워크가 끊긴 경우
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

