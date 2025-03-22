//
//  ArchiveSectionHeaderView.swift
//  Todorama
//
//  Created by 권우석 on 3/21/25.
//

import UIKit
import SnapKit
// 공통로직 사용으로 삭제 예정
final class ArchiveSectionHeaderView: UICollectionReusableView, Identifier {
    static var identifier: String {
           return String(describing: self)
       }
    
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let separatorView = UIView()
    
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
        addSubview(titleLabel)
        addSubview(separatorView)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func configureView() {
        backgroundColor = .black
        
        titleLabel.sectionTitleStyle()
        
        separatorView.backgroundColor = .darkGray
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
