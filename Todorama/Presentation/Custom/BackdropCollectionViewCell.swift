//
//  BackdropCollectionViewCell.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import UIKit
import SnapKit
import Kingfisher

class BackdropCollectionViewCell: UICollectionViewCell {

    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    private let progressView = CustomProgressView() // 프로그레스 뷰 추가
    private let emptyTitleLabel = UILabel() // 이미지가 없을 때 제목 표시용 label 추가
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(backdropImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(progressView) // 프로그레스 뷰 추가
        
        // emptyTitleLabel 설정
        contentView.addSubview(emptyTitleLabel)
        emptyTitleLabel.navTitleStyle() // 요청대로 navTitleStyle 적용
        emptyTitleLabel.textAlignment = .center
        emptyTitleLabel.numberOfLines = 2
        emptyTitleLabel.isHidden = true // 기본적으로 숨김
        
        backdropImageView.layer.cornerRadius = 8
        backdropImageView.clipsToBounds = true
        
        setupLayout()
        
        titleLabel.dramaTitleStyle()
        genreLabel.textStyle()
        
        // 프로그레스 뷰 초기 설정
        progressView.progressTintColor = .tdMain
        progressView.trackTintColor = .tdGray
        progressView.isHidden = true // 기본적으로 숨김 처리
        
        // 그라데이션 설정
        setupGradient()
    }
    
    private func setupLayout() {
        // 기본 레이아웃 설정 (프로그레스 뷰 숨김 상태 기준)
        backdropImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
        
        // emptyTitleLabel 레이아웃
        emptyTitleLabel.snp.makeConstraints { make in
            make.center.equalTo(backdropImageView)
            make.horizontalEdges.equalTo(backdropImageView).inset(8)
        }
        
        // 프로그레스 뷰 레이아웃
        progressView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(8)
            make.bottom.equalTo(backdropImageView.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalTo(genreLabel.snp.top)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(17)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.6).cgColor
        ]
        gradientLayer.locations = [0.6, 1.0]
        
        // 이미지뷰에 그라데이션 레이어 추가
        backdropImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 그라데이션 레이어 프레임 업데이트
        gradientLayer.frame = backdropImageView.bounds
    }
    
    func configure(item: BackDrop? = nil) {
        configure(item: item, progress: 0, showProgress: false)
    }
    
    func configure(item: BackDrop? = nil, progress: Float) {
        configure(item: item, progress: progress, showProgress: true)
    }
    
    private func configure(item: BackDrop? = nil, progress: Float = 0.0, showProgress: Bool = false) {
        emptyTitleLabel.isHidden = true
        backdropImageView.isHidden = false
        gradientLayer.isHidden = false
        
        if let item {
            titleLabel.text = item.name
            genreLabel.text = item.genre
            
            if let imagePath = item.imagePath, !imagePath.isEmpty {
                // TMDBRequest의 ImageSize enum 활용
                let fullUrl = ImageSize.poster154(url: imagePath).fullUrl
                let url = URL(string: fullUrl)
                
                backdropImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "film"), options: nil, completionHandler: { result in
                    switch result {
                    case .success(_):
                        // 이미지 로드 성공
                        self.backdropImageView.contentMode = .scaleAspectFill
                        break
                    case .failure(_):
                        // 이미지 로드 실패 시 제목 표시
                        self.showEmptyState(with: item.name)
                    }
                })
            } else {
                // 이미지가 없는 경우 제목 표시
                showEmptyState(with: item.name)
            }
        } else {
            showEmptyState(with: "title")
            genreLabel.text = "Genre"
        }
        
        // 프로그레스 표시 여부 설정
        progressView.isHidden = !showProgress
        
        // 프로그레스 뷰 설정 (보여질 경우만)
        if showProgress {
            progressView.setProgress(progress, animated: false)
        }
    }
    
    private func showEmptyState(with title: String) {
        backdropImageView.image = nil
        backdropImageView.backgroundColor = .tdDarkGray
        emptyTitleLabel.isHidden = false
        emptyTitleLabel.text = title
        gradientLayer.isHidden = true // 그라데이션 숨김
    }
    
    // 진행률만 따로 설정하는 메서드 추가
    func setProgress(_ progress: Float) {
        if progress > 0 && progress < 1 {
            progressView.isHidden = false
            progressView.setProgress(progress, animated: true)
        } else {
            progressView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backdropImageView.image = nil
        backdropImageView.backgroundColor = .clear
        titleLabel.text = nil
        genreLabel.text = nil
        emptyTitleLabel.isHidden = true
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
}
