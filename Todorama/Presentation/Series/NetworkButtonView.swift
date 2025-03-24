//
//  NetworkButtonView.swift
//  Todorama
//
//  Created by Claire on 3/25/25.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit

final class NetworkButtonView: UIView {
    private let disposeBag = DisposeBag()
    
    private let logoImageView = UIImageView()
    private let button = UIButton(type: .custom)
    private let chevron = UIImageView()
    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(logoImageView)
        addSubview(button)
        addSubview(chevron)
    }
    
    private func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(18)
        }
        
        chevron.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        backgroundColor = .tdDarkGray
        layer.cornerRadius = 6
        clipsToBounds = true
        
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        
        chevron.contentMode = .scaleAspectFit
        chevron.image = SystemImages.chevron.right.image
        chevron.tintColor = .tdMain
        
        button.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.onTap?()
            })
            .disposed(by: disposeBag)
    }
    
    func configure(with network: Network) {
        let url = URL(string: ImageSize.profile185(url: network.logo_path).fullUrl)
        logoImageView.kf.setImage(with: url, placeholder: nil)
        
    }
 
}
