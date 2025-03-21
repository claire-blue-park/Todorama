//
//  SectionHeaderView.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"

    private let titleView = SectionTitleView(title: "Section1Section2")

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleView)
        
        titleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    func configure(with title: String) {
//        titleView.title = "Section1"
//    }

}

