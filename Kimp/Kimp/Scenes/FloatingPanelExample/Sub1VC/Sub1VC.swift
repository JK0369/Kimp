//
//  Sub1VC.swift
//  BaseProject
//
//  Created by 김종권 on 2021/02/02.
//

import Foundation
import CommonExtension
import Domain
import RxSwift
import RxCocoa

final class Sub1VC: BaseViewController, StoryboardInitializable, ErrorPresentable {
    static var storyboardName: String = Constants.Storyboard.floatingPanelExample
    static var storyboardID: String = Sub1VC.className

    // MARK: - Property

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btnRequestToContainer: UIButton!
    @IBOutlet weak var btnRouteToSub2: UIButton!
    var viewModel: Sub1VM!

    required init?(coder: NSCoder, viewModel: Sub1VM) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - View Life Cycle

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

        btnRequestToContainerTapEvent()

        btnRouteToSub2TapEvent()
    }

    private func viewWillAppearEvent() {
        rx.viewWillAppear.asDriverOnErrorNever()
            .mapToVoid()
            .drive(onNext: { [weak self] in
                self?.viewModel.viewWillAppear()
            }).disposed(by: bag)
    }

    private func btnRequestToContainerTapEvent() {
        btnRequestToContainer.rx.throttleTap.asDriverOnErrorNever()
            .drive(onNext: { [weak self] in
                self?.viewModel.didTapBtnRequestToContainer()
            }).disposed(by: bag)
    }

    private func btnRouteToSub2TapEvent() {
        btnRouteToSub2.rx.throttleTap.asDriverOnErrorNever()
            .drive(onNext: { [weak self] in
                self?.viewModel.routeToSub2()
            }).disposed(by: bag)
    }

    // MARK: - OutputBinding

    private func setupOutputBinding() {
        viewModel.updateLabel.asDriverOnErrorNever()
            .drive(lbl.rx.text)
            .disposed(by: bag)
    }
}
