//
//  DatabaseRepository.swift
//  Todorama
//
//  Created by 최정안 on 3/22/25.
//

import Foundation
import Foundation
import RealmSwift

protocol DatabaseRepositoryPr {
    func getFileURL()
    func fetchAll<T: RealmFetchable>() -> Results<T>
    func createItem<T: Object>(data: T)
    func deleteItem<T: RealmFetchable>(itemId: Int, type: T)
}

// ✅ 데이터베이스 저장소 구현
final class DatabaseRepository: DatabaseRepositoryPr {
    
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "파일 경로를 찾을 수 없습니다.")
    }
    
    func fetchAll<T: RealmFetchable>() -> Results<T> {
        return realm.objects(T.self)
    }
    
    func createItem<T: Object>(data: T) {
        do {
            try realm.write {
                realm.add(data, update: .modified)
                /*
                 realm.add(data, update: .modified)를 실행하면
                 객체의 primaryKey(기본 키)를 확인
                 기본 키가 같은 데이터가 이미 Realm에 존재하면 → 업데이트
                 기본 키가 없는 경우 → 새로운 데이터로 추가
                 */
            }
        } catch {
            print("아이템 저장 실패: \(error)")
        }
    }
    
    func deleteItem<T: RealmFetchable>(itemId: Int, type: T) {
        do {
            try realm.write {
                let target = realm.objects(T.self).where { $0.dramaId == itemId}
                realm.delete(target)
            }
        } catch {
            print("아이템 삭제 실패: \(error)")
        }
    }
    
    
    func updateEpisodeIds<T: RealmFetchable>(itemId: Int, newEpisodeIds: [Int], type: T) {
        do {
            try realm.write {
                if let target = realm.objects(T.self).where({ $0.dramaId == itemId }).first as? Watching {
                    target.episodeIds.removeAll() // 기존 리스트 삭제
                    target.episodeIds.append(objectsIn: newEpisodeIds) // 새로운 리스트 추가
                }
            }
        } catch {
            print("리스트 수정 실패: \(error)")
        }
    }
    
}

final class MockRepository: DatabaseRepositoryPr {
    private var mockRatings: [Rating] = []
    private let realm = try! Realm()

    init() {
        generateMockData()
    }

    func getFileURL() {
        print("MockRepository에서는 파일 경로를 제공하지 않습니다.")
    }

    func fetchAll<T: RealmFetchable>() -> Results<T> {
        guard T.self == Rating.self else {
            fatalError("MockRepository는 Rating 타입만 지원합니다.")
        }

        try! realm.write {
            realm.delete(realm.objects(Rating.self))  // 기존 Rating 삭제
            for rating in mockRatings {
                if let existingDrama = realm.object(ofType: Drama.self, forPrimaryKey: rating.dramaId) {
                    let newRating = Rating(drama: existingDrama, rate: rating.rate, posterPath: rating.posterPath)
                    realm.add(newRating)
                }
            }
        }

        return realm.objects(T.self) as! Results<T>
    }

    func createItem<T: Object>(data: T) {
        guard let rating = data as? Rating else {
            print("MockRepository에서는 Rating 타입만 지원합니다.")
            return
        }
        mockRatings.append(rating)
    }

    func deleteItem<T: RealmFetchable>(itemId: Int, type: T) {
        guard type is Rating else {
            print("MockRepository에서는 Rating 타입만 지원합니다.")
            return
        }
        mockRatings.removeAll { $0.dramaId == itemId }
    }

    private func generateMockData() {
        let existingDramas = realm.objects(Drama.self)
        
        if existingDramas.isEmpty {
            // Realm에 Drama 데이터가 없으면 추가
            try! realm.write {
                for id in 1...20 {
                    let drama = Drama(dramaId: id, name: "Drama \(id)", backdropPath: "/path\(id).jpg", genre: id % 5)
                    realm.add(drama)
                }
            }
        }

        // Realm에서 Drama 객체를 가져와서 Rating 생성
        mockRatings = realm.objects(Drama.self).map { drama in
            Rating(drama: drama, rate: Double.random(in: 1.0...10.0), posterPath: "/poster\(drama.dramaId).jpg")
        }
    }
}
