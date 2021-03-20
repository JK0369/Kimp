//
//  SubCoordinator.swift
//  BaseProject
//
//  Created by 김종권 on 2021/02/03.
//

import Foundation
import Domain
import CommonExtension
import XCoordinator

indirect enum SubRoute: Route {
    case someRoute
}

class SubCoordinator: BaseNavigationCoordinator<SubRoute> {
    let postTaskManager: PostTaskManager
    var myContainerVC: MyContainerVC!

    init(rootViewController: RootViewController, postTaskManager: PostTaskManager, initialRoute: SubRoute?, myContainerVC: MyContainerVC) {
        self.postTaskManager = postTaskManager
        super.init(rootViewController: rootViewController, initialRoute: nil)
        if let initialRoute = initialRoute {
            trigger(initialRoute)
        }
    }

    override func prepareTransition(for route: SubRoute) -> NavigationTransition {
        rootViewController.setNavigationBarHidden(true, animated: false)

        switch route {
        case .someRoute:
            return .none()
        }
    }

}
