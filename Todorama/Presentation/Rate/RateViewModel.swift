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
import RealmSwift

final class RateViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    //let databaseRepository: DatabaseRepositoryPr = DatabaseRepository()
    let databaseRepository: DatabaseRepositoryPr = MockRepository()
    private lazy var rateData = BehaviorSubject<Array<Rating>>(value: Array(databaseRepository.fetchAll()))
    private(set) var internalData: InternalData
    struct Input {
        let sortButtonTapped: Observable<Bool?>
    }
    struct Output {
        let sections: Observable<[SectionModel<String, AnyHashable>]>
        let sortChanged: Driver<Void>
    }
    struct InternalData {
        let rateData = PublishSubject<Results<Rating>>()
    }
    init() {
        internalData = InternalData()
    }
    func transform(input: Input) -> Output {
        let sections = rateData.map { data in
            [SectionModel(model: Strings.Global.empty.text, items: data.map { AnyHashable($0) })]}

        input.sortButtonTapped.bind(with: self) { owner, status in
            guard let status else {return}
            owner.sortData(status)
        }.disposed(by: disposeBag)
        let sortChanged = input.sortButtonTapped.map{_ in}
        return Output(sections: sections, sortChanged: sortChanged.asDriver(onErrorJustReturn: ()))
    }
    private func sortData(_ status: Bool) {
        guard let oldData = try? rateData.value() else {return}
        let sortedData = status ? oldData.sorted(by: {$0.rate > $1.rate}) : oldData.sorted(by:{$0.date > $1.date})
        rateData.onNext(sortedData)
    }

}

