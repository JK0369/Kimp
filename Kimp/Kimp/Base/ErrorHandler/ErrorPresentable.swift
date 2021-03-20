//
//  ErrorPresentable.swift
//  BaseProject
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation
import CommonExtension
import RxSwift
import RxCocoa

protocol ErrorPresentable: BaseViewController {
    associatedtype ViewModel: ErrorHandleable
    var viewModel: ViewModel! { get }

    func setupErrorHandlerBinding()
}

extension ErrorPresentable {
    func setupErrorHandlerBinding() {
        viewModel.showError.asDriverOnErrorNever()
            .drive(onNext: { [weak self] commonErrorType in
                switch commonErrorType {
                case .notConnectedToInternet:
                    self?.showNotConnectedToInternet()
                case .tokenExpired:
                    self?.handleTokenExpired()
                case .defaultUnknown(let errorData),
                     .unknown(let errorData):
                    self?.showErrorMessageDialog(error: errorData)
                }
            }).disposed(by: bag)
    }
}
