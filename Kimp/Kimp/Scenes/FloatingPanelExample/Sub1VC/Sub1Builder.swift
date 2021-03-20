//
//  Sub1Builder.swift
//  BaseProject
//
//  Created by 김종권 on 2021/02/02.
//

import Foundation
import Domain
import XCoordinator

class Sub1Builder {
    static func build(router: UnownedRouter<SubRoute>, containerRouter: UnownedRouter<MyContainerRoute>, postTaskManager: PostTaskManager, commonHandling: CommonHandling) -> Sub1VC {
        let dependencies = Sub1VM.Dependencies(
            router: router,
            containerRouter: containerRouter,
            postTaskManager: postTaskManager,
            commonHandling: commonHandling
        )
        let vm = Sub1VM(dependencies: dependencies)
        return Sub1VC.instantiate(viewModel: vm)
    }
}
