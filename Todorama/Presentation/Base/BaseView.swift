//
//  BaseView.swift
//  Todorama
//
//  Created by Claire on 3/20/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    // MARK: - View 계층 구조 설정
    func configureHierarchy() {}
    // MARK: - View 레이아웃 설정
    func configureLayout() {}
    // MARK: - 프로퍼티 속성 설정
    func configureView() {}
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
