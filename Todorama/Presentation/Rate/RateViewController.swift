//
//  RateViewController.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class RateViewController: BaseViewController {
    let disposeBag = DisposeBag()
    let viewModel = RateViewModel()
    let sortButton = UIButton()
    let navTitleView = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func configureView() {

        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        navTitleView.text = Strings.NavTitle.rate.text
        navTitleView.navTitleStyle()
        navigationItem.titleView = navTitleView
        navigationController?.navigationBar.topItem?.backButtonTitle = Strings.Global.empty.text
        navigationController?.navigationBar.tintColor = .tdMain
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        configureSortButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
        
    }
    private func configureSortButton() {
        var config = UIButton.Configuration.filled()
        let img = SystemImages.chevron.down.image
        config.image = img.resized(to: CGSize(width: 16, height: 12)).withTintColor(.tdWhite)
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .tdMain
        config.baseForegroundColor = .tdWhite
        config.imagePlacement = .trailing
        config.imagePadding = 2
        sortButton.configuration = config
        sortButton.setAttributedTitle(NSAttributedString(string: Strings.Rate.date.text, attributes: [.font : Fonts.sectionTitleFont]), for: .normal)
        sortButton.isSelected = true
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
    private func sortButtonChanged() {
        sortButton.isSelected.toggle()
        let newTitle = sortButton.isSelected ? Strings.Rate.date.text : Strings.Rate.star.text
        sortButton.setAttributedTitle(NSAttributedString(string: newTitle, attributes: [.font : Fonts.sectionTitleFont]), for: .normal)
    }
    override func bind() {
        let sortButtonTapped = sortButton.rx.tap.map{[weak self] _ in self?.sortButton.isSelected}
        
        let input = RateViewModel.Input(sortButtonTapped: sortButtonTapped)
        let output = viewModel.transform(input: input)
        
        output.sortChanged.drive(with: self) { owner, _ in
            owner.sortButtonChanged()
        }.disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, AnyHashable>>( configureCell: { dataSource, collectionView, indexPath, item in
            if let rating = item.base as? Rating {                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
                cell.configure(with: nil, title: rating.drama?.name, rate: rating.rate)
                return cell
            }
            return UICollectionViewCell()
        })
        output.sections.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Any.self)
            .bind(with: self) { owner, model in
                if let model = model as? RealmFetchable {
                    let id = model.dramaId
                    print(id)
                    let vc = SeriesViewController(id: id)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }.disposed(by: disposeBag)
    }

}
