//
//  SeriesViewController.swift
//  Todorama
//
//  Created by Claire on 3/21/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class SeriesViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let backdropView = UIImageView()
    private let dramaTitleLabel = UILabel()
    private let infoLabel = UILabel()
    private let synopsisLabel = UILabel()
    private let linkLabel = UILabel()
    private let sectionTitle = UIView()
    private lazy var episodeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        [backdropView, dramaTitleLabel, infoLabel, synopsisLabel, linkLabel, sectionTitle, episodeCollectionView].forEach { item in
            view.addSubview(item)
        }
    }
    
    override func configureLayout() {
        backdropView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(240)
        }
        
        dramaTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(dramaTitleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(dramaTitleLabel.snp.horizontalEdges)
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(dramaTitleLabel.snp.horizontalEdges)
        }
        
        sectionTitle.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(synopsisLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        linkLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisLabel.snp.bottom).offset(20)
            make.trailing.equalTo(dramaTitleLabel.snp.trailing)
        }
        
        episodeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(linkLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        backdropView.backgroundColor = .tdDarkGray
        dramaTitleLabel.text = "테스트"
        dramaTitleLabel.navTitleStyle()
        
        infoLabel.text = "테스트"
        infoLabel.textStyle()
        
        synopsisLabel.text = """
        테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트 테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트 테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트 테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트 테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트 테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트 테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트 테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트 테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트
"""
        synopsisLabel.textStyle()
        synopsisLabel.numberOfLines = 5
        
        episodeCollectionView.backgroundColor = .tdDarkGray
        
        linkLabel.text = "보러가기"
        linkLabel.textStyle()
    }
    
    override func bind() {
  
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                   heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        
    }
    
}
