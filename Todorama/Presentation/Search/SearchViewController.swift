//
//  SearchViewController.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    let searchBar = UISearchBar()
    let cancelButton = UIButton()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureView()
        bind()
    }
    func configureView() {
        view.backgroundColor = .tdBlack
        view.addSubview(searchBar)
        view.addSubview(cancelButton)
        view.addSubview(collectionView)
        searchBar.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(44)
        }
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.leading.equalTo(searchBar.snp.trailing)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(searchBar.snp.height)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.tintColor = .tdWhite
        searchBar.placeholder = "원하는 드라마의 제목을 입력해주세요"
    }
    func createLayout() -> UICollectionViewCompositionalLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return header
    }
    func configure() {
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.register(SectionHeaderView.self,   forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }
    func bind() {

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, AnyHashable>>( configureCell: { dataSource, collectionView, indexPath, item in
            if let popular = item.base as? PopularDetail {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
                cell.configure(with: "star")
                return cell
            }
            return UICollectionViewCell()
        })
        viewModel.sections.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
