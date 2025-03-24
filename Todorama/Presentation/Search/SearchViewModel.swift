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
        let scrollTrigger: Observable<Void>
    }
    struct Output {
        let sections: Observable<[SectionModel<String, AnyHashable>]>
        let cancelButtonTapped: Driver<Void>
        let errorMessage : Driver<(NetworkError, Bool)>
        let resignKeyboardTrigger: Driver<Void>
        let testData: Observable<[PopularDetail]>
    }
    struct InternalData {
        let searchData = BehaviorSubject<[PopularDetail]>(value: [PopularDetail]())
        let errorMessageTrigger = PublishSubject<(NetworkError, Bool)>()
        let query = BehaviorSubject<String>(value: Strings.Global.empty.text)
        let networkStatus : Observable<Bool>

        var total = 0
        var page = 1
        var isEnd = false
    }
    init() {
        internalData = InternalData(networkStatus: NetworkMonitor.shared.currentStatus)
    }
    func transform(input: Input) -> Output {
        let testData = internalData.searchData.asObserver()
        let sectionData = internalData.searchData
            .map { popularList in
                [SectionModel(model: Strings.Global.empty.text, items: popularList.map { AnyHashable($0) })]
            }
        let resignKeyboardTrigger = input.searchButtonTapped
            .map { _ in }
            .asDriver(onErrorDriveWith: .empty())
        
        input.searchButtonTapped.bind(with: self) { owner, newText in
            guard let oldText = try? owner.internalData.query.value(), oldText != newText else {return}
            owner.internalData.query.onNext(newText)
        }.disposed(by: disposeBag)
        
        internalData.query.bind(with: self) { owner, query in
            owner.internalData.page = 1
            owner.internalData.isEnd = false
            owner.getSearchData(page: owner.internalData.page)
        }.disposed(by: disposeBag)

        input.scrollTrigger
            .bind(with: self) { owner, _ in
                if owner.internalData.isEnd == false {
                    owner.internalData.page += 1
                    owner.getSearchData(page: owner.internalData.page)
                }
            }
            .disposed(by: disposeBag)
        return Output(sections: sectionData, cancelButtonTapped: input.cancelButtonTapped.asDriver(), errorMessage: internalData.errorMessageTrigger.asDriver(onErrorJustReturn: (.customError(code: 000, message: "알수없는 에러"), false)), resignKeyboardTrigger: resignKeyboardTrigger, testData: testData)
    }
    private func getSearchData(page: Int) {
        guard let query = try? internalData.query.value() else {return}
        NetworkMonitor.shared.startNetworkMonitor()
        internalData.networkStatus.take(1)
            .flatMap{[weak self] isConnected in
                guard let self = self else {
                    return Observable.just(Popular(results: [], total_pages: 1, page: 1))
                }
                if isConnected {
                    return NetworkManager.shared.callRequest(target: .search(query: query, page: page), model: Popular.self)
                        .catch { error in
                            if let error = error as? NetworkError {
                                self.internalData.errorMessageTrigger.onNext((error, isConnected))
                            }
                            return Observable.just(Popular(results: [], total_pages: 1, page: 1))
                        }
                } else {
                    self.internalData.errorMessageTrigger.onNext((.networkError, isConnected))
                    return Observable.just(Popular(results: [], total_pages: 1, page: 1))
                }
            }
            .subscribe(with: self) { owner, popular in
                if owner.internalData.page > popular.total_pages {
                    owner.internalData.isEnd = true
                    return
                }
                guard var oldData = try? owner.internalData.searchData.value() else {return}
                if owner.internalData.page == 1 {
                    oldData = popular.results
                } else {
                    oldData.append(contentsOf: popular.results)
                }
                owner.internalData.searchData.onNext(oldData)
                NetworkMonitor.shared.stopNetworkMonitor()
            } onError: { _, error in
                print("search error", error)
            } onDisposed: { _ in
                print("search disposed")
                NetworkMonitor.shared.stopNetworkMonitor()
            }.disposed(by: disposeBag)
    }
}

