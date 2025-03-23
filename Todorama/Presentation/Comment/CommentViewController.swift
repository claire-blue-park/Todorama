//
//  CommentViewController.swift
//  Todorama
//
//  Created by 권우석 on 3/21/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CommentViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel = CommentViewModel()
    private let disposeBag = DisposeBag()
    
    // 현재 검색어를 저장하는 프로퍼티
    private var currentSearchQuery = BehaviorRelay<String>(value: "")
    
    // MARK: - UI Components
    private let searchContainerView = UIView()
    private let searchBar = UISearchBar()
    private let cancelButton = UIButton()
    
    private let tableView = UITableView()
    private let emptyStateView = UIView()
    private let emptyStateLabel = UILabel()
    private let emptyStateImageView = UIImageView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    // MARK: - Setup
    private func setupNavigation() {
        navigationItem.title = Strings.NavTitle.comment.text
    }
    
    // MARK: - BaseViewController Methods
    override func configureHierarchy() {
        // 검색 영역
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchBar)
        searchContainerView.addSubview(cancelButton)
        
        // 테이블뷰
        view.addSubview(tableView)
        
        // 데이터 없을 때 표시할 뷰
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
    }
    
    override func configureLayout() {
        // 검색 영역 레이아웃
        searchContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(60)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.leading.equalTo(searchBar.snp.trailing)
            make.trailing.equalToSuperview().inset(8)
            make.width.equalTo(52)
        }
        
        // 테이블뷰 레이아웃
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchContainerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // 빈 상태 뷰 레이아웃
        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        emptyStateImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyStateImageView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        // 배경색 설정
        view.backgroundColor = .black
        searchContainerView.backgroundColor = .black
        
        // 검색바 설정
        searchBar.placeholder = "드라마 제목, 줄거리, 코멘트 검색"
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
        searchBar.tintColor = .white
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
            textField.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        }
        
        // 취소 버튼 설정
        cancelButton.setTitle(Strings.Global.cancel.text, for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = Fonts.textFont
        
        // 테이블뷰 설정
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        // 빈 상태 뷰 설정
        emptyStateView.isHidden = true
        emptyStateImageView.image = SystemImages.pencil.image.withRenderingMode(.alwaysTemplate)
        emptyStateImageView.tintColor = .lightGray
        
        emptyStateLabel.text = "검색 결과가 없습니다\n다른 검색어를 입력해보세요"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .lightGray
        emptyStateLabel.font = Fonts.textFont
        emptyStateLabel.numberOfLines = 0
    }
    
    override func bind() {
        // ViewModel Input
        let searchText = searchBar.rx.text.orEmpty.asObservable()
        let cancelTap = cancelButton.rx.tap.asObservable()
        
        // 검색어를 currentSearchQuery에 바인딩
        searchText
            .bind(to: currentSearchQuery)
            .disposed(by: disposeBag)
        
        let input = CommentViewModel.Input(
            viewDidLoad: Observable.just(()),
            searchText: searchText,
            cancelButtonTapped: cancelTap
        )
        
        // ViewModel Output
        let output = viewModel.transform(input: input)
        
        // 코멘트 목록 바인딩 - 검색어 하이라이팅을 위해 cellType으로 설정
        output.comments
            .drive(tableView.rx.items) { [weak self] (tableView, index, item) in
                guard let self = self else { return UITableViewCell() }
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CommentTableViewCell.identifier
                ) as? CommentTableViewCell else {
                    return UITableViewCell()
                }
                
                // 현재 검색어 전달
                cell.configure(with: item, searchQuery: self.currentSearchQuery.value)
                return cell
            }
            .disposed(by: disposeBag)
        
        // 결과 없음 상태 바인딩
        output.isEmpty
            .drive(onNext: { [weak self] isEmpty in
                self?.emptyStateView.isHidden = !isEmpty
                
                // 검색어가 있을 때와 없을 때 다른 메시지 표시
                if !isEmpty || self?.currentSearchQuery.value.isEmpty == true {
                    self?.emptyStateLabel.text = "작성한 코멘트가 없습니다"
                } else {
                    self?.emptyStateLabel.text = "검색 결과가 없습니다\n다른 검색어를 입력해보세요"
                }
            })
            .disposed(by: disposeBag)
        
        // 취소 버튼 탭 처리
        output.clearSearchText
            .drive(onNext: { [weak self] _ in
                self?.searchBar.text = ""
                self?.currentSearchQuery.accept("")
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        // 셀 선택 처리
        tableView.rx.modelSelected(CommentItem.self)
            .subscribe(onNext: { [weak self] comment in
                print("Selected comment: \(comment.title)")
                // TODO: 상세 화면으로 이동
            })
            .disposed(by: disposeBag)
    }
}
