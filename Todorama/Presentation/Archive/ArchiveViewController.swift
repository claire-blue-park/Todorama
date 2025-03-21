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
import Kingfisher

final class ArchiveViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel = ArchiveViewModel()
    
    // MARK: - UI Components
    // 상단 카테고리 버튼들
    private let buttonContainerView = UIView()
    private let buttonStackView = UIStackView()
    
    // 각 카테고리 버튼
    private lazy var wantToWatchButton = CountButton(count: 44, name: Strings.Global.wantToWatch.text, isInteractive: false)
    private lazy var watchingButton = CountButton(count: 12, name: Strings.Global.watching.text, isInteractive: false)
    private lazy var watchedButton = CountButton(count: 3, name: Strings.Global.alreadyWatched.text, isInteractive: false)
    private lazy var commentButton = CountButton(count: 88, name: Strings.Global.comment.text, isInteractive: true)
    private lazy var rateButton = CountButton(count: 40, name: Strings.Global.rate.text, isInteractive: true)
    private var dataSource: UICollectionViewDiffableDataSource<ArchiveSection, ContentModel>!
    
    // 컨텐츠 컬렉션 뷰
    private lazy var collectionView: UICollectionView = {
        // 컴포지션 레이아웃 생성
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
        
        // Background color
        view.backgroundColor = .black
        buttonContainerView.backgroundColor = .black
        collectionView.backgroundColor = .black
        
        collectionView.register(ArchiveContentCell.self, forCellWithReuseIdentifier: ArchiveContentCell.identifier)
        collectionView.register(ArchiveSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ArchiveSectionHeaderView.identifier)
        
        // 버튼 스택뷰 설정
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 8
        
        // 버튼 액션 설정
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        rateButton.addTarget(self, action: #selector(rateButtonTapped), for: .touchUpInside)
    }
    
    override func bind() {
        // 데이터소스 먼저 생성 (중요!)
        dataSource = createDataSource()
        
        // ViewModel 바인딩
        let input = ArchiveViewModel.Input(
            viewDidLoad: Observable.just(())
        )
        
        let output = viewModel.transform(input: input)
        
        // 섹션 데이터 관찰 및 업데이트
        output.sections
            .drive(onNext: { [weak self] sections in
                guard let self = self else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<ArchiveSection, ContentModel>()
                
                for section in sections {
                    snapshot.appendSections([section.type])
                    snapshot.appendItems(section.items, toSection: section.type)
                }
                
                // 메인 스레드에서 실행
                DispatchQueue.main.async {
                    self.dataSource.apply(snapshot, animatingDifferences: true)
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        // 아이템 선택 처리
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                // Handle selection
                print("Selected item at \(indexPath)")
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    // MARK: - Collection View Configuration
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            // 모든 섹션은 수평 스크롤
            let section = self?.createHorizontalSection()
            return section
        }
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        // 아이템 크기 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 아이템 사이 간격
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        // 그룹 크기 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),  // 셀 너비
            heightDimension: .absolute(180)  // 셀 높이
        )
        
        // 수평 그룹 생성
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // 섹션 정의
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 24, trailing: 8)
        
        // 헤더 뷰 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 데이터 소스 생성
    private func createDataSource() -> UICollectionViewDiffableDataSource<ArchiveSection, ContentModel> {
        let dataSource = UICollectionViewDiffableDataSource<ArchiveSection, ContentModel>(
            collectionView: collectionView
        ) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArchiveContentCell.identifier,
                for: indexPath
            ) as? ArchiveContentCell else {
                return UICollectionViewCell()
            }
            
            // 섹션에 따라 프로그레스바 표시 여부 설정
            let section = ArchiveSection.allCases[indexPath.section]
            
            switch section {
            case .wantToWatch, .dailyComment:
                cell.configure(with: item, showProgress: false)
            case .watched, .watching:
                cell.configure(with: item, showProgress: true, progress: Float.random(in: 0.1...0.9))
            }
            
            return cell
        }
        
        // 헤더 뷰 설정
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ArchiveSectionHeaderView.identifier,
                    for: indexPath
                  ) as? ArchiveSectionHeaderView else {
                return nil
            }
            
            let section = ArchiveSection.allCases[indexPath.section]
            headerView.configure(with: section.title)
            
            return headerView
        }
        
        return dataSource
    }
    
    // 스냅샷 적용
    private func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<ArchiveSection, ContentModel>) {
        // 메인 스레드에서 실행
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dataSource.apply(snapshot, animatingDifferences: true)
            
            // 헤더 뷰 설정 (여기서 확인)
            self.dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
                guard kind == UICollectionView.elementKindSectionHeader,
                      let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: ArchiveSectionHeaderView.identifier,
                        for: indexPath
                      ) as? ArchiveSectionHeaderView else {
                    return nil
                }
                
                let section = ArchiveSection.allCases[indexPath.section]
                headerView.configure(with: section.title)
                
                return headerView
            }
        }
    }
    
    // MARK: - Actions
    @objc private func commentButtonTapped() {
        print("Comment button tapped - navigate to CommentViewController")
        // 실제 구현에서는 CommentViewController로 이동
        // let commentVC = CommentViewController()
        // navigationController?.pushViewController(commentVC, animated: true)
    }
    
    @objc private func rateButtonTapped() {
        print("Rate button tapped - navigate to RateViewController")
        // 실제 구현에서는 RateViewController로 이동
        // let rateVC = RateViewController()
        // navigationController?.pushViewController(rateVC, animated: true)
    }
}
