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
}
