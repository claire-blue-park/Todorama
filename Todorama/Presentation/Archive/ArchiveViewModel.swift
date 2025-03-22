//
//  ArchiveViewModel.swift
//  Todorama
//
//  Created by 권우석 on 3/21/25.
//

import Foundation
import RxSwift
import RxCocoa

// 아카이브 섹션 정의
enum ArchiveSection: Int, CaseIterable {
    case wantToWatch
    case watched
    case watching
    case dailyComment
    
    var title: String {
        switch self {
        case .wantToWatch:
            return "보고싶어요"
        case .watched:
            return "봤어요"
        case .watching:
            return "보는중"
        case .dailyComment:
            return "그날의 코멘트"
        }
    }
}

// 컨텐츠 모델
struct ContentModel: Hashable {
    let id = UUID()
    let title: String
    let category: String
    let imageURL: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ContentModel, rhs: ContentModel) -> Bool {
        return lhs.id == rhs.id
    }
}

// 섹션 데이터 모델
struct ArchiveSectionModel {
    let type: ArchiveSection
    let items: [ContentModel]
}

final class ArchiveViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let sections: Driver<[ArchiveSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        
        // 보고싶어요 섹션 데이터
        let wantToWatchContents = [
            ContentModel(title: "복덕 속 김수덕", category: "드라마", imageURL: "drama1"),
            ContentModel(title: "검성의 기록", category: "액션", imageURL: "drama2"),
            ContentModel(title: "눈트레이", category: "판타지", imageURL: "drama3")
        ]
        
        // 봤어요 섹션 데이터
        let watchedContents = [
            ContentModel(title: "먼데서 김부무", category: "로맨스", imageURL: "drama4"),
            ContentModel(title: "멸렐보라 공주의 궁전", category: "사극", imageURL: "drama5"),
            ContentModel(title: "새그럼 가든", category: "로맨스", imageURL: "drama6")
        ]
        
        // 보는중 섹션 데이터
        let watchingContents = [
            ContentModel(title: "별편 숲", category: "드라마", imageURL: "drama7"),
            ContentModel(title: "스타디움", category: "드라마", imageURL: "drama8"),
            ContentModel(title: "스타디움 스콜피어", category: "드라마", imageURL: "drama9")
        ]
        
        // 그날의 코멘트 섹션 데이터
        let commentContents = [
            ContentModel(title: "낭만궁사", category: "드라마", imageURL: "drama10"),
            ContentModel(title: "최후의 심판", category: "액션", imageURL: "drama11"),
            ContentModel(title: "비상과 아수라", category: "스릴러", imageURL: "drama12")
        ]
        
        // 섹션 모델 생성
        let sectionModels = [
            ArchiveSectionModel(type: .wantToWatch, items: wantToWatchContents),
            ArchiveSectionModel(type: .watched, items: watchedContents),
            ArchiveSectionModel(type: .watching, items: watchingContents),
            ArchiveSectionModel(type: .dailyComment, items: commentContents)
        ]
        
        // 데이터 스트림 생성
        let sections = input.viewDidLoad
            .map { sectionModels }
            .asDriver(onErrorJustReturn: [])
        
        return Output(sections: sections)
    }
}
