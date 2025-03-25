//
//  EditingCommentViewController.swift
//  Todorama
//
//  Created by Claire on 3/20/25.
//

import UIKit
import SnapKit
import RealmSwift
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
    
    override func configureView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
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
                .map { !$0.isEmpty }
                .bind(to: navigationItem.rightBarButtonItem!.rx.isEnabled)
                .disposed(by: disposeBag)

        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let realm = try! Realm()
                let drama = Drama() // 데이터 필요
                let comment = Comment(drama: drama, comment: self.commentTextView.text)
                
                try! realm.write {
                    realm.add(comment, update: .modified)
                }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

    }
}
