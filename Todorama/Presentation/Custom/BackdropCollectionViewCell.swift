//
//  BackdropCollectionViewCell.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import UIKit
import SnapKit

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    private func configureView() {
        contentView.addSubview(backdropImageView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(progressView) // 프로그레스 뷰 추가
        setupLayout()
        
        titleLabel.dramaTitleStyle()
        genreLabel.textStyle()
        
        // 프로그레스 뷰 초기 설정
        progressView.progressTintColor = .tdMain
        progressView.trackTintColor = .tdGray
        progressView.isHidden = true // 기본적으로 숨김 처리
    }
    
    private func setupLayout() {
        // 기본 레이아웃 설정 (프로그레스 뷰 숨김 상태 기준)
        backdropImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: BackDrop? = nil) {
        configure(item: item, progress: 0, showProgress: false)
    }
    
    func configure(item: BackDrop? = nil, progress: Float) {
        configure(item: item, progress: progress, showProgress: true)
    }
    
    private func configure(item: BackDrop? = nil, progress: Float = 0.0, showProgress: Bool = false) {
        if let item {
            if let imagePath = item.imagePath, !imagePath.isEmpty {
                let imageBase = "https://image.tmdb.org/t/p/w500"
                let url = URL(string: imageBase + imagePath)
                backdropImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "film"), options: nil, completionHandler: { result in
                    switch result {
                    case .success(_):
                        // 이미지 로드 성공
                        break
                    case .failure(_):
                        // 이미지 로드 실패 시 기본 이미지 설정
                        self.backdropImageView.image = UIImage(systemName: "film")
                        self.backdropImageView.contentMode = .scaleAspectFit
                        self.backdropImageView.tintColor = .white
                    }
                })
            } else {
                backdropImageView.image = UIImage(systemName: "film")
                backdropImageView.contentMode = .scaleAspectFit
                backdropImageView.tintColor = .white
            }
            titleLabel.text = item.name
            genreLabel.text = item.genre
        } else {
            backdropImageView.image = UIImage(systemName: "star")
            titleLabel.text = "title"
            genreLabel.text = "Genre"
        }
        
        // 프로그레스 표시 여부 설정
        progressView.isHidden = !showProgress
        
        // 프로그레스 뷰 설정 (보여질 경우만)
        if showProgress {
            progressView.setProgress(progress, animated: false)
        }
    }
}
