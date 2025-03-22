//
//  EpisodeViewController.swift
//  Todorama
//
//  Created by Claire on 3/21/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class EpisodeViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private var series: Series = DummyData.shared.getSeriesById("hospital-playlife-s1")!
    
    private let posterView = UIImageView()
    private let dramaTitleLabel = UILabel()
    private var episodeCountLabel = UILabel()
    private let synopsisLabel = UILabel()
    private let episodesSectionTitleView = SectionTitleView(title: Strings.SectionTitle.episode.text)
    private lazy var episodesTableView = UITableView()
    private let buttonStackView = ButtonStack()
    
//    init(series: Series) {
//        self.series = series
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        [posterView, dramaTitleLabel, episodeCountLabel, synopsisLabel,
         episodesSectionTitleView, buttonStackView, episodesTableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        posterView.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(240)
        }
        
        dramaTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.trailing.equalTo(posterView.snp.leading).offset(-12)
        }
        
        episodeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(dramaTitleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeCountLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(dramaTitleLabel)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(posterView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        episodesSectionTitleView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(buttonStackView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }
        
        episodesTableView.snp.makeConstraints { make in
            make.top.equalTo(episodesSectionTitleView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        posterView.backgroundColor = .tdWhite
        posterView.layer.cornerRadius = 4
        posterView.contentMode = .scaleAspectFill
        posterView.clipsToBounds = true
        
        dramaTitleLabel.textAlignment = .left
        dramaTitleLabel.navTitleStyle()
        
        episodeCountLabel.textStyle()
        
        synopsisLabel.textStyle()
        synopsisLabel.numberOfLines = 5
        
        setupTableView()
        
        loadData()
    }
    
    override func bind() {
   
        episodesTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.episodesTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func setupTableView() {
        episodesTableView.backgroundColor = .black
        episodesTableView.separatorStyle = .none
        episodesTableView.rowHeight = UITableView.automaticDimension
        episodesTableView.estimatedRowHeight = 140
        episodesTableView.showsVerticalScrollIndicator = false
        
        episodesTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: EpisodeTableViewCell.identifier)
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
    }
    
    private func loadData() {

        dramaTitleLabel.text = series.title
        episodeCountLabel.text = "\(series.episodeCount) 개의 에피소드"
        synopsisLabel.text = series.synopsis
        
        if let posterImage = series.posterImage {
            posterView.image = posterImage
        }
        
        episodesTableView.reloadData()
    }
    
}

extension EpisodeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.episodes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.identifier, for: indexPath) as? EpisodeTableViewCell else {
            return UITableViewCell()
        }
        let episode = series.episodes[indexPath.row]
        cell.bindData(with: episode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
