//
//  SectionTitleView.swift
//  Todorama
//
//  Created by 최정안 on 3/21/25.
//

import UIKit
import SnapKit

final class SectionTitleView: UIView {
    private let label = UILabel()
    var title: String {
        didSet {
            label.text = title
        }
    }
    private var labelUnderline: CALayer?
    
    override init(frame: CGRect) {
        self.title = Strings.Global.empty.text
        super.init(frame: frame)
        setupView()
    }
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupView()
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let screenSize = window.screen.bounds
        frame = CGRect(x: 0, y: 44, width: screenSize.width, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .black

        label.text = title
        label.sectionTitleStyle()
        label.textColor = .tdWhite
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let viewUnderline = underLine(width: frame.width, height: frame.height, color: .tdGray)
        self.layer.addSublayer(viewUnderline)
        
        labelUnderline = underLine(width: label.frame.width, height: label.frame.height, color: .tdWhite, borderW: 2)
        if let labelUnderline = labelUnderline {
            label.layer.addSublayer(labelUnderline)
        }
    }
    
    func underLine(width: CGFloat, height: CGFloat, color: UIColor, borderW: CGFloat = 1) -> CALayer {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: height - borderW, width: width, height: borderW)
        border.backgroundColor = color.cgColor
        return border
    }
}
