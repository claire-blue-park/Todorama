//
//  CheckButton.swift
//  Todorama
//
//  Created by Claire on 3/25/25.
//

import UIKit
import RealmSwift
import RxCocoa
import RxSwift

final class CheckButton: UIButton {
    private let disposeBag = DisposeBag()

    private let realm = try! Realm()
    private var watchingInfo: Watching3?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSeries(info: Watching3?) {
        self.watchingInfo = info
        updateWatchingButtonState()
    }
    
    private func configureView() {
        tintColor = .tdGray
        setImage(SystemImages.check.image, for: .normal)
        self.rx.tap.subscribe(with: self) { owner, _ in
            owner.onButtonTapped()
        }
        .disposed(by: disposeBag)
    }
    
    private func isWatching() -> Bool {
        guard let watchingInfo else { return false }
        return !realm.objects(Watching2.self).where({ $0.dramaId == watchingInfo.dramaId }).isEmpty
    }
    
    private func writeTable() {
        guard let watchingInfo else { return }
        do {
            let isWatching = isWatching()
            
            try realm.write {
                // 1. 이미 있을 경우 - 에피소드만 제거
                if isWatching {
                    if let existingData = realm.objects(Watching2.self).where({ $0.dramaId == watchingInfo.dramaId }).first {
                        
                        // 1-1. 에피소드가 있을 경우
                        if let index = existingData.episodeIds.index(of: watchingInfo.episodeId) {
                            existingData.episodeIds.remove(at: index)
                        // 1-2. 에피소드가 없을 경우
                        } else {
                            existingData.episodeIds.append(watchingInfo.episodeId)
                        }
                        
                        // 에피소드가 모두 제거 되었을 경우 해당 내용 삭제
                        if existingData.episodeIds.isEmpty {
                            realm.delete(existingData)
                        }
                        
                    }
                // 2. 새로 추가하는 경우
                } else {
                    let data = Watching2(dramaId: watchingInfo.dramaId,
                                         dramaName: watchingInfo.dramaName,
                                         seasonNumber: watchingInfo.seasonNumber,
                                         episodeIds: [watchingInfo.episodeId],
                                         episodeCount: watchingInfo.episodeCount,
                                         stillCutPath: watchingInfo.stillCutPath)
                    realm.add(data)
                }
                
                updateWatchingButtonState()
            }
            print("realm 저장 완료")
            
        } catch {
            print("realm 저장 실패: \(error.localizedDescription)")
        }
        
    }
    
    @objc
    private func onButtonTapped() {
        writeTable()
    }
    
    func updateWatchingButtonState() {
        let isWatching = isWatching()
        tintColor = isWatching ? .tdMain : .tdGray
    }
    
}


