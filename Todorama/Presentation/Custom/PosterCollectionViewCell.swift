//
//  PosterCollectionViewCell.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import UIKit
import Kingfisher
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
        configureView()
    }
    private func configureView() {
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
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
        label.font = Fonts.textFont
        label.isHidden = true
        self.imageView.layer.cornerRadius = 8
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with imageName: String?, rate: Double? = nil) {
        if let imageName  {
            let imageBase = "https://image.tmdb.org/t/p/w500"
            let url = URL(string: imageBase + imageName)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "star")
        }

        if let rate {
            label.isHidden = false
            configureRateLabel(rate)
        }
        else {
            label.isHidden = true
        }
    }
    private func configureRateLabel(_ rate: Double) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = SystemImages.star.image.withRenderingMode(.alwaysTemplate).withTintColor(.tdGray)
        imageAttachment.bounds = CGRect(x: 0, y: -1, width: 10, height: 10)
        let attributedString = NSMutableAttributedString(string: String(rate), attributes: [
            .foregroundColor: UIColor.tdGray, .font : Fonts.textFont
        ])
        let stringWithStar = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageAttachment))
        stringWithStar.append(attributedString)
        label.attributedText = stringWithStar
    }
}
