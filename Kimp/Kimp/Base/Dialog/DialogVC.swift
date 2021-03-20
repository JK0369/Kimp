//
//  DialogVC.swift
//  AlertExample
//
//  Created by 김종권 on 2020/11/29.
//

import Foundation
import CommonExtension
import UIKit
import RxSwift
import RxCocoa

enum DialogType {
    case smallTitle
    case bigTitle
}

class DialogVC: UIViewController, Storyboarded {
    static var storyboardName: String = Constants.Storyboard.dialog
    static var storyboardID: String = DialogVC.className

    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var constraintViewTopAndStackViewTop: NSLayoutConstraint!

    let onAccept: PublishRelay<Void> = .init()
    let bag = DisposeBag()
    var dataTitleAndDescription: (title: String?, description: String?)?
    var dataBtnCancelAndConfirm: (titleBtnCancel: String?, titleBtnConfirm: String?)?
    var dialogType: DialogType = .smallTitle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBinding()
        setupView()
    }

    private func setupBinding() {
        btnCancel.rx.tap.asDriver(onErrorRecover: { _ in .never() })
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: bag)

        btnConfirm.rx.tap.asDriver(onErrorRecover: { _ in .never() })
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true) {
                    self?.onAccept.accept(())
                }
            }).disposed(by: bag)
    }

    func setupView() {

        switch dialogType {
        case .smallTitle:
            break
        case .bigTitle:
            labelStackView.spacing = 8
            lblTitle.font = UIFont.init(name: "System", size: 22)
            lblDescription.textColor = .systemBlue
            constraintViewTopAndStackViewTop.constant = 32
        }

        if let titleDescription = dataTitleAndDescription {
            setTextDescription(titleDescription.title, titleDescription.description)
        }

        if let btnCancelConfirm = dataBtnCancelAndConfirm {
            setBtnCancelConfirm(btnCancelConfirm.titleBtnCancel, btnCancelConfirm.titleBtnConfirm)
        }
    }

    private func setTextDescription(_ title: String?, _ description: String?) {
        lblTitle.text = title
        
        if let description = description {
            lblDescription.text = description
        } else {
            lblDescription.isHidden = true
        }
    }

    private func setBtnCancelConfirm(_ btnCancelTitle: String?, _ btnConfirmTitle: String?) {

        if let titleBtnCancel = btnCancelTitle {
            btnCancel.setTitle(titleBtnCancel, for: .normal)
        } else {
            btnCancel.isHidden = true
        }

        if let titleBtnConfirm = btnConfirmTitle {
            btnConfirm.setTitle(titleBtnConfirm, for: .normal)
        } else {
            btnConfirm.isHidden = true
        }
    }
}

