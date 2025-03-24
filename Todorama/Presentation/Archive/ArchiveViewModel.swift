//
//  ArchiveViewModel.swift
//  Todorama
//
//  Created by 권우석 on 3/21/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

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
struct ContentModel: Hashable, BackDropModel, IdentifiableModel {
    let id: Int  // TMDB API에서 사용하는 드라마/영화 ID
    let title: String
    let category: String
    let imageURL: String
    let progress: Float
    
    // BackDropModel 프로토콜 구현
    var name: String { return title }
    var genre_ids: [Int] {
        // category(장르 이름)로부터 genre_id를 찾는 로직
        let genreManager = GenreManager.shared
        
        // GenreManager의 genres 딕셔너리를 순회하면서
        // category와 일치하는 장르 이름을 가진 ID를 찾습니다
        for (id, genreName) in genreManager.genres {
            if genreName == category {
                return [id]
            }
        }
        
        // 일치하는 장르가 없으면 기본값(드라마: 18) 반환
        return [00]
    }
    var backdrop_path: String? { return imageURL }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ContentModel, rhs: ContentModel) -> Bool {
        return lhs.id == rhs.id
    }
}

// RxDataSources와 호환되는 섹션 모델
typealias ArchiveSectionModel = SectionModel<ArchiveSection, ContentModel>

final class ArchiveViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let repository = DatabaseRepository()
    
    // 섹션별 카운트 값을 저장할 BehaviorRelay
    private let wishListCount = BehaviorRelay<Int>(value: 0)
    private let watchingCount = BehaviorRelay<Int>(value: 0)
    private let watchedCount = BehaviorRelay<Int>(value: 0)
    private let commentCount = BehaviorRelay<Int>(value: 0)
    private let rateCount = BehaviorRelay<Int>(value: 0)
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let sections: Driver<[ArchiveSectionModel]>
        let wishListCount: Driver<Int>
        let watchingCount: Driver<Int>
        let watchedCount: Driver<Int>
        let commentCount: Driver<Int>
        let rateCount: Driver<Int>
    }
    
    func transform(input: Input) -> Output {
        
        // Realm에서 데이터 가져오기
        let wishListItems = input.viewDidLoad.flatMap { [weak self] _ -> Observable<[ContentModel]> in
            guard let self = self else { return Observable.just([]) }
            return self.fetchWishListItems()
        }
        
        let watchedItems = input.viewDidLoad.flatMap { [weak self] _ -> Observable<[ContentModel]> in
            guard let self = self else { return Observable.just([]) }
            return self.fetchWatchedItems()
        }
        
        let watchingItems = input.viewDidLoad.flatMap { [weak self] _ -> Observable<[ContentModel]> in
            guard let self = self else { return Observable.just([]) }
            return self.fetchWatchingItems()
        }
        
        let commentItems = input.viewDidLoad.flatMap { [weak self] _ -> Observable<[ContentModel]> in
            guard let self = self else { return Observable.just([]) }
            return self.fetchCommentItems()
        }
        
        let rateItems = input.viewDidLoad.flatMap { [weak self] _ -> Observable<[ContentModel]> in
            guard let self = self else { return Observable.just([]) }
            return self.fetchRateItems()
        }
        
        // 각 항목의 카운트 업데이트
        wishListItems
            .map { $0.count }
            .bind(to: wishListCount)
            .disposed(by: disposeBag)
        
        watchedItems
            .map { $0.count }
            .bind(to: watchedCount)
            .disposed(by: disposeBag)
        
        watchingItems
            .map { $0.count }
            .bind(to: watchingCount)
            .disposed(by: disposeBag)
        
        commentItems
            .map { $0.count }
            .bind(to: commentCount)
            .disposed(by: disposeBag)
        
        rateItems
            .map { $0.count }
            .bind(to: rateCount)
            .disposed(by: disposeBag)
        
        
        // 섹션 데이터 결합
        let sectionModels = Observable.combineLatest(
            wishListItems, watchedItems, watchingItems, commentItems
        ) { wishList, watched, watching, comments in
            return [
                SectionModel<ArchiveSection, ContentModel>(model: .wantToWatch, items: wishList),
                SectionModel<ArchiveSection, ContentModel>(model: .watched, items: watched),
                SectionModel<ArchiveSection, ContentModel>(model: .watching, items: watching),
                SectionModel<ArchiveSection, ContentModel>(model: .dailyComment, items: comments)
            ]
        }.asDriver(onErrorJustReturn: [])
        
        return Output(
            sections: sectionModels,
            wishListCount: wishListCount.asDriver(),
            watchingCount: watchingCount.asDriver(),
            watchedCount: watchedCount.asDriver(),
            commentCount: commentCount.asDriver(),
            rateCount: rateCount.asDriver()
        )
    }
    
    // WishList 항목 가져오기
    private func fetchRateItems() -> Observable<[ContentModel]> {
        let ratingItems = repository.fetchAll() as Results<Rating>
        
        var contentModels: [ContentModel] = []
        for item in ratingItems {
            if let drama = item.drama {
                contentModels.append(ContentModel(
                    id: drama.dramaId,
                    title: drama.name,
                    category: GenreManager.shared.getGenre(drama.genre) ?? Strings.Global.empty.text,
                    imageURL: drama.backdropPath,
                    progress: 0.0  // 별점은 진행률 표시 안함
                ))
            }
        }
        
        // 데이터가 없으면 목 데이터 반환 - 실제 TMDB ID 사용
        if contentModels.isEmpty {
            contentModels = [
                ContentModel(id: 1399, title: "왕좌의 게임", category: "드라마", imageURL: "/abcdef", progress: 0.0),
                ContentModel(id: 71912, title: "엘리멘탈", category: "애니메이션", imageURL: "/ghijkl", progress: 0.0),
                ContentModel(id: 94605, title: "월요일이 사라졌다", category: "스릴러", imageURL: "/mnopqr", progress: 0.0)
            ]
        }
        
        return Observable.just(contentModels)
    }
    
    private func fetchWishListItems() -> Observable<[ContentModel]> {
        let wishListItems = repository.fetchAll() as Results<WishList>
        
        // Results를 ContentModel 배열로 변환
        var contentModels: [ContentModel] = []
        for item in wishListItems {
            if let drama = item.drama {
                contentModels.append(ContentModel(
                    id: drama.dramaId,
                    title: drama.name,
                    category: GenreManager.shared.getGenre(drama.genre) ?? Strings.Global.empty.text,
                    imageURL: drama.backdropPath,
                    progress: 0.0
                ))
            }
        }
        
        // 데이터가 없으면 목 데이터 반환 - 실제 TMDB ID 사용
        if contentModels.isEmpty {
            contentModels = [
                ContentModel(id: 84958, title: "복덕 속 김수덕", category: "드라마", imageURL: "/qwertyuiop", progress: 0.0),
                ContentModel(id: 71446, title: "검성의 기록", category: "액션", imageURL: "/asdfghjkl", progress: 0.0),
                ContentModel(id: 76669, title: "눈트레이", category: "판타지", imageURL: "/zxcvbnm", progress: 0.0)
            ]
        }
        
        return Observable.just(contentModels)
    }
    
    // Watched 항목 가져오기
    private func fetchWatchedItems() -> Observable<[ContentModel]> {
        let watchedItems = repository.fetchAll() as Results<Watched>
        
        var contentModels: [ContentModel] = []
        for item in watchedItems {
            if let drama = item.drama {
                contentModels.append(ContentModel(
                    id: drama.dramaId,
                    title: drama.name,
                    category: GenreManager.shared.getGenre(drama.genre) ?? Strings.Global.empty.text,
                    imageURL: drama.backdropPath,
                    progress: 1.0  // 완료된 항목은 진행률 100%
                ))
            }
        }
        
        // 데이터가 없으면 목 데이터 반환 - 실제 TMDB ID 사용
        if contentModels.isEmpty {
            contentModels = [
                ContentModel(id: 63174, title: "먼데서 김부무", category: "로맨스", imageURL: "/poiuyt", progress: 1.0),
                ContentModel(id: 90462, title: "멸렐보라 공주의 궁전", category: "사극", imageURL: "/lkjhg", progress: 1.0),
                ContentModel(id: 79242, title: "새그럼 가든", category: "로맨스", imageURL: "/mnbvc", progress: 1.0)
            ]
        }
        
        return Observable.just(contentModels)
    }
    
    // Watching 항목 가져오기 (진행 상황 포함)
    private func fetchWatchingItems() -> Observable<[ContentModel]> {
        let watchingItems = repository.fetchAll() as Results<Watching>
        
        var contentModels: [ContentModel] = []
        for item in watchingItems {
            if let drama = item.drama {
                // 에피소드 시청 진행률 계산
                let progress = Float(item.episodeIds.count) / Float(item.episodeCount)
                
                contentModels.append(ContentModel(
                    id: drama.dramaId,
                    title: drama.name,
                    category: GenreManager.shared.getGenre(drama.genre) ?? Strings.Global.empty.text,
                    imageURL: drama.backdropPath,
                    progress: progress
                ))
            }
        }
        
        // 데이터가 없으면 목 데이터 반환 - 실제 TMDB ID 사용
        if contentModels.isEmpty {
            contentModels = [
                ContentModel(id: 66732, title: "별편 숲", category: "드라마", imageURL: "/xswdc", progress: 0.3),
                ContentModel(id: 1396, title: "스타디움", category: "드라마", imageURL: "/vfrtg", progress: 0.7),  // 브레이킹 배드 실제 ID
                ContentModel(id: 92783, title: "스타디움 스콜피어", category: "드라마", imageURL: "/bnhyu", progress: 0.5)
            ]
        }
        
        return Observable.just(contentModels)
    }
    
    // Comment 항목 가져오기
    private func fetchCommentItems() -> Observable<[ContentModel]> {
        let commentItems = repository.fetchAll() as Results<Comment>
        
        var contentModels: [ContentModel] = []
        for item in commentItems {
            if let drama = item.drama {
                contentModels.append(ContentModel(
                    id: drama.dramaId,
                    title: drama.name,
                    category: GenreManager.shared.getGenre(drama.genre) ?? Strings.Global.empty.text,
                    imageURL: drama.backdropPath,
                    progress: 0.0  // 코멘트는 진행률 표시 안함
                ))
            }
        }
        
        // 데이터가 없으면 목 데이터 반환 - 실제 TMDB ID 사용
        if contentModels.isEmpty {
            contentModels = [
                ContentModel(id: 93405, title: "낭만궁사", category: "드라마", imageURL: "/okmijn", progress: 0.0),
                ContentModel(id: 100088, title: "최후의 심판", category: "액션", imageURL: "/plokij", progress: 0.0),
                ContentModel(id: 72879, title: "비상과 아수라", category: "스릴러", imageURL: "/uhbygv", progress: 0.0)
            ]
        }
        
        return Observable.just(contentModels)
    }
}
