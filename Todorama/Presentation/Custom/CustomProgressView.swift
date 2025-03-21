//
//  CustomProgressView.swift
//  Todorama
//
//  Created by 권우석 on 3/21/25.
//

import UIKit
import SnapKit

final class CustomProgressView: UIView {
    
    // MARK: - UI Components
    private let progressView = UIProgressView()
    
    // MARK: - Properties
    var progress: Float = 0.0 {
        didSet {
            progressView.progress = progress
        }
    }
    
    var progressTintColor: UIColor = .orange {
        didSet {
            progressView.progressTintColor = progressTintColor
        }
    }
    
    var trackTintColor: UIColor = .lightGray {
        didSet {
            progressView.trackTintColor = trackTintColor
        }
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupProgressView() {
        addSubview(progressView)
        // Cell에서 다음과 같이 사용 (확인 후 지워주세용)
        /*
         customProgressView.snp.makeConstraints {
             $0.leading.trailing.equalToSuperview()
             $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
             $0.bottom.equalToSuperview()
             $0.height.equalTo(8) <- 두께 적당끄
         }
         */
        progressView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        progressView.progressTintColor = progressTintColor
        progressView.trackTintColor = trackTintColor
        progressView.layer.cornerRadius = 1.5
        progressView.clipsToBounds = true
    }
    
    // 프로그레스 값 설정
    func setProgress(_ progress: Float, animated: Bool = true) {
        self.progress = progress
        progressView.setProgress(progress, animated: animated)
    }
}
