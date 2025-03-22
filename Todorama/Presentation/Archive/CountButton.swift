//
//  CountButton.swift
//  Todorama
//
//  Created by 권우석 on 3/21/25.
//

import UIKit
import SnapKit

final class CountButton: UIButton {
    
    let countLabel = UILabel()
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    convenience init(count: Int, name: String, isInteractive: Bool = false) {
        self.init(frame: .zero)
        countLabel.text = "\(count)"
        nameLabel.text = name
        // 색상 설정
        countLabel.textColor = .tdWhite
        nameLabel.textColor = .tdWhite
        // 상호작용 설정
        isUserInteractionEnabled = isInteractive
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        // 스택뷰 생성
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        addSubview(stackView)
        
        // 스택뷰 레이아웃
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 라벨 설정 및 스택뷰에 추가
        countLabel.countStyle()
        nameLabel.textStyle()
        
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(nameLabel)
    }
    
    // 버튼 상태 업데이트
    func updateCount(count: Int) {
        countLabel.text = "\(count)"
    }
}
