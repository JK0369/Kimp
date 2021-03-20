//
//  MyContainerCoordinator.swift
//  BaseProject
//
//  Created by 김종권 on 2021/02/02.
//

import Foundation
import Domain
import CommonExtension
import XCoordinator

indirect enum MyContainerRoute: Route {
    case myContainer
    case popAndPush(MyContainerRoute)
    case sub1
    case sub2
}

class MyContainerCoordinator: BaseNavigationCoordinator<MyContainerRoute> {
    let postTaskManager: PostTaskManager
    var myContainerVC: MyContainerVC!

    init(rootViewController: RootViewController, postTaskManager: PostTaskManager, initialRoute: MyContainerRoute) {
        self.postTaskManager = postTaskManager
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(initialRoute)
    }

    override func prepareTransition(for route: MyContainerRoute) -> NavigationTransition {
        rootViewController.setNavigationBarHidden(true, animated: false)

        switch route {
        case .myContainer:
            let vc = MyContainerBuilder.build(router: unownedRouter, postTaskManager: postTaskManager)
            myContainerVC = vc
            return .set([vc])

        case .sub1: // container와 child관계를 유지하기 위해서는, myContainerVC.add(vc) 후 따로 Coordinator를 addChild 해야함
            if let currentControlVC = myContainerVC.children.first {
                if currentControlVC is Sub1VC {
                    return .none()
                }
                currentControlVC.remove()
            }
            let sub1Coordinator = SubCoordinator(
                rootViewController: rootViewController,
                postTaskManager: postTaskManager,
                initialRoute: nil,
                myContainerVC: myContainerVC
            )
            let vc = Sub1Builder.build(
                router: sub1Coordinator.unownedRouter,
                containerRouter: unownedRouter,
                postTaskManager: postTaskManager,
                commonHandling: myContainerVC.viewModel
            )
            myContainerVC.add(vc)
            myContainerVC.viewModel.myContainerDelegate = vc.viewModel
            return addChildAndRemovePrevious(presentable: sub1Coordinator)

        case .sub2:
            if let currentControlVC = myContainerVC.children.first {
                if currentControlVC is Sub2VC {
                    return .none()
                }
                currentControlVC.remove()
            }
            let sub1Coordinator = SubCoordinator(
                rootViewController: rootViewController,
                postTaskManager: postTaskManager,
                initialRoute: nil,
                myContainerVC: myContainerVC
            )
            let vc = Sub2Builder.build(
                router: sub1Coordinator.unownedRouter,
                postTaskManager: postTaskManager,
                commonHandling: myContainerVC.viewModel
            )
            myContainerVC.add(vc)
            myContainerVC.viewModel.myContainerDelegate = vc.viewModel
            return addChildAndRemovePrevious(presentable: sub1Coordinator)

        case .popAndPush(let route): // VM에서 호출
            return popAndPush(route: route)
        }
    }

}
