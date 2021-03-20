//
//  ErrorHandleable.swift
//  BaseProject
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation
import RxSwift
import RxCocoa
import Domain
import Moya
import Alamofire
import FirebaseAuth

enum CommonErrorType {
    case notConnectedToInternet
    case tokenExpired
    case unknown(ErrorData)
    case defaultUnknown(ErrorData)
}

public struct ErrorData {
    let title: String?
    let message: String

    init(title: String? = nil, message: String) {
        self.title = title
        self.message = message
    }
}

protocol ErrorHandleable {
    var showError: PublishRelay<CommonErrorType> { get }

    func handleError(_ error: Error)
}

extension ErrorHandleable {

    func handleError(_ error: Error) {
        switch error as? BaseServiceError {
        case .invalidResponse:
            showServerError(error)
        default:
            showUnknownError(error)
        }
    }

    func showServerError(_ error: Error) {
        let data = ErrorData(title: R.string.localizable.serverError(), message: error.localizedDescription)
        showError.accept(.unknown(data))
    }

    func showUnknownError(_ error: Error) {
        showError.accept(errorType(error))
    }

    private func errorType(_ error: Error) -> CommonErrorType {
        if let firebaseAuthNetworkErorr = checkFirebaseAuthNetworkError(error) {
            return firebaseAuthNetworkErorr
        } else if let isNetworkError = error.isNetworkError(), isNetworkError {
            return .notConnectedToInternet
        } else if let baseError = error as? BaseServiceError {
            switch baseError {
            case .tokenExpired, .refreshTokenExpired:
                return .tokenExpired
            default:
                return checkCommonError(error)
            }
        } else {
            return checkCommonError(error)
        }
    }

    private func checkFirebaseAuthNetworkError(_ error: Error) -> CommonErrorType? {
        if case .networkError = AuthErrorCode(rawValue: (error as NSError).code) {
            return .notConnectedToInternet
        } else {
            return nil
        }
    }

    private func checkCommonError(_ error: Error) -> CommonErrorType {
        var data = ErrorData(title: R.string.localizable.error(), message: error.localizedDescription)

        guard case let .moyaError(moyaError) = error as? BaseServiceError else {
            return .unknown(data)
        }

        if case let .statusCode(response) = moyaError {
            let title: String
            let errorMessage: String
            switch response.statusCode {
            case 500...599:
                title = R.string.localizable.serverError()
                if let message = String(data: response.data, encoding: .utf8), !message.isEmpty {
                    errorMessage = message + "(\(response.statusCode))"
                } else {
                    errorMessage = R.string.localizable.errorServerDefaultMessage() + "(\(response.statusCode))"
                }
            default:
                title = R.string.localizable.error()
                if let message = String(data: response.data, encoding: .utf8), !message.isEmpty {
                    errorMessage = message + "(\(response.statusCode))"
                } else {
                    errorMessage = R.string.localizable.errorTemporary() + "(\(response.statusCode))"
                }
            }

            data = ErrorData(title: title, message: errorMessage)
        }

        guard case let .underlying(underlyingError, _) = moyaError else {
            return .unknown(data)
        }

        if let responseCode = (underlyingError.asAFError?.underlyingError as? URLError)?.code {
            switch responseCode {
            case .notConnectedToInternet:
                return .notConnectedToInternet
            default:
                return .unknown(data)
            }
        } else {
            return .unknown(data)
        }
    }

}

/* 사용하는 쪽
 // MARK: - HandleError

 extension SplashVM {
     func handleError(_ error: Error) {
         if case let .invalidResponse(responseCode, _) = error as? BaseServiceError {
             let responseCodeType = ResponseCodeType(rawValue: responseCode)
             switch responseCodeType {
             case .notValidToken:
                 let refreshToken = dependencies.keychain.getUserRefreshToken()
                 if !refreshToken.isEmpty {
                     requestUserInfoWithRefreshToken()
                 } else {
                     routeToNextScene(isSuccessLogin: false)
                 }
             case .requestAuthTokenNotValidToken:
                 routeToNextScene(isSuccessLogin: false)
             default:
                 showServerError(error)
             }
         } else {
             showUnknownError(error)
         }
     }
 }
 */
