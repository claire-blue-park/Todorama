//
//  EditingCommentViewController.swift
//  Todorama
//
//  Created by Claire on 3/20/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EditingCommentViewController: BaseViewController {
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .tdDarkGray
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 4
        textView.font = Fonts.textFont
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        textView.textColor = .tdGray
        return textView
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/500"
        label.textStyle()
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        view.addSubview(commentTextView)
        view.addSubview(characterCountLabel)
    }
    
    override func configureLayout() {
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(400)
        }
        
        characterCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(commentTextView.snp.trailing).offset(-8)
            make.bottom.equalTo(commentTextView.snp.bottom).offset(-8)
        }
    }
    
    override func bind() {
        let maxCharacterCount = 500
        
        commentTextView.rx.text.orEmpty
            .map { text -> String in
                let trimmedText = String(text.prefix(maxCharacterCount))
                return trimmedText
            }
            .bind(to: commentTextView.rx.text)
            .disposed(by: disposeBag)
        
        commentTextView.rx.text.orEmpty
            .map { text -> String in
                "\(text.count)/\(maxCharacterCount)"
            }
            .bind(to: characterCountLabel.rx.text)
            .disposed(by: disposeBag)

    }
}
