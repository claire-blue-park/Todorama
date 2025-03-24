# 📺 Todorama

**TMDB API 기반 드라마 정보 및 개인 시청 기록 관리 앱**

## 📋 목차

- [프로젝트 소개](https://claude.ai/chat/3d087d28-1546-45cb-85e8-75cca04fccdb#%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EC%86%8C%EA%B0%9C)
- [주요 기능](https://claude.ai/chat/3d087d28-1546-45cb-85e8-75cca04fccdb#%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5)
- [프로젝트 구조](https://claude.ai/chat/3d087d28-1546-45cb-85e8-75cca04fccdb#%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EA%B5%AC%EC%A1%B0)
- [기술 스택](https://claude.ai/chat/3d087d28-1546-45cb-85e8-75cca04fccdb#%EA%B8%B0%EC%88%A0-%EC%8A%A4%ED%83%9D)
- [주요 구현 내용](https://claude.ai/chat/3d087d28-1546-45cb-85e8-75cca04fccdb#%EC%A3%BC%EC%9A%94-%EA%B5%AC%ED%98%84-%EB%82%B4%EC%9A%A9)
- [협업 방식](https://claude.ai/chat/3d087d28-1546-45cb-85e8-75cca04fccdb#%ED%98%91%EC%97%85-%EB%B0%A9%EC%8B%9D)
- [트러블슈팅](https://claude.ai/chat/3d087d28-1546-45cb-85e8-75cca04fccdb#%ED%8A%B8%EB%9F%AC%EB%B8%94%EC%8A%88%ED%8C%85)

## 프로젝트 소개

Todorama는 TMDB API를 활용하여 드라마 정보(트렌딩, 시즌, 에피소드 등)를 제공하고, 사용자의 드라마 시청 여부, 별점, 코멘트를 관리할 수 있는 앱입니다. 사용자는 원하는 드라마를 검색하고 시즌별로 둘러볼 수 있으며, 개인 보관함에서 자신의 시청 기록, 코멘트, 별점을 확인할 수 있습니다.

## 💫 주요 기능

- **드라마 탐색**: 실시간 인기 드라마, 트렌딩 드라마 정보 제공
- **상세 정보 확인**: 드라마 시즌, 에피소드 정보, 줄거리 등 상세 정보 제공
- **검색 기능**: 드라마 제목, 줄거리, 코멘트를 통한 검색 기능
- **개인 보관함**: '보고싶어요', '보는중', '봤어요' 카테고리를 통한 개인 시청 상태 관리
- **코멘트 & 별점**: 드라마에 대한 개인 코멘트 작성 및 별점 부여

## 🛠 기술 스택

- **언어 및 프레임워크**: Swift, UIKit
- **아키텍처**: MVVM + RxSwift Input/Output 패턴
- **UI 레이아웃**: SnapKit
- **네트워크 통신**: Alamofire
- **비동기 프로그래밍**: RxSwift, RxCocoa, RxDataSources
- **이미지 처리**: Kingfisher
- **로컬 데이터베이스**: RealmSwift
- **협업 및 버전 관리**: GitHub Flow, Issue 기반 브랜치 관리

## 프로젝트 구조

```
Todorama/
├── Models/
│   ├── API Models/ (TMDB API 응답 모델)
│   │   ├── Series.swift
│   │   ├── Episode.swift
│   │   ├── Popular.swift
│   │   └── ...
│   ├── Realm Models/ (로컬 데이터 모델)
│   │   ├── WishList.swift
│   │   ├── Watching.swift
│   │   ├── Watched.swift
│   │   ├── Comment.swift
│   │   └── Rating.swift
│   └── Protocol/ (모델 관련 프로토콜)
│       ├── IdentifiableModel.swift
│       ├── BackDropModel.swift
│       └── ...
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── ArchiveViewModel.swift
│   ├── SearchViewModel.swift
│   ├── CommentViewModel.swift
│   ├── RateViewModel.swift
│   └── ...
├── Views/
│   ├── Controllers/
│   │   ├── TabBarController.swift
│   │   ├── HomeViewController.swift
│   │   ├── ArchiveViewController.swift
│   │   ├── SearchViewController.swift
│   │   ├── SeriesViewController.swift
│   │   └── ...
│   ├── Cells/
│   │   ├── PosterCollectionViewCell.swift
│   │   ├── BackdropCollectionViewCell.swift
│   │   ├── CommentTableViewCell.swift
│   │   └── ...
│   └── Common/
│       ├── SectionHeaderView.swift
│       ├── CountButton.swift
│       └── ...
├── Utils/
│   ├── Extensions/
│   │   ├── UIImage+.swift
│   │   ├── UILabel+.swift
│   │   ├── Cell+.swift
│   │   └── ...
│   ├── Constants/
│   │   ├── Fonts.swift
│   │   ├── Strings.swift
│   │   ├── SystemImages.swift
│   │   └── ...
│   └── Helpers/
│       ├── DateFormatHelper.swift
│       ├── GenreManager.swift
│       └── ...
└── Services/
    ├── Network/
    │   ├── NetworkManager.swift
    │   ├── NetworkMonitor.swift
    │   ├── TMDBRequest.swift
    │   └── NetworkError.swift
    └── Database/
        └── DatabaseRepository.swift

```

## 🔍 주요 구현 내용

### 1. MVVM + RxSwift Input/Output 패턴

모든 ViewModel은 `BaseViewModel` 프로토콜을 준수하여 일관된 아키텍처를 유지했습니다.

```swift
protocol BaseViewModel {
    var disposeBag: DisposeBag { get }

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

```

각 ViewModel은 이 패턴을 준수하여 뷰와 비즈니스 로직을 명확히 분리했습니다.

```swift
// HomeViewModel 예시
class HomeViewModel: BaseViewModel {
    var disposeBag = DisposeBag()

    struct Input {
        // ViewModel에 전달할 UI 이벤트들
    }

    struct Output {
        let sections: Observable<[SectionModel<String, AnyHashable>]>
    }

    func transform(input: Input) -> Output {
        // 비즈니스 로직 처리
        // Input 이벤트를 Output으로 변환
        return Output(sections: sections)
    }
}

```

### 2. 공통 UI 컴포넌트 관리

중복되는 UI 요소는 베이스 클래스로 추상화하여 재사용성을 높였습니다.

```swift
// UI 컴포넌트의 기본 레이아웃 설정을 위한 BaseView
class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    func configureHierarchy() {}
    func configureLayout() {}
    func configureView() {}
}

// ViewController의 공통 설정을 위한 BaseViewController
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }

    func configureHierarchy() {}
    func configureLayout() {}
    func configureView() {}
    func bind() {}
}

```

### 3. 네트워크 계층 설계

TMDB API 통신을 위한 네트워크 계층을 구조화하여 코드의 재사용성과 유지보수성을 높였습니다.

```swift
// API 요청을 위한 라우터 열거형
enum NetworkRouter: URLRequestConvertible {
    case popular
    case trending
    case recommendation(id: Int)
    case search(query: String, page: Int)
    case series(id: Int)
    case episode(id: Int, season: Int)

    // URL, 헤더, 파라미터 등 설정

    func asURLRequest() throws -> URLRequest {
        // URLRequest 생성 로직
    }
}

// RxSwift와 Alamofire를 결합한 네트워크 매니저
class NetworkManager {
    static let shared = NetworkManager()

    func callRequest<T:Decodable>(target: NetworkRouter, model: T.Type) -> Observable<T> {
        return Observable<T>.create { value in
            AF.request(target)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let result):
                        value.onNext(result)
                    case .failure(let error):
                        let code = response.response?.statusCode
                        value.onError(self.getError(code: code ?? 501))
                    }
                }
            return Disposables.create()
        }
    }
}

```

### 4. 로컬 데이터 관리 (Repository 패턴)

RealmSwift를 사용한 로컬 데이터 저장 로직을 제네릭 Repository 패턴으로 구현하여 코드 중복을 줄였습니다.

```swift
// Realm 객체에 공통적으로 적용할 프로토콜
protocol RealmFetchable: Object {
    var dramaId: Int { get }
}

// 공통 데이터베이스 작업을 위한 Repository 인터페이스
protocol DatabaseRepositoryPr {
    func fetchAll<T: RealmFetchable>() -> Results<T>
    func createItem<T: Object>(data: T)
    func deleteItem<T: RealmFetchable>(itemId: Int, type: T)
}

// Repository 구현
final class DatabaseRepository: DatabaseRepositoryPr {
    private let realm = try! Realm()

    func fetchAll<T: RealmFetchable>() -> Results<T> {
        return realm.objects(T.self)
    }

    func createItem<T: Object>(data: T) {
        do {
            try realm.write {
                realm.add(data, update: .modified)
            }
        } catch {
            print("아이템 저장 실패: \(error)")
        }
    }

    func deleteItem<T: RealmFetchable>(itemId: Int, type: T) {
        do {
            try realm.write {
                let target = realm.objects(T.self).where { $0.dramaId == itemId }
                realm.delete(target)
            }
        } catch {
            print("아이템 삭제 실패: \(error)")
        }
    }
}

```

### 5. 열거형을 활용한 상수 관리

UI 요소의 일관성을 위해 폰트, 문자열, 이미지를 열거형으로 관리했습니다.

```swift
// 폰트 및 색상 상수
enum Fonts {
    static let titleColor = UIColor.tdWhite
    static let textColor = UIColor.tdGray

    static var navTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 24, weight: .bold)
    }

    // 다양한 폰트 스타일 정의
}

// 문자열 상수
enum Strings {
    enum Global {
        case cancel
        case wantToWatch
        // ...

        var text: String {
            switch self {
            case .cancel: "취소"
            case .wantToWatch: "보고싶어요"
            // ...
            }
        }
    }

    enum NavTitle {
        // ...
    }

    // 다양한 문자열 카테고리 정의
}

```

## 👨‍💻 협업 방식

프로젝트는 3명의 팀원이 함께 진행했으며, 다음과 같은 워크플로우를 따랐습니다:

1. **GitHub Flow 기반 협업**:
    - 초기: 개인 레포지토리 포크 방식으로 시작
    - 발전: Issue 기반 브랜치 전략으로 전환
2. **프로젝트 초기 설계 단계**:
    - 공통 컴포넌트와 패턴 정의를 통한 코드 일관성 유지
    - 충돌(Conflict) 최소화를 위한 파일 구조 및 역할 분담
3. **코드 리뷰 및 병합**:
    - Pull Request 기반 코드 리뷰
    - 주기적인 팀 미팅을 통한 구현 방향 조율

## 🚨 트러블슈팅

### 1. RxDataSources와 여러 유형의 셀 처리

**문제 상황**

- HomeViewController에서 여러 섹션에 각기 다른 유형의 셀(PosterCell, BackdropCell 등)을 표시해야 했습니다.
- RxDataSources로 여러 타입의 모델을 다루는 과정에서 타입 캐스팅 이슈가 발생했습니다.

**해결 방법**

- `SectionModel<String, AnyHashable>`을 사용하여 여러 타입의 모델을 하나의 데이터 소스에서 처리할 수 있도록 했습니다.
- `configureCell` 클로저에서 각 아이템을 적절한 타입으로 캐스팅하여 알맞은 셀에 바인딩했습니다.

```swift
let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, AnyHashable>>(
    configureCell: { dataSource, collectionView, indexPath, item in
        if let popular = item.base as? PopularDetail {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
            cell.configure(with: popular.poster_path)
            return cell
        } else if let trend = item.base as? TrendDetail {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.identifier, for: indexPath) as! BackdropCollectionViewCell
            cell.configure(item: BackDrop(modelType: trend))
            return cell
        }
        // 다른 타입 처리
        return UICollectionViewCell()
    }
)

```

### 2. Realm 모델과 API 응답 모델 간의 연결

**문제 상황**

- TMDB API에서 받아온 데이터(Series, Episode 등)와 Realm에 저장하는 사용자 데이터(WishList, Comment 등) 간의 관계 설정이 필요했습니다.
- 서로 다른 두 데이터 소스 간의 동기화와 매핑에 어려움이 있었습니다.

**해결 방법**

- 각 Realm 모델에 TMDB API의 `dramaId`를 기본 키(Primary Key)로 설정하여 모델 간 관계를 명확히 했습니다.
- Realm 객체에 Drama 참조를 추가하여 관계형 데이터 구조를 만들었습니다.

```swift
class Comment: Object, RealmFetchable {
    @Persisted(primaryKey: true) var dramaId: Int
    @Persisted var comment: String
    @Persisted var drama: Drama?

    convenience init(drama: Drama, comment: String) {
        self.init()
        self.dramaId = drama.dramaId
        self.drama = drama
        self.comment = comment
    }
}

```

### 3. 네트워크 오류 처리와 사용자 피드백

**문제 상황**

- 네트워크 연결 끊김, API 오류 등 다양한 에러 상황에 대한 일관된 처리가 필요했습니다.
- 사용자에게 적절한 오류 메시지를 표시해야 했습니다.

**해결 방법**

- `NetworkError` 열거형을 정의하여 발생 가능한 모든 오류 유형을 명확히 했습니다.
- `NetworkMonitor` 클래스를 구현하여 실시간 네트워크 상태를 감시하고 RxSwift의 `Subject`를 통해 상태 변화를 UI에 반영했습니다.

```swift
// 네트워크 에러 정의
enum NetworkError: Error {
    case badRequest, unauthorized, forbidden, notFound
    // 다양한 에러 케이스

    var errorMessage: String {
        switch self {
        case .badRequest: return "잘못된 요청입니다."
        // 각 에러에 해당하는 사용자 친화적인 메시지
        }
    }
}

// 네트워크 상태 모니터링
class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let innerStatus = BehaviorSubject<Bool>(value: true)

    var currentStatus: Observable<Bool> {
        return innerStatus.asObservable()
    }

    func startNetworkMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.innerStatus.onNext(path.status == .satisfied)
        }
        monitor.start(queue: DispatchQueue(label: "Monitor"))
    }
}

```

## 🎯 향후 개선점

- 오프라인 모드 지원 강화
- UI/UX 개선 및 애니메이션 추가
- 테스트 코드 작성 및 코드 커버리지 향상
- 성능 최적화
