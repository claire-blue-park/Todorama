//
//  PosterCollectionViewCell.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import UIKit
import SnapKit

final class PosterCollectionViewCell: UICollectionViewCell {
    private let stackView = UIStackView()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(imageView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.horizontalEdges.equalToSuperview()
        }
        label.isHidden = true
        imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with imageName: String) {
        imageView.image = UIImage(systemName: imageName)
        imageView.backgroundColor = .red
    }
}
