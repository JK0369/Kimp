//
//  SplashVC.swift
//  BaseProject
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation
import CommonExtension
import Domain
import RxSwift
import RxCocoa

final class SplashVC: BaseViewController, StoryboardInitializable, ErrorPresentable {
    static var storyboardName: String = Constants.Storyboard.splash
    static var storyboardID: String = SplashVC.className

    // MARK: - Property

    @IBOutlet weak var otpView: OTPFieldView!
    @IBOutlet var btnRoute: UIButton!
    @IBOutlet weak var lblCenter: UILabel!
    var viewModel: SplashVM!

    required init?(coder: NSCoder, viewModel: SplashVM) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - View Lifr Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        networkListener = .on
        setupView()
        setupInputBinding()
        setupOutputBinding()
        setupErrorHandlerBinding()

        // 로그 예시
        Log.debug("123")
        Log.network("[Send] Splash화면에서 api 호출")
        Log.info("Splash화면에서 어떤 정보 로깅")
        Log.error("Splash화면에서 에러")
    }

    private func setupView() {
        otpView.initializeOTPFields()
        otpView.delegate = self
        lblCenter.attributedText = NSMutableAttributedString()
            .regular(string: " NSMutableAttributedString 테스트 ", fontSize: 12)
            .bold(string: "bold문자열 ", fontSize: 16)
            .orangeHighlight("오렌지 색깔 ")
    }

    // MARK: - InputBinding

    private func setupInputBinding() {
        viewWillAppearEvent()

        btnRouteFloatinPanelTapEvent()
    }

    private func viewWillAppearEvent() {
        rx.viewWillAppear.asDriverOnErrorNever()
            .mapToVoid()
            .drive(onNext: { [weak self] in
                self?.viewModel.viewWillAppear()
            }).disposed(by: bag)
    }

    private func btnRouteFloatinPanelTapEvent() {
        btnRoute.rx.throttleTap.asDriverOnErrorNever()
            .drive(onNext: { [weak self] in
                self?.viewModel.didTapBtnRoute()
            }).disposed(by: bag)
    }

    // MARK: - OutputBinding

    private func setupOutputBinding() {
        viewModel.openAppStore.asDriverOnErrorNever()
            .drive(onNext: { [weak self] in
                let result = self?.openAppStore(urlStr: $0)
                self?.viewModel.processAppstoreOpen(result: result)
            }).disposed(by: bag)
    }
}

extension SplashVC: OTPFieldViewDelegate {
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

/*

 import RxKeyboard 필요

keyboard이벤트

 func setUpOutputBinding() {
     RxKeyboard.instance.visibleHeight
         .drive(rx.keyboardHeightChanged)
     .disposed(by: disposeBag)
 }

 extension Reactive where Base: LoginVC {
     var keyboardHeightChanged: Binder<CGFloat> {
         return Binder(base) { vc, height in
             vc.raiseKeyboardWithButton(keyboardChangedHeight: height, constraintBetweenBtnAndKeyboard: vc.btnVerifyBottomConstraint)
         }
     }
 }

 */
