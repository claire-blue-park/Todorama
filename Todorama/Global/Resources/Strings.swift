//
//  Strings.swift
//  Todorama
//
//  Created by Claire on 3/20/25.
//

import Foundation

enum Strings {
    
    enum Global {
        case cancel
        case wantToWatch
        case alreadyWatched
        case watching
        case comment
        case rate
        
        var text: String {
            switch self {
            case .cancel:
                "취소"
            case .wantToWatch:
                "보고싶어요"
            case .alreadyWatched:
                "봤어요"
            case .watching:
                "보는중"
            case .comment:
                "코멘트"
            case .rate:
                "별점"
            }
        }
    }
    
    enum NavTitle {
        case archive
        case rate
        case comment
        
        var text: String {
            switch self {
            case .archive:
                "보관함"
            case .rate:
                "별점"
            case .comment:
                "코멘트"
            }
        }
    }
    
    // MARK: - 컬렉션 뷰에 해당하는 섹션 타이틀
    enum SectionTitle {
        case popularDrama
        case similarContents
        case seriesInfo
        case episode
        
        var text: String {
            switch self {
            case .popularDrama:
                "실시간 인기 드라마"
            case .similarContents:
                "와 비슷한 컨텐츠"
            case .seriesInfo:
                "작품정보"
            case .episode:
                "에피소드"
            }
        }
    }
    
    // MARK: - 검색 화면 탭바 타이틀
    enum TabTitle {
        case popular
        case actor
        case tvProgram
        case movie
        
        var text: String {
            switch self {
            case .popular:
                "인기"
            case .actor:
                "배우 및 제작진"
            case .tvProgram:
                " TV 프로그램"
            case .movie:
                "영화"
            }
        }
    }
    
    // MARK: - placeholder
    enum Placeholder {
        case search
        
        var text: String {
            switch self {
            case .search: "원하는 드라마의 제목을 입력해주세요"
            }
        }
    }

    // MARK: - 별점 화면 정렬
    enum Rate {
        case date
        case star
        
        var text: String {
            switch self {
            case .date : "최신순"
            case .star : "별점순"
            }
        }
    }

}
