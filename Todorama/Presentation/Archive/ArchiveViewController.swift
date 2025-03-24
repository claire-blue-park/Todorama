//
//  ArchiveViewController.swift
//  Todorama
//
//  Created by 권우석 on 3/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

final class ArchiveViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel = ArchiveViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    // 상단 카테고리 버튼들
    private let buttonContainerView = UIView()
    private let buttonStackView = UIStackView()
    
    // 각 카테고리 버튼
    private lazy var wantToWatchButton = CountButton(count: 0, name: Strings.Global.wantToWatch.text, isInteractive: false)
    private lazy var watchingButton = CountButton(count: 0, name: Strings.Global.watching.text, isInteractive: false)
    private lazy var watchedButton = CountButton(count: 0, name: Strings.Global.alreadyWatched.text, isInteractive: false)
    private lazy var commentButton = CountButton(count: 0, name: Strings.Global.comment.text, isInteractive: true)
    private lazy var rateButton = CountButton(count: 0, name: Strings.Global.rate.text, isInteractive: true)
    
    // 컨텐츠 컬렉션 뷰
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    override func configureHierarchy() {
        // 버튼 컨테이너 및 스택뷰 추가
        view.addSubview(buttonContainerView)
        buttonContainerView.addSubview(buttonStackView)
        
        // 버튼 스택뷰에 버튼들 추가
        buttonStackView.addArrangedSubview(wantToWatchButton)
        buttonStackView.addArrangedSubview(watchingButton)
        buttonStackView.addArrangedSubview(watchedButton)
        buttonStackView.addArrangedSubview(commentButton)
        buttonStackView.addArrangedSubview(rateButton)
        
        // 컬렉션 뷰 추가
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        // 버튼 컨테이너 레이아웃
        buttonContainerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        // 버튼 스택뷰 레이아웃
        buttonStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        }
        
        // 컬렉션 뷰 레이아웃
        collectionView.snp.makeConstraints {
            $0.top.equalTo(buttonContainerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
        
        // Navigation title
        navigationItem.title = Strings.NavTitle.archive.text
        navigationController?.navigationBar.topItem?.backButtonTitle = "" // 화살표만 뜨도록
        navigationController?.navigationBar.tintColor = .tdMain
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Background color
        view.backgroundColor = .black
        buttonContainerView.backgroundColor = .black
        collectionView.backgroundColor = .black
        
        // 셀 및 헤더 등록
        collectionView.register(BackdropCollectionViewCell.self, forCellWithReuseIdentifier: BackdropCollectionViewCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        
        // 버튼 스택뷰 설정
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 8
    }
    
    override func bind() {
        // RxDataSources 설정
        let dataSource = RxCollectionViewSectionedReloadDataSource<ArchiveSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BackdropCollectionViewCell.identifier,
                    for: indexPath
                ) as? BackdropCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                // BackDrop 모델로 변환하여 셀에 전달
                let backDrop = BackDrop(modelType: item)
                
                // 진행률이 있는 아이템이고, watching 섹션이면 진행률 표시
                if item.progress > 0 && item.progress < 1 && dataSource.sectionModels[indexPath.section].model == .watching {
                    // 진행률과 함께 셀 구성
                    cell.configure(item: backDrop, progress: item.progress)
                } else {
                    // 기본 셀 구성 (진행률 없음)
                    cell.configure(item: backDrop)
                }
                
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                guard kind == UICollectionView.elementKindSectionHeader,
                      let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                        for: indexPath
                      ) as? SectionHeaderView else {
                    return UICollectionReusableView()
                }
                
                let section = dataSource.sectionModels[indexPath.section].model
                headerView.configure(with: section.title)
                
                return headerView
            }
        )
        
        // ViewModel 바인딩
        let input = ArchiveViewModel.Input(
            viewDidLoad: Observable.just(())
        )
        
        let output = viewModel.transform(input: input)
        
        // 섹션 데이터 바인딩
        output.sections
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 카운트 정보 바인딩
        output.wishListCount
            .drive(onNext: { [weak self] count in
                self?.wantToWatchButton.updateCount(count: count)
            })
            .disposed(by: disposeBag)
        
        output.watchingCount
            .drive(onNext: { [weak self] count in
                self?.watchingButton.updateCount(count: count)
            })
            .disposed(by: disposeBag)
        
        output.watchedCount
            .drive(onNext: { [weak self] count in
                self?.watchedButton.updateCount(count: count)
            })
            .disposed(by: disposeBag)
        
        output.commentCount
            .drive(onNext: { [weak self] count in
                self?.commentButton.updateCount(count: count)
            })
            .disposed(by: disposeBag)
        
        output.rateCount
            .drive(onNext: { [weak self] count in
                self?.rateButton.updateCount(count: count)
            })
            .disposed(by: disposeBag)
        
        // 아이템 선택 처리 - 중요: 여기서 올바른 드라마 ID를 SeriesViewController로 전달
        collectionView.rx.modelSelected(ContentModel.self)
            .subscribe(onNext: { [weak self] model in
                print("Selected item with dramaId: \(model.id)")
                
                // 드라마 ID로 SeriesViewController 생성 및 이동
                let seriesVC = SeriesViewController(id: model.id)
                self?.navigationController?.pushViewController(seriesVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 코멘트 버튼 탭 처리
        commentButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let commentVC = CommentViewController()
                self?.navigationController?.pushViewController(commentVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 별점 버튼 탭 처리
        rateButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let rateVC = RateViewController()
                self?.navigationController?.pushViewController(rateVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Collection View Configuration
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            return self.createHorizontalSection()
        }
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        // BackdropCollectionViewCell에 맞는 아이템 크기 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 아이템 사이 간격
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        // HomeViewController의 trendSectionLayout과 유사하게 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(7/18),  // BackdropCollectionViewCell에 적합한 비율
            heightDimension: .fractionalHeight(0.18)  // 화면 높이의 18%
        )
        
        // 수평 그룹 생성
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // 섹션 정의
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous // 수평 스크롤 설정
        
        // 헤더 뷰 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        // 섹션 간격 설정
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        
        return section
    }
}
