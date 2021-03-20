//
//  BaseWebViewController.swift
//  BaseProject
//
//  Created by 김종권 on 2021/01/14.
//

import Foundation
import WebKit
import RxCocoa
import RxSwift
import Domain

class BaseWebViewController: BaseViewController {

    var webURL: URL?
    var webView: WKWebView!
    let uuidCookieName = "APP_DEVICE_UUID"
    let authTokenCookieName = "CID_AUT"
    var statusBarStyle: UIStatusBarStyle = .default

    let btnBack: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage(named: "gnb_24_close_bk"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()

    lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnBack)
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            btnBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            btnBack.widthAnchor.constraint(equalToConstant: 24),
            btnBack.heightAnchor.constraint(equalToConstant: 24),
            btnBack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return view
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        prepareWebConfiguration { [weak self] in
            if let config = $0 {
                self?.setupWebView(with: config)
            }
        }
        setupInputBinding()
    }

    func prepareWebConfiguration(completion: @escaping (WKWebViewConfiguration?) -> Void) {

        guard let authCookie = HTTPCookie(properties: [
            .domain: ServiceConfiguration.webBaseDomain,
            .path: "/",
            .name: authTokenCookieName,
            .value: KeychainService.shared.userAccessToken(),
            .secure: "TRUE",
        ]) else {
            return
        }

        guard let uuidCookie = HTTPCookie(properties: [
            .domain: ServiceConfiguration.webBaseDomain,
            .path: "/",
            .name: uuidCookieName,
            .value: KeychainService.shared.uuid(),
            .secure: "TRUE",
        ]) else {
            return
        }

        WKWebViewConfiguration.includeCookie(cookies: [authCookie, uuidCookie]) {
            completion($0)
        }
    }

    func setupView() {
        view.backgroundColor = .white
        topView.backgroundColor = .white
        view.addSubview(topView)

        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 44),
        ])

        if self.title == nil {
            topView.isHidden = true
        }
    }

    func setupWebView(with config: WKWebViewConfiguration) {
        let contentController = WKUserContentController()
        config.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsLinkPreview = false

        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        if self.title == nil {
            NSLayoutConstraint.activate([
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 1),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }

        if let url = webURL {
            webView.load(URLRequest(url: url))
        }
    }

    func setupInputBinding() {

    }
}

// java script 액션
//extension BaseWebViewController: WKScriptMessageHandler {
//
//    enum WebAction: String {
//        case changeStatusBarColor
//        case goBack
//    }
//
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        Log.debug(#function, message.name, message.body)
//        let messageHandlerName = "TapJavascriptInterfaces" // java script에서 주는 헨들러 이름
//
//        if message.name == messageHandlerName {
//            if let dics: [String: Any] = message.body as? Dictionary, let action = dics["action"] as? String {
//
//                let webAction = WebAction(rawValue: action)
//                switch webAction {
//                case .changeStatusBarColor:
//                    if let color = dics["bgColor"] as? String, let isDarkIcon = dics["isDarkIcon"] as? Bool {
//                        self.statusBarView?.backgroundColor = UIColor(hexString: color)
//                        if isDarkIcon == true {
//                            statusBarStyle = .default
//                        } else {
//                            statusBarStyle = .lightContent
//                        }
//                        setNeedsStatusBarAppearanceUpdate()
//                    }
//                case .goBack:
//                    self.popVC()
//                default:
//                    Log.debug("Undefined action: \(String(describing: webAction))")
//                }
//            }
//        }
//    }
//}

extension BaseWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}

extension BaseWebViewController: WKUIDelegate {

}

extension WKWebViewConfiguration {
    static func includeCookie(cookies: [HTTPCookie], completion: @escaping (WKWebViewConfiguration?) -> Void) {
        let config = WKWebViewConfiguration()
        let dataStore = WKWebsiteDataStore.nonPersistent()

        DispatchQueue.main.async {
            let waitGroup = DispatchGroup()

            for cookie in cookies {
                waitGroup.enter()
                dataStore.httpCookieStore.setCookie(cookie) {
                    waitGroup.leave()
                }
            }

            waitGroup.notify(queue: DispatchQueue.main) {
                config.websiteDataStore = dataStore
                completion(config)
            }
        }
    }
}


/* 사용하는 쪽
let vc = BaseWebViewController()
vc.webURL = url
vc.title = "웹 뷰 타이틀"
push(vc)
 */
