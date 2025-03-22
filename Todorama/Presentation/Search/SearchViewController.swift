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

class SearchViewController: BaseViewController {
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    let searchBar = UISearchBar()
    let cancelButton = UIButton()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func bind() {
        let recentText = searchBar.rx.text.orEmpty
        let input = SearchViewModel.Input(cancelButtonTapped: cancelButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.cancelButtonTapped.drive(with: self) { owner, _ in
            owner.searchBar.text = ""
        }.disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, AnyHashable>>( configureCell: { dataSource, collectionView, indexPath, item in
            if let popular = item.base as? PopularDetail {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
                print(popular.id)
                cell.configure(with: popular.poster_path)
                return cell
            }
            return UICollectionViewCell()
        })
        output.sections.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        output.errorMessage.drive(with: self) { owner, error in
            // error는 (errorType, isNetworkConnected)인 튜플값
            let errorMessage = error.0.errorMessage
            print(errorMessage)// 에러 메시지
            let isConnected = error.1 // 네트워크가 연결된 상태인지
        
        }.disposed(by: disposeBag)
        collectionView.rx.modelSelected(Any.self)
            .bind(with: self) { owner, model in
                if let model = model as? IdentifiableModel {
                    let id = model.id
                    // push seriesVC
                }
            }.disposed(by: disposeBag)
    }
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(cancelButton)
        view.addSubview(collectionView)
    }
    override func configureLayout() {
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
    }
    override func configureView() {
        cancelButton.setAttributedTitle(NSAttributedString(string: Strings.Global.cancel.text, attributes: [.font : Fonts.sectionTitleFont]), for: .normal)
        searchBar.placeholder = Strings.Placeholder.search.text
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
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



}
