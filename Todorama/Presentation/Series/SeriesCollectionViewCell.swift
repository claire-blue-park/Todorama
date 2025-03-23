//
//  SeriesCollectionViewCell.swift
//  Todorama
//
//  Created by Claire on 3/22/25.
//


import UIKit
import SnapKit

final class SeriesCollectionViewCell: UICollectionViewCell {
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let episodeCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        configurePosterImageView()
        configureLabels()
        
        [posterImageView, titleLabel, episodeCountLabel].forEach {
            contentView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func configurePosterImageView() {
        posterImageView.backgroundColor = .tdMain
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 4
    }
    
    private func configureLabels() {
        titleLabel.dramaTitleStyle()
        episodeCountLabel.textStyle()
    }
    
    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(1.4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(4)
        }
        
        episodeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(4)
//            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with series: Series) {
        titleLabel.text = series.title
        episodeCountLabel.text = "\(series.episodeCount)개 에피소드"
        
        if let image = series.posterImage {
            posterImageView.image = image
        } else {
            posterImageView.backgroundColor = .darkGray
        }
    }
}
