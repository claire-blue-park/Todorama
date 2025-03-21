//
//  BaseViewModel.swift
//  Todorama
//
//  Created by Claire on 3/20/25.
//

import Foundation
import RxCocoa
import RxSwift

protocol BaseViewModel {
    var disposeBag: DisposeBag { get }
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
