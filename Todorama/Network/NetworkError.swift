//
//  NetworkError.swift
//  Todorama
//
//  Created by 최정안 on 3/22/25.
//

import Foundation

enum NetworkError: Error {
    case badRequest // 400
    case unauthorized // 401
    case forbidden // 403
    case notFound // 404
    case methodNotAllowed // 405
    case unprocessableEntity // 422
    case internalServerError // 500
    case badGateway // 502
    case serviceUnavailable // 503
    case gatewayTimeout // 504
    case tooManyRequests // 429
    case customError(code: Int, message: String) // 기타 에러
    
    var errorMessage: String {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        case .unauthorized:
            return "인증이 실패했습니다. 유효한 API 키를 제공해야 합니다."
        case .forbidden:
            return "권한이 없습니다."
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다."
        case .methodNotAllowed:
            return "해당 리소스에서는 지원되지 않는 HTTP 메서드입니다."
        case .unprocessableEntity:
            return "유효하지 않은 요청입니다. 요청 매개변수를 확인하세요."
        case .internalServerError:
            return "서버 내부 오류가 발생했습니다."
        case .badGateway:
            return "서버 게이트웨이 오류가 발생했습니다."
        case .serviceUnavailable:
            return "서버가 유지보수 중이거나 과부하 상태입니다."
        case .gatewayTimeout:
            return "서버 응답 시간이 초과되었습니다."
        case .tooManyRequests:
            return "요청 횟수가 허용된 한도를 초과했습니다."
        case .customError(_, let message):
            return message
        }
    }
}
