//
//  Error.swift
//  TapRider
//
//  Created by 김종권 on 2020/07/17.
//  Copyright © 2020 42dot.ai. All rights reserved.
//

import Foundation
import Domain
import Moya

extension Error {

    var errorString: String {
        return "\(self)"
    }

    func isNetworkError() -> Bool? {
        let moyaError = self as? MoyaError
        let tapServiceError = self as? BaseServiceError

        if let moyaError = moyaError {
            return checkNetworkError(moyaError: moyaError)
        } else if case let .moyaError(moyaError) = tapServiceError {
            return checkNetworkError(moyaError: moyaError)
        } else {
            return nil
        }
    }

    private func checkNetworkError(moyaError: MoyaError) -> Bool? {
        if case let .underlying(underlyingError, _) = moyaError {
            guard let responseCode = (underlyingError.asAFError?.underlyingError as? URLError)?.code else {
                return nil
            }
            switch responseCode {
            case .notConnectedToInternet, // wifi 차단
                 .dataNotAllowed: // 5G, LTE가 활성화 되는 유심이 있는 디바이스에서 wifi와 데이터 차단한 경우
                return true
            default:
                return false
            }
        } else {
            return nil
        }
    }
}
