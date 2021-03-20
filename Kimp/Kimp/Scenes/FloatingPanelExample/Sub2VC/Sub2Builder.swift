//
//  Sub2Builder.swift
//  BaseProject
//
//  Created by 김종권 on 2021/02/03.
//

import Foundation
import Domain
import XCoordinator

class Sub2Builder {
    static func build(router: UnownedRouter<SubRoute>, postTaskManager: PostTaskManager, commonHandling: CommonHandling) -> Sub2VC {
        let dependencies = Sub2VM.Dependencies(
            router: router,
            postTaskManager: postTaskManager,
            commonHandling: commonHandling
        )
        let vm = Sub2VM(dependencies: dependencies)
        return Sub2VC.instantiate(viewModel: vm)
    }
}
