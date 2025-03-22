//
//  NetworkManager.swift
//  Todorama
//
//  Created by Claire on 3/20/25.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callRequest<T:Decodable>(target: NetworkRouter,model: T.Type) -> Observable<T> {
        return Observable<T>.create { value in
            AF.request(target)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let result) :
                        value.onNext(result)
                    case .failure(let error) :
                        let code = response.response?.statusCode
                        value.onError(self.getError(code: code ?? 501))
                        // statusCode를 받아서 해당되는 NetworkError를 방출
                        print(T.self, error)
                        
                    }
                }
            return Disposables.create()
        }
    }
    private func getError(code: Int) -> NetworkError {

        switch code {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 405:
            return .methodNotAllowed
        case 422:
            return .unprocessableEntity
        case 500:
            return .internalServerError
        case 502:
            return .badGateway
        case 503:
            return .serviceUnavailable
        case 504:
            return .gatewayTimeout
        case 429:
            return .tooManyRequests
        default:
            return .customError(code: code, message: "알 수 없는 오류가 발생했습니다. (코드: \(code))")
        }
    }
}
