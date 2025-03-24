import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ButtonStack: UIStackView {
    private let wantToWatchButton = UIButton()
    private let commentButton = UIButton()
    private let rateButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonStack()
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
                print("보고싶어요 클릭")
            })
            .disposed(by: disposeBag)
        
        commentButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                print("코멘트 클릭")
            })
            .disposed(by: disposeBag)
        
        rateButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                print("별점 클릭")
            })
            .disposed(by: disposeBag)
    }
}
