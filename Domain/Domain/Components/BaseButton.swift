//
//  BaseButton.swift
//  Domain
//
//  Created by 김종권 on 2021/01/04.
//

import Foundation
//import CommonExtension
//import MaterialComponents.MaterialActivityIndicator
//
//class TapBaseButton: UIButton {
//    var activityIndicator: MDCActivityIndicator?
//    var originalText: String?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupView()
//    }
//
//    func setupView() {
//        self |> cornerRadiusStyle(4)
//        createActivityIndicator()
//    }
//
//    override var intrinsicContentSize: CGSize {
//        var size = super.intrinsicContentSize
//        if DeviceType.iPhone5orSE {
//            if let fontDescriptor = titleLabel?.font.fontDescriptor {
//                titleLabel?.font = UIFont(descriptor: fontDescriptor, size: 15.0)
//            } else {
//                titleLabel?.font = Font.regular(size: 15.0)
//            }
//
//            size.height = 48
//        } else {
//            size.height = 56
//        }
//        return size
//    }
//
//    private func createActivityIndicator() {
//        activityIndicator = MDCActivityIndicator()
//        activityIndicator?.sizeToFit()
//        activityIndicator?.strokeWidth = 4
//        activityIndicator?.cycleColors = [.blue_c42_blue_tint20]
//
//        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
//        guard let activityIndicator = activityIndicator else {
//            return
//        }
//        addSubview(activityIndicator)
//
//        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
//        addConstraint(xCenterConstraint)
//
//        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
//        addConstraint(yCenterConstraint)
//    }
//
//    func showLoading() {
//        if activityIndicator == nil {
//            createActivityIndicator()
//        }
//
//        originalText = titleLabel?.text
//        setTitle("", for: .normal)
//        activityIndicator?.startAnimating()
//        isUserInteractionEnabled = false
//    }
//
//    func hideLoading() {
//        if activityIndicator == nil {
//            createActivityIndicator()
//        }
//
//        setTitle(originalText, for: .normal)
//        activityIndicator?.stopAnimating()
//        isUserInteractionEnabled = true
//    }
//}
