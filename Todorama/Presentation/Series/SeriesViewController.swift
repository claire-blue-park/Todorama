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
import WebKit

final class SeriesViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: SeriesViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let wishButton = WishButton()
    private let backdropView = UIImageView()
    private let dramaTitleLabel = UILabel()
    private let infoLabel = UILabel()
    private let synopsisLabel = UILabel()
    private let infoSectionTitle = SectionTitleView(title: Strings.SectionTitle.seriesInfo.text)
    
    private let networkButtonView = NetworkButtonView()
    
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
                owner.dramaTitleLabel.text = series.name
                let genreId = series.genres.first?.id ?? 0
                let genreKo = GenreManager.shared.getGenre(genreId)
                owner.infoLabel.text = "\(Strings.Global.season.text) \(series.number_of_seasons)\(Strings.Unit.count.text) · \(series.status) · \(genreKo)"
                owner.synopsisLabel.text = series.overview
                if let backdropPath = series.backdrop_path {
                    owner.backdropView.kf.setImage(with: URL(string: ImageSize.backdrop780(url: backdropPath).fullUrl))
                }
                
                // 보고싶어요 버튼
                owner.wishButton.setSeries(series: series)
                
                // 네트워크 버튼 업데이트
                if let network = series.networks.first {
                    owner.networkButtonView.configure(with: network)
                }
            })
            .disposed(by: disposeBag)
        
        output.result
            .map { $0.seasons }
            .asDriver(onErrorJustReturn: [])
            .drive(seriesCollectionView.rx.items(cellIdentifier: SeriesCollectionViewCell.identifier, cellType: SeriesCollectionViewCell.self)) { row, season, cell in
                cell.bindData(with: season)
            }
            .disposed(by: disposeBag)
        
        seriesCollectionView.rx.itemSelected
            .withLatestFrom(output.result) { indexPath, series in
                (indexPath, series)
            }
            .subscribe(onNext: { [weak self] indexPath, series in
                guard indexPath.row < series.seasons.count else { return }
                let selectedSeason = series.seasons[indexPath.row]
                
                let controller = EpisodeViewController(series: series,
                                                       season: selectedSeason.season_number)
                self?.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.homepage
            .asDriver(onErrorJustReturn: "https://www.google.com")
            .drive(with: self, onNext: { owner, homepage in
                owner.networkButtonView.onTap = {
                    owner.presentWebView(with: homepage)
                }
            })
            .disposed(by: disposeBag)
    }

    
    private func loadData(with series: Series) {
        if let image = series.backdrop_path {
            backdropView.kf.setImage(with: URL(string: ImageSize.backdrop780(url: image).fullUrl))
        }
        dramaTitleLabel.text = series.name
        
        let genreId = series.genres.first?.id ?? 00
        let genreKo = GenreManager.shared.getGenre(genreId)
        infoLabel.text = "\(Strings.Global.season.text) \(series.number_of_seasons)\(Strings.Unit.count.text) · \(series.status) · \(genreKo)"
        synopsisLabel.text = series.overview
        
        seriesCollectionView.reloadData()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [backdropView, wishButton, dramaTitleLabel, infoLabel, synopsisLabel, networkButtonView, infoSectionTitle, seriesCollectionView].forEach { item in
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
        
        wishButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(24)
            make.centerY.equalTo(dramaTitleLabel)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(dramaTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(dramaTitleLabel.snp.horizontalEdges)
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(dramaTitleLabel.snp.horizontalEdges)
        }
        
        networkButtonView.snp.makeConstraints { make in
            make.top.equalTo(synopsisLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }
        
        infoSectionTitle.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(networkButtonView.snp.bottom).offset(20)
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
        
        
        seriesCollectionView.backgroundColor = .clear
        seriesCollectionView.showsHorizontalScrollIndicator = false
        seriesCollectionView.register(SeriesCollectionViewCell.self, forCellWithReuseIdentifier: SeriesCollectionViewCell.identifier)
    }
    
}

// MARK: - WebView
extension SeriesViewController {
    private func presentWebView(with urlString: String) {
        guard let url = URL(string: urlString), !urlString.isEmpty else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        let webView = WKWebView()
        let webViewController = UIViewController()
        webViewController.view = webView
        webView.load(URLRequest(url: url))
        
        let navController = UINavigationController(rootViewController: webViewController)
        webViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissWebView))
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func dismissWebView() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Compositional
extension SeriesViewController {
    
    private func createRelatedSeriesLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
            section.interGroupSpacing = 8
            return section
        }
    }
}
