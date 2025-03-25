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
        
        if let existingData = realm.objects(Watching2.self).where({ $0.seasonId == watchingInfo.seasonId }).first {
            return existingData.episodeIds.contains(watchingInfo.episodeId)
        }
        return false
    }
    
    private func writeTable() {
        guard let watchingInfo else { return }
        do {
            let isWatching = isWatching()
            
            try realm.write {
                // 1. 이미 있을 경우 - 에피소드만 제거
                if let existingData = realm.objects(Watching2.self).where({ $0.seasonId == watchingInfo.seasonId }).first {
                    if isWatching {
                        // 1-1. 에피소드가 있을 경우 - 제거
                        if let index = existingData.episodeIds.index(of: watchingInfo.episodeId) {
                            existingData.episodeIds.remove(at: index)
                        }
                    } else {
                        // 1-2. 에피소드가 없을 경우 - 추가
                        existingData.episodeIds.append(watchingInfo.episodeId)
                    }
                    
                    // 에피소드가 모두 제거되었을 경우 해당 객체 삭제
                    if existingData.episodeIds.isEmpty {
                        realm.delete(existingData)
                    }
                } else {
                    // 2. 새로 추가하는 경우
                    let data = Watching2(seasonId: watchingInfo.seasonId,
                                         dramaId: watchingInfo.dramaId,
                                         dramaName: watchingInfo.dramaName,
                                         episodeIds: [watchingInfo.episodeId],
                                         episodeCount: watchingInfo.episodeCount,
                                         stillCutPath: watchingInfo.stillCutPath)
                    realm.add(data)
                }
                
                print("Realm 파일 경로: \(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "경로 없음")")
                
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


