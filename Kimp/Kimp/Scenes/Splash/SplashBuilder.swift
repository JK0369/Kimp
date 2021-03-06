//
//  SplashBuilder.swift
//  BaseProject
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation
import Domain
import XCoordinator

class SplashBuilder {
    static func build(router: UnownedRouter<SplashRoute>, postTaskManager: PostTaskManager) -> SplashVC {
        let dependencies = SplashVM.Dependencies(
            router: router,
            postTaskManager: postTaskManager
//            keychain: KeychainService.shared,
//            appStatusUseCase: BaseService<AppConfigTarget>.makeProvider(),
//            mapStyleUseCase: BaseService<MapStyleTarget>.makeProvider(),
//            accountUseCase: BaseService<AccountTarget>.makeProvider(),
//            tapSetting: TapServiceSetting.shared
        )
        let vm = SplashVM(dependencies: dependencies)
        return SplashVC.instantiate(viewModel: vm)
    }
}
