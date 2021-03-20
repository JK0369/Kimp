//
//  MyContainerVC.swift
//  BaseProject
//
//  Created by 김종권 on 2021/02/02.
//

import Foundation
import CommonExtension
import Domain
import RxSwift
import RxCocoa

final class MyContainerVC: BaseViewController, StoryboardInitializable, ErrorPresentable {
    static var storyboardName: String = Constants.Storyboard.floatingPanelExample
    static var storyboardID: String = MyContainerVC.className

    @IBOutlet weak var btnTap: UIButton!

    // MARK: - Property

    var viewModel: MyContainerVM!

    required init?(coder: NSCoder, viewModel: MyContainerVM) {
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

        didTapBtn()
    }

    private func viewWillAppearEvent() {
        rx.viewWillAppear.asDriverOnErrorNever()
            .mapToVoid()
            .drive(onNext: { [weak self] in
                self?.viewModel.viewWillAppear()
            }).disposed(by: bag)
    }

    private func didTapBtn() {
//        btnTap.rx.throttleTap.asDriverOnErrorNever()
//            .map{"탭!!"}
//            .drive(btnTap.rx.title(for: .normal))
//            .disposed(by: bag)

        btnTap.rx.throttleTap.asDriverOnErrorNever()
            .drive(onNext: { [weak self] in
                self?.btnTap.setTitle("탭!!", for: .normal)
            }).disposed(by: bag)
    }

    // MARK: - OutputBinding

    private func setupOutputBinding() {

    }
}

extension MyContainerVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll: Bool) {
         
    }

    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }

    func enteredOTP(otp: String) {
    }

    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        return true
    }

    func deletedOTP() {
    }
}
