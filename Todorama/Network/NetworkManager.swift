//
//  NetworkManager.swift
//  Todorama
//
//  Created by Claire on 3/20/25.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkRouter: URLRequestConvertible {
    case popular
    case trending
    case recommendation(id: Int)
    case search(query: String, page: Int)
    case series(id: Int)
    case episode(id: Int, season: Int)
    
    var baseURL: URL {//1396
        switch self {
        case .popular:
            return URL(string: "https://api.themoviedb.org/3/tv/top_rated")!
        case .trending:
            return URL(string: "https://api.themoviedb.org/3/trending/tv/day")!
        case .recommendation(let id):
            return URL(string: "https://api.themoviedb.org/3/tv/\(id)/recommendations")!
        case .search:
            return URL(string: "https://api.themoviedb.org/3/search/tv")!
        case .series(let id):
            return URL(string: "https://api.themoviedb.org/3/tv/\(id)")!
        case .episode(let id, let season):
            return URL(string: "https://api.themoviedb.org/3/tv/\(id)/season/\(season)")!
        }
    }
    var header: HTTPHeaders {
        return ["Authorization": "Bearer \(APIKey.token)" ]
    }
    var path: String {
        return ""
    }
    var method: HTTPMethod {
        return .get
    }
    var parameters: Parameters {
        switch self {
        case .popular, .trending,.recommendation, .series, .episode:
            return ["language":"ko-KR"]
        case .search(let query, let page):
            return ["query": query, "page": page]
        }
    }
    func asURLRequest() throws -> URLRequest {
        var urlString = baseURL.absoluteString
        urlString += path
        var request = URLRequest(url: URL(string: urlString)!)
        request.headers = header
        request.method = method
        let urlRequest = try URLEncoding.default.encode(request, with: parameters)
        return urlRequest
    }
    
}

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
                        value.onError(self.getErrorMessage(code: code ?? 501))
                        print(T.self, error)
                        
                    }
                }
            return Disposables.create()
        }
    }
    private func getErrorMessage(code: Int) -> NetworkError {

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
