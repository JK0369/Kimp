//
//  MoyaProviderExtension.swift
//  BaseProject
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation
import Moya
import RxSwift
import Domain

// Plugin 설정에 사용되는 extension
public extension MoyaProvider {

    static func makeProvider() -> MoyaProvider<Target> {
        if AppServiceSetting.shared.configurations.useStub { // mock
            return MoyaProvider<Target>.init(stubClosure: MoyaProvider<Target>.delayedStub(0.5), plugins: [RequestLoggingPlugin()])
        } else { // real
            let authPlugin = AccessTokenPlugin { _ in
                return AppServiceSetting.shared.configurations.bearerToken ?? ""
            }
            return .init(plugins: [RequestLoggingPlugin(), authPlugin] )
        }
    }

    // mock
    static func makeStubProvider() -> MoyaProvider<Target> {
        return MoyaProvider<Target>.init(stubClosure: MoyaProvider<Target>.delayedStub(0.5), plugins: [RequestLoggingPlugin()])
    }
}
