//
//  EpisodeTableViewCell.swift
//  Todorama
//
//  Created by Claire on 3/22/25.
//

import UIKit
import SnapKit
import RealmSwift
import RxCocoa
import RxSwift

final class EpisodeTableViewCell: UITableViewCell {

    private let thumbnailImageView = UIImageView()
    private let episodeNumberLabel = UILabel()
    private let durationLabel = UILabel()
    private let dateLabel = UILabel()
    private let episodeDescriptionLabel = UILabel()
    private let checkButton = CheckButton()

    private var dramaId: Int? // 드라마 ID를 저장할 변수
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        selectionStyle = .none
        
        // 이미지 영역
        thumbnailImageView.backgroundColor = .tdMain
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 4
        
        // 텍스트 영역
        episodeNumberLabel.dramaTitleStyle()
        durationLabel.textStyle()
        dateLabel.textStyle()
        episodeDescriptionLabel.textStyle()
        episodeDescriptionLabel.numberOfLines = 3
    }
    
    private func configureHierarchy() {
        [thumbnailImageView,
         episodeNumberLabel, durationLabel, dateLabel, episodeDescriptionLabel,
         checkButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(160)
            make.height.equalTo(90)
        }
        
        episodeNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.top)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeNumberLabel.snp.bottom).offset(4)
            make.leading.equalTo(episodeNumberLabel.snp.leading)
        }
        
        checkButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(episodeNumberLabel)
            make.width.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(thumbnailImageView.snp.bottom).offset(-4)
            make.leading.equalTo(durationLabel)
        }
        
        episodeDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.leading.equalTo(thumbnailImageView)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func bindData(with episode: Episode, dramaId: Int, dramaName: String, seasonNumber: Int) {
        
        checkButton.setSeries(info: Watching3(dramaId: dramaId,
                                              dramaName: dramaName,
                                              seasonNumber: seasonNumber,
                                              episodeId: episode.id,
                                              episodeCount: episode.episode_number,
                                              stillCutPath: episode.still_path))
        
        thumbnailImageView.kf.setImage(with: URL(string: ImageSize.profile185(url: episode.still_path ?? "").fullUrl))
        episodeNumberLabel.text = "\(episode.episode_number)\(Strings.Unit.epi.text)"
        durationLabel.text = episode.runtime == nil ? "-" : "\(episode.runtime!)\(Strings.Unit.minute.text)"
        dateLabel.text = DateFormatHelper.shared.getFormattedDate(episode.air_date) + " " + "\(Strings.Global.air.text)"
        episodeDescriptionLabel.text = episode.overview
    }
}
