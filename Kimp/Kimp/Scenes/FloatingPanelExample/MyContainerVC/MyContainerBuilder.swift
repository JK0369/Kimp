//
//  ContainerBuilder.swift
//  BaseProject
//
//  Created by 김종권 on 2021/02/02.
//

import Foundation
import Domain
import XCoordinator

class MyContainerBuilder {
    static func build(router: UnownedRouter<MyContainerRoute>, postTaskManager: PostTaskManager) -> MyContainerVC {
        let dependencies = MyContainerVM.Dependencies(
            router: router,
            postTaskManager: postTaskManager
        )
        let vm = MyContainerVM(dependencies: dependencies)
        return MyContainerVC.instantiate(viewModel: vm)
    }
}
