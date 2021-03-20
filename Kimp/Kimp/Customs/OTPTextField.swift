//
//  OTPTextField.swift
//  OTPFieldView
//
//  Created by Vaibhav Bhasin on 10/09/19.
//  Copyright © 2019 Vaibhav Bhasin. All rights reserved.
//

//    MIT License
//
//    Copyright (c) 2019 Vaibhav Bhasin
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import UIKit
@objc class OTPTextField: UITextField {
    /// Border color info for field
    public var otpBorderColor: UIColor = UIColor.black
    /// Border width info for field
    public var otpBorderWidth: CGFloat = 2
    public var shapeLayer: CAShapeLayer!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public func initalizeUI(forFieldType type: DisplayType) {
        switch type {
        case .circular:
            layer.cornerRadius = bounds.size.width / 2
        case .roundedCorner:
            layer.cornerRadius = 4
        case .square:
            layer.cornerRadius = 0
        case .diamond:
            addDiamondMask()
        case .underlinedBottom:
            addBottomView()
        }
        // Basic UI setup
        if type != .diamond && type != .underlinedBottom {
            layer.borderColor = otpBorderColor.cgColor
            layer.borderWidth = otpBorderWidth
        }
        autocorrectionType = .no
        textAlignment = .center
        text = ""
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }
    }
    override func deleteBackward() {
        super.deleteBackward()
        _ = delegate?.textField?(self, shouldChangeCharactersIn: NSRange(location: 0, length: 0),
                                 replacementString: "")
    }
    // Helper function to create diamond view
    fileprivate func addDiamondMask() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.size.width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height / 2.0))
        path.addLine(to: CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.size.height / 2.0))
        path.close()
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = otpBorderWidth
        shapeLayer.fillColor = backgroundColor?.cgColor
        shapeLayer.strokeColor = otpBorderColor.cgColor
        layer.addSublayer(shapeLayer)
    }
    // Helper function to create a underlined bottom view
    fileprivate func addBottomView() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.size.height + 3))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height + 3))
        path.close()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = otpBorderWidth
        shapeLayer.fillColor = backgroundColor?.cgColor
        shapeLayer.strokeColor = otpBorderColor.cgColor
        layer.addSublayer(shapeLayer)
    }
}

extension OTPTextField {
    public override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) {
            gestureRecognizer.isEnabled = false
        }

        return super.addGestureRecognizer(gestureRecognizer)
    }

    public override func becomeFirstResponder() -> Bool {
        for recognizer in self.gestureRecognizers ?? [] where recognizer is UILongPressGestureRecognizer {
            recognizer.isEnabled = false
        }

        return super.becomeFirstResponder()
    }
}