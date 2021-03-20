//
//  SplashVM.swift
//  BaseProject
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation
import CommonExtension
import Domain
import RxSwift
import RxCocoa
import XCoordinator

class SplashVM: ErrorHandleable {

    struct Dependencies {
        let router: UnownedRouter<SplashRoute>
        let postTaskManager: PostTaskManager
//        let keychain: KeyValueStore
//        let appStatusUseCase: BaseService<AppConfigTarget>
//        let mapStyleUseCase: BaseService<MapStyleTarget>
//        let accountUseCase: BaseService<AccountTarget>
//        let tapSetting: TapServiceConfigurable
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        registerNotification()
    }

    // MARK: - Output

    var showError = PublishRelay<CommonErrorType>()

    // MARK: - Properties

    let dependencies: Dependencies
    let bag = DisposeBag()
    let openAppStore = PublishRelay<String>()

    // MARK: - Handling View Input

    func viewWillAppear() {
        checkVersion()
    }

    private func checkVersion() {

        guard let currentVersion = Constants.System.appVersion,
              let latestVersion = Constants.System.latestVersion() else {
            return
        }

         let compareResult = currentVersion.compare(latestVersion, options: .numeric)
         switch compareResult {
         case .orderedAscending:
             updateVersion()
         case .orderedDescending:
             break
         case .orderedSame:
             break
         }
    }

    func didTapBtnRoute() {
        dependencies.router.trigger(.myContainer)
    }

    func processAppstoreOpen(result: Result<Void, AppstoreOpenError>?) {
        guard let result = result else {
            return
        }
        switch result {
        case .success:
            dependencies.postTaskManager.register(
                postTask: .init(
                    target: .splash,
                    task: .checkVersion
                )
            )
        case .failure(let error):
            Log.error(error.errorString)
            // 일시적인 오류
        }
    }

    // MARK: - private

    private func registerNotification() {
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .asDriverOnErrorNever()
            .drive(onNext: { [weak self] _ in
                self?.processPostTask()
            }).disposed(by: bag)
    }

    private func processPostTask() {
        guard let tasks = dependencies.postTaskManager.postTasks(postTastTarget: .splash) else {
            return
        }
        for task in tasks {
            switch task {
            case .checkVersion:
                checkVersion()
            default:
                break
            }
        }
        dependencies.postTaskManager.remove(for: .splash)
    }

    private func updateVersion() {
        openAppStore.accept(Constants.appStoreOpenUrlString)
    }
}
