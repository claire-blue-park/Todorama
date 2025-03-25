//
//  ButtonStack.swift
//  Todorama
//
//  Created by Claire on 3/22/25.
//

import UIKit
import SnapKit
import RealmSwift
import RxSwift
import RxCocoa

final class ButtonStack: UIStackView {
    private let series: Series
    private let disposeBag = DisposeBag()
    
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
    
    init(series: Series) {
        self.series = series
        super.init(frame: .zero)
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
        // 보고싶어요 버튼
        wantToWatchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let realm = try! Realm()
            
                let genreId = series.genres.first?.id ?? 00
                let drama = Drama(dramaId: series.id, name: series.name, backdropPath: series.backdrop_path ?? "", genre: genreId)
                
                let wishListItem = WishList(drama: drama)

                let existingItem = realm.objects(WishList.self).filter("drama.dramaId == %@", series.id).first
                
                try! realm.write {
                    if let itemToDelete = existingItem {
                        realm.delete(itemToDelete)
                        print("WishList에서 삭제됨: \(drama.name)")
                    } else {
                        realm.add(wishListItem, update: .modified)
                        print("WishList에 추가됨: \(drama.name)")
                    }
                }            })
            .disposed(by: disposeBag)
        
        // 코멘트 버튼
        commentButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.commentButtonTapped.onNext(())
            })
            .disposed(by: disposeBag)
        
        // 별점 버튼
        rateButton.rx.tap
            .subscribe(onNext: { [weak self] in
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
                self.rateButton.setRating(selectedRating)
                self.rateTextField.resignFirstResponder()
                
                let realm = try! Realm()
                // series를 사용해 Drama 객체 생성
                let genreId = self.series.genres.first?.id ?? 0
                let drama = Drama(dramaId: self.series.id, name: self.series.name, backdropPath: self.series.backdrop_path ?? Strings.Global.empty.text, genre: genreId)
                let rating = Rating(drama: drama, rate: Double(selectedRating) ?? 0.0, posterPath: nil)
                
                try! realm.write {
                    realm.add(rating, update: .modified)
                }
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
