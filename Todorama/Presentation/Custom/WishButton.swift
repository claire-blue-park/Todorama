//
//  WishButton.swift
//  Todorama
//
//  Created by Claire on 3/25/25.
//

import UIKit
import RealmSwift
import RxCocoa
import RxSwift

//final class WishButton: Object {
//    @Persisted(primaryKey: true) var id:  ObjectId
//    @Persisted(indexed: true) var itemId: Int
//    
//    convenience init(itemId: Int) {
//        self.init()
//        self.itemId = itemId
//    }
//}

final class WishButton: UIButton {
    private let disposeBag = DisposeBag()

    private let realm = try! Realm()
    private var series: Series?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSeries(series: Series) {
        self.series = series
        updateWishButtonState()
    }
    
    private func configureView() {
        tintColor = .tdMain
        self.rx.tap.subscribe(with: self) { owner, _ in
            owner.onButtonTapped()
        }
        .disposed(by: disposeBag)
    }
    
    private func isWished() -> Bool {
        guard let series else { return false }
        return !realm.objects(Drama.self).where({ $0.dramaId == series.id }).isEmpty
    }
    
    private func writeTable() {
        guard let series else { return }
        do {
            let isWished = isWished()
            
            try realm.write {
                // 1. 이미 있을 경우
                if isWished {
                    if let oldData = realm.objects(Drama.self).where({ $0.dramaId == series.id }).first {
                        realm.delete(oldData)
                    }
                // 2. 새로 추가하는 경우
                } else {
                    let genre = series.genres.first?.id ?? 00
                    let data = Drama(dramaId: series.id, name: series.name, backdropPath: series.backdrop_path ?? Strings.Global.empty.text, genre: genre)
                    realm.add(data)
                }
                
                updateWishButtonState()
                
//                NotificationCenter.default.post(name: .interestNoti,
//                                                object: nil)
            }
            print("realm 저장 완료")
            
        } catch {
            print("realm 저장 실패: \(error.localizedDescription)")
        }
        
    }
    
    @objc
    private func onButtonTapped() {
        writeTable()
//        NotificationCenter.default.post(name: .interestNoti, object: nil, userInfo: nil)
    }
    
    func updateWishButtonState() {
        let isWished = isWished()
        let wishImage = isWished ? SystemImages.heart.image : SystemImages.heartLine.image
        setImage(wishImage, for: .normal)
    }
    
}


