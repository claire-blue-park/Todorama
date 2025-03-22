//
//  ButtonStack.swift
//  Todorama
//
//  Created by Claire on 3/22/25.
//

import UIKit
import SnapKit
//
//final class labelButton: UIView {
//    private var label: String?
//    private var image: UIImage?
//    
//    
//    init(label: String, image: UIImage) {
//        self.label = label
//        self.image = image
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    let iconImageView = UIImageView()
//    iconImageView.image = image
//    iconImageView.contentMode = .scaleAspectFit
//    iconImageView.tintColor = .tdGray
//    
//  
//    titleLabel.text = label
//    titleLabel.textStyle()
//    titleLabel.textColor = .tdGray
//    titleLabel.textAlignment = .center
//}

final class ButtonStack: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButtonStack()

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtonStack() {
        axis = .horizontal
        distribution = .equalCentering
        spacing = 40
        
        let buttons: [(title: String, icon: UIImage)] = [
            (Strings.Global.wantToWatch.text, SystemImages.plus.image),
            (Strings.Global.comment.text, SystemImages.pencil.image),
            (Strings.Global.rate.text, SystemImages.star.image)
        ]
        
        for (title, icon) in buttons {
            let button = setButton(title: title, icon: icon)
            addArrangedSubview(button)
        }
    }
    
    private func setButton(title: String, icon: UIImage) -> UIView {
        let container = UIView()
        
        let iconImageView = UIImageView()
        iconImageView.image = icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .tdGray
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.accessoryStyle()
        titleLabel.textColor = .tdGray
        titleLabel.textAlignment = .center
        
        container.addSubview(iconImageView)
        container.addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        return container
    }
}
