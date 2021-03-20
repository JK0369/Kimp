//
//  Sub2VC.swift
//  BaseProject
//
//  Created by 김종권 on 2021/02/03.
//

import Foundation
import CommonExtension
import Domain
import RxSwift
import RxCocoa

final class Sub2VC: BaseViewController, StoryboardInitializable, ErrorPresentable {
    static var storyboardName: String = Constants.Storyboard.floatingPanelExample
    static var storyboardID: String = Sub2VC.className

    // MARK: - Property

    var viewModel: Sub2VM!

    required init?(coder: NSCoder, viewModel: Sub2VM) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - View Lifr Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        networkListener = .on
        setupView()
        setupInputBinding()
        setupOutputBinding()
        setupErrorHandlerBinding()
    }

    private func setupView() {
    }

    // MARK: - InputBinding

    private func setupInputBinding() {
        viewWillAppearEvent()
    }

    private func viewWillAppearEvent() {
        rx.viewWillAppear.asDriverOnErrorNever()
            .mapToVoid()
            .drive(onNext: { [weak self] in
                self?.viewModel.viewWillAppear()
            }).disposed(by: bag)
    }

    // MARK: - OutputBinding

    private func setupOutputBinding() {

    }
}
