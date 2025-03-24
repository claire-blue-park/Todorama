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
    private var viewModel: EpisodeViewModel
    
    private let posterView = UIImageView()
    private let dramaTitleLabel = UILabel()
    private var episodeCountLabel = UILabel()
    private let synopsisLabel = UILabel()
    private let episodesSectionTitleView = SectionTitleView(title: Strings.SectionTitle.episode.text)
    private lazy var episodesTableView = UITableView()
    private let buttonStackView = ButtonStack()
    
    init(id: Int, season: Int) {
        self.viewModel = EpisodeViewModel(id: id, season: season)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
    
    override func bind() {
        let input = EpisodeViewModel.Input()
        let output = viewModel.transform(input: input)

        buttonStackView.commentButtonTapped
                    .subscribe(onNext: { [weak self] in
                        let controller = EditingCommentViewController()
                        self?.navigationController?.pushViewController(controller, animated: true)
                    })
                    .disposed(by: disposeBag)
        
        output.result
            .asDriver(onErrorJustReturn: SeasonDetail(name: "", overview: "", id: -1, poster_path: "", season_number: -1, episodes: []))
             .drive(with: self, onNext: { owner, detail in
                 owner.loadData(with: detail)
                 
                 // 시즌 방출 -> 컬렉션 뷰
                 Observable.just(detail.episodes)
                     .asDriver(onErrorJustReturn: [])
                     .drive(owner.episodesTableView.rx.items(
                        cellIdentifier: EpisodeTableViewCell.identifier,
                         cellType: EpisodeTableViewCell.self)) {(row, element, cell) in
                             cell.bindData(with: element)
                         }
                     .disposed(by: owner.disposeBag)
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

    }
    
    private func loadData(with seasonDetail: SeasonDetail) {

        dramaTitleLabel.text = seasonDetail.name
        episodeCountLabel.text = "\(seasonDetail.season_number)\(Strings.Unit.count.text) \(Strings.Global.episode.text)"
        synopsisLabel.text = seasonDetail.overview
        
        if let posterImage = seasonDetail.poster_path {
            posterView.kf.setImage(with: URL(string: ImageSize.poster185(url: posterImage).fullUrl))
        }
        
        episodesTableView.reloadData()
    }
    
}

