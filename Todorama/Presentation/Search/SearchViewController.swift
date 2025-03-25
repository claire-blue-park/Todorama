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

final class SearchViewController: BaseViewController {
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    let searchBar = UISearchBar()
    let cancelButton = UIButton()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    let emptyLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
    }
    override func bind() {
        let scrollEvent = collectionView.rx.didScroll
            .map { [weak self] in self?.collectionView }
            .compactMap { $0 }
            .filter { collectionView in
                let offsetY = collectionView.contentOffset.y
                let contentHeight = collectionView.contentSize.height
                let frameHeight = collectionView.frame.size.height
                return offsetY > contentHeight - frameHeight - 100
            }
            .map { _ in }
        let callRequestTrigger = PublishSubject<Void>()
        let input = SearchViewModel.Input(cancelButtonTapped: cancelButton.rx.tap, searchButtonTapped: searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text.orEmpty), scrollTrigger: scrollEvent, callRequestTrigger: callRequestTrigger)
        let output = viewModel.transform(input: input)
        output.resignKeyboardTrigger.drive(with: self) { owner, _ in
            owner.view.endEditing(true)
        }.disposed(by: disposeBag)
        output.cancelButtonTapped.drive(with: self) { owner, _ in
            owner.searchBar.text = Strings.Global.empty.text
            owner.view.endEditing(true)
        }.disposed(by: disposeBag)
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, AnyHashable>>( configureCell: { dataSource, collectionView, indexPath, item in
            if let popular = item.base as? PopularDetail {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
                cell.configure(with: popular.poster_path, title: popular.name)
                return cell
            }
            return UICollectionViewCell()
        })
        output.sections.do(onNext: { [weak self] section in
            if section[0].items.isEmpty {
                self?.collectionView.isHidden = true
            } else {
                self?.collectionView.isHidden = false
            }
        }).bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        output.errorMessage.drive(with: self) { owner, error in
            let errorType = error.0
            let errorMessage = errorType.errorMessage
            if errorType == .networkError {
                owner.showAlert(text: errorMessage) {
                    callRequestTrigger.onNext(())
                }
            } else {
                owner.showAlert(text: errorMessage)
            }
        }.disposed(by: disposeBag)
        collectionView.rx.modelSelected(Any.self)
            .bind(with: self) { owner, model in
                if let model = model as? IdentifiableModel {
                    let id = model.id
                    let vc = SeriesViewController(id: id)
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }.disposed(by: disposeBag)
    }
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(cancelButton)
        view.addSubview(emptyLabel)
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
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
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
        emptyLabel.dramaTitleStyle()
        emptyLabel.backgroundColor = .tdBlack
        emptyLabel.textColor = .tdWhite
        emptyLabel.textAlignment = .center
        emptyLabel.text = Strings.Global.emptyData.text
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
