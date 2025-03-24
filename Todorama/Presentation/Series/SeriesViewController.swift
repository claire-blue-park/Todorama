//
//  SeriesViewController.swift
//  Todorama
//
//  Created by Claire on 3/21/25.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit

final class SeriesViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: SeriesViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backdropView = UIImageView()
    private let dramaTitleLabel = UILabel()
    private let infoLabel = UILabel()
    private let synopsisLabel = UILabel()
    private let infoSectionTitle = SectionTitleView(title: Strings.SectionTitle.seriesInfo.text)
    private let linkButton = UIButton()
    
    private lazy var seriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createRelatedSeriesLayout())

    init(id: Int) {
        self.viewModel = SeriesViewModel(id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = SeriesViewModel.Input()
        let output = viewModel.transform(input: input)
        
        let defaultSeries = Series(id: -1, name: "", backdrop_path: "", number_of_seasons: -1, status: "", genres: [], overview: "", seasons: [], networks: [])

        output.result
             .asDriver(onErrorJustReturn: defaultSeries)
             .drive(with: self, onNext: { owner, series in
                 owner.loadData(with: series)
                 
                 Observable.just(series.seasons)
                     .asDriver(onErrorJustReturn: [])
                     .drive(owner.seriesCollectionView.rx.items(
                         cellIdentifier: SeriesCollectionViewCell.identifier,
                         cellType: SeriesCollectionViewCell.self)) {(row, element, cell) in
                             cell.bindData(with: element)
                         }
                     .disposed(by: owner.disposeBag)
             })
             .disposed(by: disposeBag)
    }
    
    private func loadData(with series: Series) {
        if let image = series.backdrop_path {
            backdropView.kf.setImage(with: URL(string: ImageSize.backdrop780(url: image).fullUrl))
        }
        dramaTitleLabel.text = series.name
        infoLabel.text = "\(Strings.Global.season.text) \(series.number_of_seasons)\(Strings.Unit.count.text) · \(series.status) · \(series.genres[0].name)"
        synopsisLabel.text = series.overview
        
        seriesCollectionView.reloadData()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [backdropView, dramaTitleLabel, infoLabel, synopsisLabel, linkButton, infoSectionTitle, seriesCollectionView].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        backdropView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(240)
        }
        
        dramaTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(dramaTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(dramaTitleLabel.snp.horizontalEdges)
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(dramaTitleLabel.snp.horizontalEdges)
        }
        
        linkButton.snp.makeConstraints { make in
            make.top.equalTo(synopsisLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(20)
        }
        
        infoSectionTitle.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(linkButton.snp.bottom).offset(20)
            make.leading.equalToSuperview()
        }
        
        seriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(infoSectionTitle.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(280)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .black
        
        scrollView.alwaysBounceVertical = true
        
        backdropView.contentMode = .scaleAspectFill
        backdropView.clipsToBounds = true
        
        dramaTitleLabel.navTitleStyle()
        
        infoLabel.textStyle()
    
        synopsisLabel.textStyle()
        synopsisLabel.numberOfLines = 0

        linkButton.setTitle("보러가기", for: .normal)
        linkButton.titleLabel?.textStyle()
    
        seriesCollectionView.backgroundColor = .clear
        seriesCollectionView.showsHorizontalScrollIndicator = false
        seriesCollectionView.register(SeriesCollectionViewCell.self, forCellWithReuseIdentifier: "SeriesCollectionViewCell")
    }
    
    private func createRelatedSeriesLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
 
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                   heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
            section.interGroupSpacing = 8
            
            return section
        }
    }
}
