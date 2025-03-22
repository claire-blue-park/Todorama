//
//  ArchiveCollectionViewCell.swift
//  Todorama
//
//  Created by 권우석 on 3/21/25.
//

import UIKit
import SnapKit
import Kingfisher

final class ArchiveContentCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let customProgressView = CustomProgressView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func configureHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(customProgressView)
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(thumbnailImageView.snp.width).multipliedBy(1.2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }
        
        customProgressView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(8)
        }
    }
    
    private func configureView() {
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.backgroundColor = .darkGray
        
        titleLabel.dramaTitleStyle()
        titleLabel.numberOfLines = 1
        
        categoryLabel.textStyle()
        categoryLabel.textColor = .lightGray
        categoryLabel.numberOfLines = 1
        
        // 기본적으로 프로그레스바 숨김
        customProgressView.isHidden = true
    }
    
    func configure(with model: ContentModel, showProgress: Bool = false, progress: Float = 0.0) {
        titleLabel.text = model.title
        categoryLabel.text = model.category
        
        if let url = URL(string: model.imageURL) {
            thumbnailImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            
            thumbnailImageView.image = UIImage(named: model.imageURL) ?? UIImage(named: "placeholder")
        }
        
        customProgressView.isHidden = !showProgress
        if showProgress {
            customProgressView.setProgress(progress, animated: false)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        categoryLabel.text = nil
        thumbnailImageView.image = nil
        thumbnailImageView.kf.cancelDownloadTask()
        customProgressView.isHidden = true
        customProgressView.setProgress(0, animated: false)
    }
}
