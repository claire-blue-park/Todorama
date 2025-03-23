//
//  CommentViewModel.swift
//  Todorama
//
//  Created by 권우석 on 3/23/25.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

struct CommentItem {
    let id: Int
    let title: String
    let posterPath: String?
    let comment: String
    let synopsis: String // 추가: 줄거리 필드
    let date: Date
    
    // Realm 객체로부터 변환 생성자
    init(from realmComment: Comment) {
        self.id = realmComment.dramaId
        self.title = realmComment.drama?.name ?? "알 수 없는 드라마"
        self.posterPath = realmComment.drama?.backdropPath
        self.comment = realmComment.comment
        self.synopsis = "" // 실제로는 Drama 객체에서 가져와야 함
        self.date = Date() // 실제로는 저장된 날짜 필드 사용 필요
    }
    
    // 더미 데이터 생성용 생성자
    init(id: Int, title: String, posterPath: String?, comment: String, synopsis: String = "", date: Date = Date()) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.comment = comment
        self.synopsis = synopsis
        self.date = date
    }
    
    // 검색어와 일치하는지 확인하는 메서드
    func matches(query: String) -> Bool {
        if query.isEmpty { return true }
        
        let lowercasedQuery = query.lowercased()
        return title.lowercased().contains(lowercasedQuery) ||
               comment.lowercased().contains(lowercasedQuery) ||
               synopsis.lowercased().contains(lowercasedQuery)
    }
}

final class CommentViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    private let repository = DatabaseRepository() // 데이터베이스 접근용
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let searchText: Observable<String>
        let cancelButtonTapped: Observable<Void>
    }
    
    struct Output {
        let comments: Driver<[CommentItem]>
        let isEmpty: Driver<Bool>
        let clearSearchText: Driver<Void>
    }
    
    // MARK: - Input-Output 변환
    func transform(input: Input) -> Output {
        // 1. 검색어 상태 관리
        let searchText = input.searchText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .share()
        
        // 2. 데이터 로드 (뷰 로드 시점 + 검색어 변경 시)
        let initialLoad = input.viewDidLoad.map { "" }
        let searchTextTrigger = Observable.merge(initialLoad, searchText)
        
        // 3. 데이터 흐름 생성 (지금은 목 데이터)
        let commentsRelay = BehaviorRelay<[CommentItem]>(value: [])
        
        // 목 데이터 로드 (실제로는 Realm에서 데이터 로드)
        let mockData = createMockData()
        
        searchTextTrigger
            .map { [weak self] query -> [CommentItem] in
                guard let self = self else { return [] }
                
                // 실제로는 Realm에서 데이터 로드
                // let comments = repository.fetchAll<Comment>()
                
                // 현재는 목 데이터 필터링 - 수정된 부분: 제목, 코멘트, 줄거리 모두 검색
                if query.isEmpty {
                    return mockData
                } else {
                    return mockData.filter { $0.matches(query: query) }
                }
            }
            .bind(to: commentsRelay)
            .disposed(by: disposeBag)
        
        // 4. 결과가 비어있는지 여부
        let isEmpty = commentsRelay
            .map { $0.isEmpty }
            .asDriver(onErrorJustReturn: true)
        
        // 5. 취소 버튼 탭 이벤트
        let clearSearchText = input.cancelButtonTapped
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            comments: commentsRelay.asDriver(),
            isEmpty: isEmpty,
            clearSearchText: clearSearchText
        )
    }
    
    // MARK: - 목 데이터 생성 (추후 Realm 데이터로 대체)
    private func createMockData() -> [CommentItem] {
        return [
            CommentItem(
                id: 1,
                title: "도깨비",
                posterPath: nil,
                comment: "배우들 연기 너무 좋았음. 특히 공유 배우의 연기가 압권이었다. 몰입감 최고인 드라마.",
                synopsis: "불멸의 삶을 끝내기 위해 인간 신부가 필요한 도깨비와 그의 신부가 될 운명을 타고난 소녀의 판타지 로맨스",
                date: Date().addingTimeInterval(-86400 * 5)
            ),
            CommentItem(
                id: 2,
                title: "스트릿맨",
                posterPath: nil,
                comment: "오늘 보고 완전 울었다. 내용이 너무 공감되고 주인공들 친구관계도 너무 보기 좋다.",
                synopsis: "도시의 거리를 지키는 의인들의 이야기",
                date: Date().addingTimeInterval(-86400 * 10)
            ),
            CommentItem(
                id: 3,
                title: "태양의 후예",
                posterPath: nil,
                comment: "OST 듣다가 소름 돋음. 역시 명작은 시간이 지나도 기억에 남는다.",
                synopsis: "전쟁 지역에 파견된 군인과 의사의 사랑 이야기",
                date: Date().addingTimeInterval(-86400 * 15)
            ),
            CommentItem(
                id: 4,
                title: "지옥",
                posterPath: nil,
                comment: "강민혁 멋있다. 긴박감 넘치고 몰입감도 최고였음.",
                synopsis: "지옥행을 선고받은 사람들과 그 현상을 신의 심판이라 믿는 종교단체 새진리회에 관한 이야기",
                date: Date().addingTimeInterval(-86400 * 20)
            ),
            CommentItem(
                id: 5,
                title: "판치",
                posterPath: nil,
                comment: "캐릭터들 케미 너무 좋았다. 그쪽이랑 상관 없으니까 나도 좀 그냥 내버려 둬.",
                synopsis: "가상현실 속 판타지 게임 세계에서 벌어지는 모험",
                date: Date().addingTimeInterval(-86400 * 25)
            ),
            CommentItem(
                id: 6,
                title: "오징어 게임",
                posterPath: nil,
                comment: "너무 웰메이드 한데다 역시 넷플릭스 작품이라 훌륭한 연출과 영상미가 돋보인다.",
                synopsis: "456억 원의 상금이 걸린 의문의 서바이벌 게임에 참가한 사람들이 극한의 도전에 나서며 벌어지는 이야기",
                date: Date().addingTimeInterval(-86400 * 30)
            ),
            CommentItem(
                id: 7,
                title: "슬기로운 의사생활",
                posterPath: nil,
                comment: "평소에 병원에서 의사 선생님들이 어떻게 지내는지 궁금했는데, 이 드라마를 보면서 많이 배우고 느꼈다. 특히 출연진들의 케미가 너무 훌륭했고, 위트와 감동이 잘 어우러진 작품.",
                synopsis: "인생의 축소판이라 불리는 병원에서 평생을 함께한 다섯 친구의 이야기",
                date: Date().addingTimeInterval(-86400 * 35)
            )
        ]
    }
    
    // Realm 데이터 접근 메서드 (추후 구현)
    private func loadCommentsFromRealm() -> [CommentItem] {
        // 실제 구현에서는 Realm에서 Comment 객체와 연결된 Drama 객체를 함께 로드해야 함
        let realmComments = repository.fetchAll() as Results<Comment>
        var commentItems: [CommentItem] = []
        
        for comment in realmComments {
            let item = CommentItem(from: comment)
            commentItems.append(item)
        }
        
        return commentItems
    }
}
