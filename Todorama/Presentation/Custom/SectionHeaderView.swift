//
//  SectionHeaderView.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import UIKit
import SnapKit

final class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"

    private let titleView = SectionTitleView(title: Strings.Global.empty.text)
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    private func configureView() {
        addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with title: String) {
        titleView.title = title
    }

}

