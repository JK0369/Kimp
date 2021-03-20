//
//  MoyaProviderTypeExtension.swift
//  Domain
//
//  Created by 김종권 on 2021/03/19.
//

import Foundation
import Moya
import RxSwift

// 에러 처리를 위한 커스텀 reqeust
// 아래 1~3먼저 정의 후 extension

// 1. BaseResponsable: api호출 reponse에서 success, error 둘 중 responseCode를 error로 보내는 로직 정의
// 2. BaseResponse: 기본 response형식
// 3. BaseServiceError: Error타입 정의

public extension Reactive where Base: MoyaProviderType {
    func request<D: BaseResponsable>(_ token: Base.Target, callbackQueue: DispatchQueue? = nil, response type: D.Type) -> Single<D> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case let .success(response):
                    do {
                        let response = try response.filterSuccessfulStatusCodes()
                        let checkResponse = try response.map(BaseResponse.self)
                        try checkResponse.filterSuccessfulResponseCode()

                        let result = try response.map(type)
                        single(.success(result))
                    } catch let error {
                        if error is BaseServiceError {
                            single(.error(error))
                        } else if let moyaError = error as? MoyaError {
                            guard case let .statusCode(response) = moyaError else {
                                single(.error(BaseServiceError.moyaError(moyaError)))
                                return
                            }

                            if response.statusCode == 401 {
                                single(.error(BaseServiceError.tokenExpired))
                            } else {
                                if let checkResponse = try? response.map(BaseResponse.self) {
                                    single(.error(BaseServiceError.invalidResponse(responseCode: checkResponse.responseCode, message: checkResponse.message)))
                                } else {
                                    single(.error(BaseServiceError.moyaError(moyaError)))
                                }
                            }
                        }
                    }
                case let .failure(error):
                    let tapError = BaseServiceError.moyaError(error)
                    single(.error(tapError))
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}
