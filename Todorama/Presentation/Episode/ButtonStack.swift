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
    // 코멘트 버튼 클릭 이벤트 방출
    let commentButtonTapped = PublishSubject<Void>()
    
    private let wantToWatchButton = UIButton()
    private let commentButton = UIButton()
    private let rateButton = UIButton()
    
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
        
        let buttons = [
            setupRxButton(wantToWatchButton, title: Strings.Global.wantToWatch.text, icon: SystemImages.plus.image),
            setupRxButton(commentButton, title: Strings.Global.comment.text, icon: SystemImages.pencil.image),
            setupRxButton(rateButton, title: Strings.Global.rate.text, icon: SystemImages.star.image)
        ]
        
        buttons.forEach { addArrangedSubview($0) }
        
        setupBindings()
    }
    
    private func setupRxButton(_ button: UIButton, title: String, icon: UIImage) -> UIView {
        let container = UIView()
        
        let iconImageView = UIImageView()
        iconImageView.image = icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .tdGray
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.accessoryStyle()
        titleLabel.textColor = .tdGray
        titleLabel.textAlignment = .center
        
        container.addSubview(iconImageView)
        container.addSubview(titleLabel)
        container.addSubview(button)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.backgroundColor = .clear
        
        return container
    }
    
    private func setupBindings() {
        wantToWatchButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                print("🌟 WANT TO WATCH")
            })
            .disposed(by: disposeBag)
        
        commentButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                print("🌟 COMMENT")
                owner.commentButtonTapped.onNext(())
            })
            .disposed(by: disposeBag)
        
        rateButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                print("🌟 RATE")
                owner.showRatePicker()
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
                print("선택 별점: \(self.rateTextField.text ?? "0.0")")
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
