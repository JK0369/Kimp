//
//  Sub2VM.swift
//  BaseProject
//
//  Created by 김종권 on 2021/02/03.
//

import Foundation
import CommonExtension
import Domain
import RxSwift
import RxCocoa
import XCoordinator

class Sub2VM: ErrorHandleable {

    struct Dependencies {
        let router: UnownedRouter<SubRoute>
        let postTaskManager: PostTaskManager
        let commonHandling: CommonHandling
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Output

    var showError = PublishRelay<CommonErrorType>()

    // MARK: - Properties

    let dependencies: Dependencies
    let bag = DisposeBag()

    // MARK: - Handling View Input

    func viewWillAppear() {

    }

}

extension Sub2VM: CommonHandlingDelegate {
    func didUpdateCount(info: String) {
        Log.debug(info)
    }
}
