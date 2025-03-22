//
//  HomeViewController.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class HomeViewController: BaseViewController {

    let disposeBag = DisposeBag()
    let viewModel = HomeViewModel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    let scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
    }
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(scrollView)
        }
    }
    override func configureView() {
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.register(BackdropCollectionViewCell.self, forCellWithReuseIdentifier: BackdropCollectionViewCell.identifier)

        collectionView.register(SectionHeaderView.self,   forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)

    }
    func popularSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(4/5),
            heightDimension: .fractionalHeight(7/12))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    
    func trendSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(7/18),
            heightDimension: .fractionalHeight(0.18))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    
    func recommendationSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return header
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            switch sectionIndex {
            case 0: return self.popularSectionLayout()
            case 1: return self.trendSectionLayout()
            default: return self.recommendationSection()
                
            }
        }
        return layout
    }



    override func bind() {
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, AnyHashable>>( configureCell: { dataSource, collectionView, indexPath, item in
            if let popular = item.base as? PopularDetail {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
                cell.configure(with: "star")
                return cell
            } else if let trend = item.base as? TrendDetail {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.identifier, for: indexPath) as! BackdropCollectionViewCell
                cell.configure()
                return cell
            } else if let recommendation = item.base as? RecommendationDetail {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
                cell.configure(with: "person")
                return cell
            }
            return UICollectionViewCell()
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
            header.configure(with: dataSource.sectionModels[indexPath.section].model)
            return header
        })
        
        output.sections.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Any.self)
            .bind(with: self) { owner, model in
                if let model = model as? IdentifiableModel {
                    let id = model.id
                    // push seriesVC
                }
            }.disposed(by: disposeBag)
    }
}
