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
    private var seriesId: String?
    private var seriesData: Series?
    
    private let backdropView = UIImageView()
    private let dramaTitleLabel = UILabel()
    private let infoLabel = UILabel()
    private let synopsisLabel = UILabel()
    private let infoSectionTitle = SectionTitleView(title: Strings.SectionTitle.seriesInfo.text)
    private lazy var seriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createRelatedSeriesLayout())

    private let linkButton = UIButton()
    
    init(seriesId: String) {
        self.seriesId = seriesId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSeriesData()
    }
    
    private func loadSeriesData() {
        guard let id = seriesId, let series = DummyData.shared.getSeriesById(id) else { return }
        seriesData = series
        updateUI(with: series)
    
    }
    
    private func updateUI(with series: Series) {
        backdropView.image = series.backdropImage
        dramaTitleLabel.text = series.title
        infoLabel.text = "\(series.year) · \(series.channel) · \(series.genre)"
        synopsisLabel.text = series.synopsis
        
        seriesCollectionView.reloadData()
    }
    
    override func configureHierarchy() {
        [backdropView, dramaTitleLabel, infoLabel, synopsisLabel, linkButton, infoSectionTitle, seriesCollectionView].forEach { item in
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
            make.top.equalTo(linkButton.snp.bottom).offset(20)
            make.leading.equalToSuperview()
        }
        
        seriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(infoSectionTitle.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .black
        
        backdropView.contentMode = .scaleAspectFill
        backdropView.clipsToBounds = true
        backdropView.backgroundColor = .tdMain
        
        dramaTitleLabel.text = "슬기로운 의사생활"
        dramaTitleLabel.navTitleStyle()
        
        infoLabel.text = "시즌 2개 · 방영 종료 · 드라마 · 코미디"
        infoLabel.textStyle()
        
        synopsisLabel.text = "누구가는 태어나고 누구가는 삶을 끝내는 탄생과 죽음이 공존하는, 인생의 축소판이라 불리는 병원에서 평범한 듯 특별한 하루하루를 살아가는 사람들과 눈빛만 봐도 알 수 있는 20년지기 친구들의 케미 스토리를 담은 드라마"
        synopsisLabel.textStyle()
        synopsisLabel.numberOfLines = 0

        linkButton.setTitle("보러가기", for: .normal)
        linkButton.titleLabel?.textStyle()
    
        configureCollectionViews()
    }
    
    
    private func configureCollectionViews() {
        seriesCollectionView.backgroundColor = .clear
        seriesCollectionView.showsHorizontalScrollIndicator = false
        seriesCollectionView.register(SeriesCollectionViewCell.self, forCellWithReuseIdentifier: "SeriesCollectionViewCell")
        seriesCollectionView.delegate = self
        seriesCollectionView.dataSource = self
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SeriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DummyData.shared.series.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeriesCollectionViewCell", for: indexPath) as? SeriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let series = DummyData.shared.series[indexPath.item]
        cell.configure(with: series)
        
        return cell
    }
}
