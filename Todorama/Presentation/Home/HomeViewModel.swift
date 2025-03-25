//
//  HomeViewModel.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    private(set) var internalData: InternalData
    let headerTitle = [Strings.SectionTitle.popularDrama.text, Strings.SectionTitle.similarContents.text]
    struct Input {
        let callRequestTrigger: Observable<Void>
    }
    struct Output {
        let sections: Observable<[SectionModel<String, AnyHashable>]>
        let errorMessage: Driver<(NetworkError, Bool)>
    }
    struct InternalData {
        let popularData = PublishSubject<[PopularDetail]>()
        let trendData = PublishSubject<[TrendDetail]>()
        let recommendData = PublishSubject<[RecommendationDetail]>()
        let targetRecommendItemName = PublishSubject<String>()
        let errorMessageTrigger = PublishSubject<(NetworkError, Bool)>()
        let networkStatus : Observable<Bool>
    }
    init() {
        internalData = InternalData(networkStatus: NetworkMonitor.shared.currentStatus)
    }
    func transform(input: Input) -> Output {
        getPopularData()
        getTrendData()
        
        input.callRequestTrigger.bind(with: self) { owner, _ in
            owner.getPopularData()
            owner.getTrendData()
        }.disposed(by: disposeBag)
        
        let sections = getSectionData()
        
        return Output(sections: sections, errorMessage: internalData.errorMessageTrigger.asDriver(onErrorJustReturn: (.customError(code: 000, message: Strings.Global.customError(code: 000).text), false)))
    }
    private func getSectionData() -> Observable<[SectionModel<String, AnyHashable>]> {
        
        let headerTitle = BehaviorSubject<[String]>(value: [Strings.SectionTitle.popularDrama.text, Strings.SectionTitle.similarContents.text])
        
        internalData.targetRecommendItemName
            .map { text in
                [Strings.SectionTitle.popularDrama.text, text + Strings.SectionTitle.similarContents.text]
            }
            .bind(to: headerTitle)
            .disposed(by: disposeBag)

        let popularData = internalData.popularData.map { popularList in
            [SectionModel(model: Strings.Global.empty.text, items: popularList.map { AnyHashable($0) })]
        }
        let trendData = Observable.combineLatest(internalData.trendData, headerTitle)
            .map { trendList, titles in
                [SectionModel(model: titles[0], items: trendList.map { AnyHashable($0) })]
            }
        
        let recommendData = Observable.combineLatest(internalData.recommendData, headerTitle)
            .map { recommendList, titles in
                [SectionModel(model: titles[1], items: recommendList.map { AnyHashable($0) })]
            }
        
        let sections: Observable<[SectionModel<String, AnyHashable>]> = Observable.combineLatest(popularData, trendData, recommendData) { popular, trend, recommend in
            return popular + trend + recommend
        }
        return sections
    }
    private func getPopularData(){
        NetworkMonitor.shared.startNetworkMonitor()
        internalData.networkStatus.take(1)
            .flatMap{[weak self] isConnected in
                if isConnected {
                    return NetworkManager.shared.callRequest(target: .popular, model: Popular.self)
                        .catch { error in
                            if let error = error as? NetworkError {
                                self?.internalData.errorMessageTrigger.onNext((error, isConnected))
                            }
                            return Observable.just(Popular(results: [], total_pages: 1, page: 1))
                        }
                } else {
                    self?.internalData.errorMessageTrigger.onNext((.networkError, isConnected))
                    return Observable.just(Popular(results: [], total_pages: 1, page: 1))
                }
            }
            .subscribe(with: self) { owner, popular in
                let popularDetail = popular.results
                let itemCount = min(popularDetail.count, 10)
                let result = Array(popularDetail.prefix(itemCount))
                owner.internalData.popularData.onNext(result)
                NetworkMonitor.shared.stopNetworkMonitor()
            } onError: { _, error in
                print("popular error", error)
            } onDisposed: { _ in
                print("popular disposed")
                NetworkMonitor.shared.stopNetworkMonitor()
            }.disposed(by: disposeBag)
    }
    private func getTrendData() {
        NetworkMonitor.shared.startNetworkMonitor()
        internalData.networkStatus.take(1)
            .flatMap{[weak self] isConnected in
                if isConnected {
                    return NetworkManager.shared.callRequest(target: .trending, model: Trend.self)
                        .catch { error in
                            if let error = error as? NetworkError {
                                self?.internalData.errorMessageTrigger.onNext((error, isConnected))
                            }
                            return Observable.just(Trend(results: []))
                        }
                } else {
                    self?.internalData.errorMessageTrigger.onNext((.networkError, isConnected))
                    return Observable.just(Trend(results: []))
                }
            }
            .subscribe(with: self) { owner, trend in
                let trendDetail = trend.results
                let itemCount = min(trendDetail.count, 10)
                let result = Array(trendDetail.prefix(itemCount))
                owner.internalData.trendData.onNext(result)
                if let targetRecommendItem = result.first {
                    owner.getRecommendationData(targetRecommendItem.id)
                    owner.internalData.targetRecommendItemName.onNext(targetRecommendItem.name)
                }
                NetworkMonitor.shared.stopNetworkMonitor()
            } onError: { _, error in
                print("trend error", error)
            } onDisposed: { _ in
                print("trend disposed")
                NetworkMonitor.shared.stopNetworkMonitor()
            }.disposed(by: disposeBag)
    }
    private func getRecommendationData(_ targetID: Int) {
        NetworkMonitor.shared.startNetworkMonitor()
        internalData.networkStatus.take(1)
            .flatMap{[weak self] isConnected in
                if isConnected {
                    return NetworkManager.shared.callRequest(target: .recommendation(id: targetID), model: Recommendation.self)
                        .catch { error in
                            if let error = error as? NetworkError {
                                self?.internalData.errorMessageTrigger.onNext((error, isConnected))
                            }
                            return Observable.just(Recommendation(results: []))
                        }
                } else {
                    self?.internalData.errorMessageTrigger.onNext((.networkError, isConnected))
                    return Observable.just(Recommendation(results: []))
                }
            }
            .subscribe(with: self) { owner, recommendation in
                let recommendationDetail = recommendation.results
                let itemCount = min(recommendationDetail.count, 10)
                let result = Array(recommendationDetail.prefix(itemCount))
                owner.internalData.recommendData.onNext(result)
                NetworkMonitor.shared.stopNetworkMonitor()
            } onError: { _, error in
                print("recommendation error", error)
            } onDisposed: { _ in
                print("recommendation disposed")
                NetworkMonitor.shared.stopNetworkMonitor()
            }.disposed(by: disposeBag)
    }
}

