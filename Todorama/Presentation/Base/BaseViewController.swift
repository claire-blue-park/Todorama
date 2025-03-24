//
//  BaseViewController.swift
//  Todorama
//
//  Created by Claire on 3/20/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
        
        navigationController?.navigationBar.topItem?.backButtonTitle = Strings.Global.empty.text
        navigationController?.navigationBar.tintColor = .tdMain
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }
    
    
    // MARK: - View 계층 구조 설정
    func configureHierarchy() { }
    // MARK: - View 레이아웃 설정
    func configureLayout() { }
    // MARK: - 프로퍼티 속성 설정
    func configureView() { }
    // MARK: - Rx Bind 메서드 실행
    func bind() { }
}
