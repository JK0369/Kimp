//
//  BaseService.swift
//  BaseProject
//
//  Created by 김종권 on 2021/01/27.
//

import Foundation
import Domain
import Moya
import RxSwift
import Firebase

final class BaseService<Target: BaseTargetType> {
    private var provider = MoyaProvider<Target>.makeProvider()
    let keyValueStore: KeyValueStore
    let appConfigurable: AppServiceConfigurable
    let authProvider: MoyaProvider<AccountTarget>
    let firebaseAuth: Auth
    let isTest: Bool
    let maxAttempts = 1

    static func makeProvider() -> BaseService<Target> {
        return BaseService<Target>(keyValueStore: KeychainService.shared,
                                   appConfigurable: AppServiceSetting.shared,
                                   authProvider: MoyaProvider<AccountTarget>.makeProvider(),
                                   customProvider: nil,
                                   firebaseAuth: Auth.auth(),
                                   isTest: false)
    }

    init(keyValueStore: KeyValueStore,
         appConfigurable: AppServiceConfigurable,
         authProvider: MoyaProvider<AccountTarget>,
         customProvider: MoyaProvider<Target>? = nil,
         firebaseAuth: Auth,
         isTest: Bool = false) {
        self.keyValueStore = keyValueStore
        self.appConfigurable = appConfigurable
        self.authProvider = authProvider
        if let customProvider = customProvider {
            self.provider = customProvider
        }
        self.firebaseAuth = firebaseAuth
        self.isTest = isTest
    }

    // refresh token이 만료된 경우, error를 발생시킬 때 retryWhen으로 반복 수행 (index값으로 횟수 파악가능)
    public func request<D: BaseResponsable>(_ target: Target, response: D.Type, allowAccessTokenRefreshing: Bool = true) -> Single<D> {
        return provider.rx.request(target, response: response)
            .retryWhen({ (error: Observable<Error>) in
                error.enumerated().flatMap { [weak self] (index, error) -> Single<RefreshTokenResponse> in
                    guard let self = self else {
                        return Single.error(error)
                    }
                    // accessToken 만료 시 자동으로 갱신하는지 여부
                    guard allowAccessTokenRefreshing == true else {
                        return Single.error(error)
                    }

                    if index >= self.maxAttempts {
                        return Single.error(error)
                    }
                    if case BaseServiceError.tokenExpired = error {
                        // refreshToken을 사용하여 accessToken을 갱신하기 위한 요청
                        let request = RefreshTokenRequest(refreshToken: self.keyValueStore.userRefreshToken())
                        return self.authProvider.rx.request(.refreshToken(request), response: RefreshTokenResponse.self)
                            .catchError { (error) in
                                // refreshToken api가 notValidToken 응답을 받은 경우 refreshToken이 만료된것으로 간주하고 로그아웃
                                if case let .invalidResponse(responseCode, _) = error as? BaseServiceError {
                                    if responseCode == ResponseCodeType.notValidToken.rawValue {
                                        return Single.error(BaseServiceError.refreshTokenExpired)
                                    }
                                }
                                return Single.error(error)
                            }
                            .flatMap { (response: RefreshTokenResponse) -> Single<RefreshTokenResponse> in
                                if !self.isTest {
                                    return self.updateAuthInfo(with: response)
                                } else {
                                    return Single.just(response)
                                }
                            }
                    } else {
                        return Single.error(error)
                    }
                }
            })
    }

    private func updateAuthInfo(with response: RefreshTokenResponse) -> Single<RefreshTokenResponse> {
        return Single.create { single in
            Log.debug(#function, response.result.firebaseAuthToken)
            self.firebaseSignin(with: response.result.firebaseAuthToken) { result in
                switch result {
                case .success:
                    self.updateUserInfo(result: response.result)
                    single(.success(response))
                case .failure(let error):
                    Log.debug(#function, error)
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    private func firebaseSignin(with authToken: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        firebaseAuth.signIn(withCustomToken: authToken) { (user, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }

    private func updateUserInfo(result: RefreshTokenResult) {
        Log.debug(#function, result)
        keyValueStore.saveMemberID(result.memberID)
        keyValueStore.saveAccessToken(result.accessToken)
        keyValueStore.saveRefreshToken(result.refreshToken)
        appConfigurable.setToken(result.accessToken)
    }
}
