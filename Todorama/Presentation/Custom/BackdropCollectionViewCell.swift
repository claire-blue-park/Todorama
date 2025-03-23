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
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()

    }
    private func configureView() {
        contentView.addSubview(backdropImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)
        genreLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(17)
            make.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalTo(genreLabel.snp.top)
        }
        backdropImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
        }
        titleLabel.dramaTitleStyle()
        genreLabel.textStyle()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backdropImageView.image = SystemImages.check.image
        titleLabel.text = "title"
        genreLabel.text = "genre"
    }
}
