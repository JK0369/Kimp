//
//  MyContainerVM.swift
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

protocol CommonHandling {
    func updateCount()
}

protocol CommonHandlingDelegate: class {
    func didUpdateCount(info: String)
}

class MyContainerVM: ErrorHandleable {

    struct Dependencies {
        let router: UnownedRouter<MyContainerRoute>
        let postTaskManager: PostTaskManager
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Output

    var showError = PublishRelay<CommonErrorType>()

    // MARK: - Properties

    let dependencies: Dependencies
    let bag = DisposeBag()
    var myContainerDelegate: CommonHandlingDelegate?

    // MARK: - Handling View Input

    func viewWillAppear() {
        DispatchQueue.main.async {
            self.dependencies.router.trigger(.sub1)
        }

        // main에서 필수로 체크해야하는 로직 구현
        // NotificationCenter
        // postTaskManager
        // permission 체크 등등
    }
}

extension MyContainerVM: CommonHandling {
    func updateCount() {
        myContainerDelegate?.didUpdateCount(info: "업데이트 완료")
    }
}
