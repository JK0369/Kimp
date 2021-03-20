//
//  Sub1VM.swift
//  BaseProject
//
//  Created by 김종권 on 2021/02/02.
//

import Foundation
import CommonExtension
import Domain
import RxSwift
import RxCocoa
import XCoordinator

class Sub1VM: ErrorHandleable {

    struct Dependencies {
        let router: UnownedRouter<SubRoute>
        let containerRouter: UnownedRouter<MyContainerRoute>
        let postTaskManager: PostTaskManager
        let commonHandling: CommonHandling
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Output

    var showError = PublishRelay<CommonErrorType>()
    let updateLabel = PublishRelay<String>()

    // MARK: - Properties

    let dependencies: Dependencies
    let bag = DisposeBag()

    // MARK: - Handling View Input

    func viewWillAppear() {

    }

    func didTapBtnRequestToContainer() {
        dependencies.commonHandling.updateCount()
    }

    func routeToSub2() {
        dependencies.containerRouter.trigger(.sub2)
    }

}

extension Sub1VM: CommonHandlingDelegate {
    func didUpdateCount(info: String) {
        updateLabel.accept(info)
    }
}
