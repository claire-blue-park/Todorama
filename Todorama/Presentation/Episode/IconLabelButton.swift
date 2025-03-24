//
//  IconLabelButton.swift
//  Todorama
//
//  Created by Claire on 3/24/25.
//

import UIKit
import RxSwift
import SnapKit

final class IconLabelButton: UIButton {
    private let iconImageView = UIImageView()
    private let label = UILabel()
    private let disposeBag = DisposeBag()
    
    var isToggled = false {
        didSet {
            updateAppearance()
        }
    }
    
    private var rating: String? {
        didSet {
            updateRatingAppearance()
        }
    }
    
    private let defaultIcon: UIImage
    
    init(title: String, defaultIcon: UIImage, toggledIcon: UIImage? = nil) {
        self.defaultIcon = defaultIcon
        super.init(frame: .zero)
        setupUI(title: title, defaultIcon: defaultIcon)
        setupBindings(toggledIcon: toggledIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String, defaultIcon: UIImage) {
        iconImageView.image = defaultIcon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .tdGray
        
        label.text = title
        label.accessoryStyle()
        label.textColor = .tdGray
        label.textAlignment = .center
        
        addSubview(iconImageView)
        addSubview(label)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        backgroundColor = .clear
    }
    
    private func setupBindings(toggledIcon: UIImage?) {
        rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isToggled.toggle()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateAppearance() {
        if isToggled {
//            iconImageView.image = SystemImages.heart.image
            iconImageView.tintColor = .tdMain
            label.textColor = .tdMain
        } else {
//            iconImageView.image = defaultIcon
            iconImageView.tintColor = .tdGray
            label.textColor = .tdGray
        }
    }
    
    private func updateRatingAppearance() {
        if let rating = rating {
            label.text = rating
            iconImageView.tintColor = .tdMain
            label.textColor = .tdMain
        } else {
            label.text = Strings.Global.rate.text
            iconImageView.tintColor = .tdGray
            label.textColor = .tdGray
        }
    }

    func setRating(_ rating: String?) {
        self.rating = rating
    }
}
