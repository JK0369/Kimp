//
//  BaseViewController.swift
//  BaseProject
//
//  Created by 김종권 on 2020/12/19.
//

import Foundation
import UIKit
import Toast_Swift
import JGProgressHUD
import RxSwift
import RxCocoa
import Reachability
import RxReachability
import CommonExtension

public enum NetworkListener: Int {
    case off = 0
    case on = 1
}

open class BaseViewController: UIViewController {

    public let bag = DisposeBag()
    public lazy var hud: JGProgressHUD = {
        let loader = JGProgressHUD(style: .dark)
        return loader
    }()
    let toastViewHeight: CGFloat = 40
    var toastMessageView: ToastMessageView?

    // network
    public var reachability: Reachability? // 이 변수를 바인딩 하여 네트워크 상태 점검
    public let isConnected: PublishSubject<Bool> = .init() // 사용하는 입장에서 network 상태를 보고 사용할 용도의 변수
    public var networkListener: NetworkListener = .off { // 네트워크 체크가 필요할 시 VC에서 netwrokListener = .on으로 설정
        didSet {
            if networkListener  == .on {
                setupReachabilityBindings()
            }
        }
    }

    // init
    open override func viewDidLoad() {
        super.viewDidLoad()
        reachability = try? Reachability()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? reachability?.startNotifier()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability?.stopNotifier()
    }

    // toast
    func showToastView(message: String, above anchorView: UIView, offset: CGFloat) {
        let centerX: CGFloat = view.bounds.width / 2
        let centerY: CGFloat = anchorView.frame.origin.y - (toastViewHeight / 2) - offset
        let point = CGPoint(x: centerX, y: centerY)
        self.showToastView(message: message, point: point)
    }

    func showToastView(message: String, point: CGPoint? = nil) {
        let toastViewWidth = widthSizeToastViewByComparing(string: message)
        let messageView = ToastMessageView(frame: CGRect(x: 0, y: 0, width: toastViewWidth, height: toastViewHeight))

        messageView |> roundedStyle()
        messageView.lblToastMessage.text = message
        if let point = point {
            view.showToast(messageView, point: point)
        } else {
            view.showToast(messageView)
        }
        toastMessageView?.hideView()
        toastMessageView = messageView
    }

    private func widthSizeToastViewByComparing(string: String) -> CGFloat {
        let temporaryLabel = UILabel()
        temporaryLabel.font = UIFont.italicSystemFont(ofSize: 12)
        temporaryLabel.text = string
        return temporaryLabel.intrinsicContentSize.width + 48.5
    }

    // Loading

    public func showLoading() {
        DispatchQueue.main.async {
            self.hud.show(in: self.view, animated: true)
        }
    }
    public func hideLoading() {
        DispatchQueue.main.async {
            self.hud.dismiss(animated: true)
        }
    }

    // Alert and open setting
    public func showAlertAndSetting(alertTitle: String, actionTitle: String) {
        if presentedViewController != nil { // 본 VC에서 modal로 부른 VC객체 지칭
            dismiss(animated: true) { [weak self] in
                self?.showAlert(title: alertTitle, message: nil, actionTitle: actionTitle) { [weak self] in
                    self?.openSettingsInApp()
                }
            }
        } else {
            showAlert(title: alertTitle, message: nil, actionTitle: actionTitle) { [weak self] in
                self?.openSettingsInApp()
            }
        }
    }
    private func openSettingsInApp() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, completionHandler: nil)
            }
        }
    }

    // Network
    private func setupReachabilityBindings() {
        reachability?.rx.reachabilityChanged
            .subscribe(onNext: { reachability in
                Log.debug("reachability: changed => \(reachability.connection)")
            })
            .disposed(by: bag)

        reachability?.rx.isReachable
            .filter { !$0 }
            .map { _ in "server Error" }
            .asDriver(onErrorRecover: { _ in .never()})
            .drive(onNext: { [weak self] in
                self?.showNotConnectedToInternet()
            }).disposed(by: bag)

        reachability?.rx.isConnected
            .map { _ in true }
            .bind(to: isConnected)
            .disposed(by: bag)

        reachability?.rx.isDisconnected
            .map { _ in false }
            .bind(to: isConnected)
            .disposed(by: bag)
    }

    public func showDeletePhoto(completion: @escaping () -> Void) {
        let dialogVC = DialogBuilder.showDeletePhoto()
        dialogVC.onAccept
            .bind(onNext: completion)
            .disposed(by: bag)
    }

    // Interaction

    func raiseKeyboardWithButton(keyboardChangedHeight: CGFloat, constraintBetweenBtnAndKeyboard: NSLayoutConstraint) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.23, animations: {
                var safeAreaBottomLength = self.view.safeAreaInsets.bottom

                if keyboardChangedHeight == 0 { // 버튼이 가라앉는 버그 대응
                    safeAreaBottomLength = 0
                }

                constraintBetweenBtnAndKeyboard.constant = keyboardChangedHeight - safeAreaBottomLength + Constants.ComponentStyle.intervalSizeBetweenButtonAndKeyboard
                self.view.layoutIfNeeded()
            })
        }
    }

    // Common Error

    func showNotConnectedToInternet() {
        let dialogVC = DialogBuilder.serverErrorDialog()
        present(dialogVC, animated: true)
    }

    func showErrorMessageDialog(error: ErrorData) {
        let dialogVC = DialogBuilder.showErrorMessageDialog(error)
        present(dialogVC, animated: true)
    }

    public func handleTokenExpired() {
        let data = ErrorData(message: "Strings.errorTokenExpired()")
        let dialogVC = DialogBuilder.showErrorMessageDialog(data)
        dialogVC.onAccept
            .bind(onNext: { _ in
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.routeToSplash(tokenExpired: true)
                }
            })
            .disposed(by: dialogVC.bag)
        present(dialogVC, animated: true)
    }

    // MARK: - Appstore

    func openAppStore(urlStr: String) -> Result<Void, AppstoreOpenError> {

        guard let url = URL(string: urlStr) else {
            Log.debug("invalid app store url")
            return .failure(.invalidAppStoreURL)
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return .success(())
        } else {
            Log.debug("can't open app store url")
            return .failure(.cantOpenAppStoreURL)
        }
    }

}

public extension Reactive where Base: BaseViewController {

    var loading: Binder<Bool> {
        return Binder(self.base) { vc, show in
            show ? vc.showLoading() : vc.hideLoading()
        }
    }

    var showLoading: Binder<Void> {
        return Binder(self.base) { (vc, show) in
            vc.showLoading()
        }
    }
    var hideLoading: Binder<Void> {
        return Binder(self.base) { (vc, show) in
            vc.hideLoading()
        }
    }

    var backPressed: Binder<Void> {
        return Binder(base) { vc, _ in
            vc.view.endEditing(true)
            if vc.navigationController != nil {
                vc.navigationController?.popViewController(animated: true)
            } else {
                vc.dismiss(animated: true)
            }
        }
    }
}

// Ads
//extension BaseViewController: GADBannerViewDelegate {
//    func setupBannerViewToBottom(height: CGFloat = 50) {
//        let adSize = GADAdSizeFromCGSize(CGSize(width: view.frame.width, height: height))
//        bannerView = GADBannerView(adSize: adSize)
//
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        NSLayoutConstraint.activate([
//            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            bannerView.heightAnchor.constraint(equalToConstant: height)
//        ])
//
//        bannerView.adUnitID = Constants.GoogleAds.realAdKey
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//        bannerView.delegate = self
//    }
//
//    // MARK: - Delegate
//
//    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        bannerView.alpha = 0
//        UIView.animate(withDuration: 1) {
//            bannerView.alpha = 1
//        }
//    }
//
//    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//    }
//
//    public func adViewWillPresentScreen(_ bannerView: GADBannerView) {
//    }
//
//    public func adViewWillDismissScreen(_ bannerView: GADBannerView) {
//    }
//
//    public func adViewDidDismissScreen(_ bannerView: GADBannerView) {
//    }
//
//    public func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
//    }
//}
