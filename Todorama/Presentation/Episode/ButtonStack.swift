//
//  ButtonStack.swift
//  Todorama
//
//  Created by Claire on 3/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ButtonStack: UIStackView {
    let commentButtonTapped = PublishSubject<Void>()
    
    private let wantToWatchButton = IconLabelButton(
        title: Strings.Global.wantToWatch.text,
        defaultIcon: SystemImages.plus.image,
        toggledIcon: SystemImages.heart.image
    )
    private let commentButton = IconLabelButton(
        title: Strings.Global.comment.text,
        defaultIcon: SystemImages.pencil.image
    )
    private let rateButton = IconLabelButton(
        title: Strings.Global.rate.text,
        defaultIcon: SystemImages.star.image
    )
    
    private let ratingOptions: [Double] = Array(stride(from: 0.0, through: 5.0, by: 0.5)).map { $0 }
    
    private lazy var ratePickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private lazy var rateTextField: UITextField = {
        let textField = UITextField()
        textField.inputView = ratePickerView
        textField.inputAccessoryView = setupInputAccessoryView()
        textField.text = "0.0"
        return textField
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonStack()
        setupRateTextField()
        setupPickerBinding()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtonStack() {
        axis = .horizontal
        distribution = .equalCentering
        spacing = 40
        
        [wantToWatchButton, commentButton, rateButton].forEach { addArrangedSubview($0) }
        
        setupBindings()
    }
    
    private func setupBindings() {
        wantToWatchButton.rx.tap
        
            .subscribe(onNext: { [weak self] in
                print("🌟 WANT TO WATCH")
       
            })
            .disposed(by: disposeBag)
        
        commentButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("🌟 COMMENT")
                self?.commentButtonTapped.onNext(())
            })
            .disposed(by: disposeBag)
        
        rateButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("🌟 RATE")
                self?.showRatePicker()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupRateTextField() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.addSubview(rateTextField)
            rateTextField.isHidden = true
        }
    }
    
    private func setupPickerBinding() {
        Observable.just(ratingOptions)
            .bind(to: ratePickerView.rx.itemTitles) { _, item in
                String(format: "%.1f", item)
            }
            .disposed(by: disposeBag)
        
        ratePickerView.rx.modelSelected(Double.self)
            .subscribe(onNext: { [weak self] selected in
                if let rating = selected.first {
                    self?.rateTextField.text = String(format: "%.1f", rating)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupInputAccessoryView() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        doneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let selectedRating = self.rateTextField.text ?? "0.0"
                print("선택 별점: \(selectedRating)")
                self.rateButton.setRating(selectedRating) // 별점 설정
                self.rateTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.rateTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        return toolbar
    }
    
    private func showRatePicker() {
        rateTextField.becomeFirstResponder()
    }
}
