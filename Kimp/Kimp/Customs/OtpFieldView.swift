//
//  OTPFieldView.swift
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

@objc public protocol OTPFieldViewDelegate: class {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool
    func enteredOTP(otp: String)
    func hasEnteredAllOTP(hasEnteredAll: Bool)
    func deletedOTP()
}

@objc public enum DisplayType: Int {
    case circular
    case roundedCorner
    case square
    case diamond
    case underlinedBottom
}

@objc public enum KeyboardType: Int {
    case numeric
    case alphabet
    case alphaNumeric
}

@objc public class OTPFieldView: UIView {

    // MARK: - Properties

    public var displayType: DisplayType = .underlinedBottom
    public var fieldsCount: Int = 6
    public var otpInputType: KeyboardType = .numeric
    public var fieldFont: UIFont = UIFont.systemFont(ofSize: 26)
    public var secureEntry: Bool = false
    public var requireCursor: Bool = false
    public var cursorColor: UIColor = .blue
    public var fieldSize: CGFloat = 24
    public var separatorSpace: CGFloat = 12
    public var fieldBorderWidth: CGFloat = 2
    public var shouldAllowIntermediateEditing: Bool = false
    public var defaultBackgroundColor: UIColor = UIColor.clear
    public var filledBackgroundColor: UIColor = UIColor.clear
    public var defaultBorderColor: UIColor = .blue
    public var filledBorderColor: UIColor = .blue
    public var errorBorderColor: UIColor = UIColor.red
    public var fieldColor: UIColor = .blue
    public var isValidOtp = true
    public weak var delegate: OTPFieldViewDelegate?
    fileprivate var secureEntryData = [String]()

    // MARK: - Initialize

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    func initializeOTPFields() {
        layer.masksToBounds = true
        secureEntryData.removeAll()
        for index in stride(from: 0, to: fieldsCount, by: 1) {
            let oldOtpField = viewWithTag(index + 1) as? OTPTextField
            oldOtpField?.removeFromSuperview()
            let otpField = otpTextField(forIndex: index)
            addSubview(otpField)
            secureEntryData.append("")
        }
    }

    // MARK: - Private

    private func otpTextField(forIndex index: Int) -> OTPTextField {
        let fieldFrame = otpFieldFrame(forIndex: index)
        let otpField = OTPTextField(frame: fieldFrame)
        otpField.delegate = self
        otpField.tag = index + 1
        otpField.font = fieldFont
        otpField.textColor = isValidOtp ? fieldColor : .red

        switch otpInputType {
        case .numeric:
            otpField.keyboardType = .numberPad
        case .alphabet:
            otpField.keyboardType = .alphabet
        case .alphaNumeric:
            otpField.keyboardType = .namePhonePad
        }

        if isValidOtp {
            defaultBorderColor = .blue
        }
        otpField.otpBorderColor = defaultBorderColor
        otpField.otpBorderWidth = fieldBorderWidth
        if requireCursor {
            otpField.tintColor = cursorColor
        } else {
            otpField.tintColor = UIColor.clear
        }

        otpField.backgroundColor = defaultBackgroundColor
        otpField.initalizeUI(forFieldType: displayType)
        return otpField
    }

    private func otpFieldFrame(forIndex index: Int) -> CGRect {
        var fieldFrame = CGRect(x: 0, y: 0, width: fieldSize, height: fieldSize)
        if fieldsCount % 2 == 1 {
            fieldFrame.origin.x = bounds.size.width / 2 - (CGFloat(fieldsCount / 2 - index) *
                (fieldSize + separatorSpace) + fieldSize / 2)
        } else {
            fieldFrame.origin.x = bounds.size.width / 2 -
                (CGFloat(fieldsCount / 2 - index) * fieldSize
                    + CGFloat(fieldsCount / 2 - index - 1) * separatorSpace + separatorSpace / 2)
        }
        fieldFrame.origin.y = (bounds.size.height - fieldSize) / 2
        return fieldFrame
    }
}

// MARK: - Delegate

extension OTPFieldView: UITextFieldDelegate {

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let shouldBeginEditing = delegate?
            .shouldBecomeFirstResponderForOTP(otpTextFieldIndex: (textField.tag - 1)) ?? true
        if shouldBeginEditing {
            return isPreviousFieldsEntered(forTextField: textField)
        }
        return shouldBeginEditing
    }

    private func isPreviousFieldsEntered(forTextField textField: UITextField) -> Bool {
        var isTextfield = true
        var nextOTPField: UITextField?

        if !shouldAllowIntermediateEditing {
            for index in stride(from: 0, to: fieldsCount, by: 1) {
                let tempNextOTPField = viewWithTag(index + 1) as? UITextField
                if let tempNextOTPFieldText = tempNextOTPField?.text, tempNextOTPFieldText.isEmpty {
                    nextOTPField = tempNextOTPField
                    break
                }
            }
            if let nextOTPField = nextOTPField {
                isTextfield = (nextOTPField == textField || (textField.tag) == (nextOTPField.tag - 1))
            }
        }
        return isTextfield
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let count = textField.text?.count {
            delegate?.hasEnteredAllOTP(hasEnteredAll: count == fieldsCount)
        }
        return true
    }

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        if enteredOTP().count == fieldsCount, !string.isEmpty {
            return false
        }
        let characterSet = CharacterSet(charactersIn: string)
        if CharacterSet.decimalDigits.isSuperset(of: characterSet) == false {
            return false
        }

        if string == "" {
            delegate?.deletedOTP()
        }

        let string = string.substring(from: 0, to: 0)
        if let text = textField.text {
            delegate?.enteredOTP(otp: text + string)
        }

        let inputText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if !inputText.isEmpty {
            secureEntryData[textField.tag - 1] = string
            if secureEntry {
                textField.text = "•"
            } else {
                textField.text = string
            }
            setTextFieldShapeColor(textField: textField, isDelete: false)

            let nextOTPField = viewWithTag(textField.tag + 1)
            if let nextOTPField = nextOTPField {
                nextOTPField.becomeFirstResponder()
            }
            executeEnteredOtpDelegate(isDeleted: false)
        } else {
            let currentText = textField.text ?? ""
            if textField.tag > 1 && currentText.isEmpty {
                if let prevOTPField = viewWithTag(textField.tag - 1) as? UITextField {
                    deleteText(in: prevOTPField)
                }
            } else {
                deleteText(in: textField)
                if textField.tag > 1 {
                    if let prevOTPField = viewWithTag(textField.tag) as? UITextField {
                        prevOTPField.becomeFirstResponder()
                    }
                }
            }
        }
        return false
    }

    private func setTextFieldShapeColor(textField: UITextField, isDelete: Bool) {
        let shapeFillColor: CGColor
        let shapeStrokeColor: CGColor

        if isDelete {
            shapeFillColor = defaultBackgroundColor.cgColor
            shapeStrokeColor = defaultBorderColor.cgColor
        } else {
            shapeFillColor = UIColor.clear.cgColor
            shapeStrokeColor = UIColor.clear.cgColor
        }

        if displayType == .diamond || displayType == .underlinedBottom {
            (textField as? OTPTextField)?.shapeLayer?.fillColor = shapeFillColor
            (textField as? OTPTextField)?.shapeLayer?.strokeColor = shapeStrokeColor
        } else {
            textField.backgroundColor = filledBackgroundColor
            textField.layer.borderColor = filledBorderColor.cgColor
        }
    }

    private func enteredOTP() -> String {
        var enteredOTPString = ""
        for index in stride(from: 0, to: secureEntryData.count, by: 1) where !secureEntryData[index].isEmpty {
             enteredOTPString.append(secureEntryData[index])
        }
        return enteredOTPString
    }

    private func deleteText(in textField: UITextField) {

        guard !secureEntryData.isEmpty else { // crash 방지
            return
        }

        secureEntryData[textField.tag - 1] = ""
        textField.text = ""

        setTextFieldShapeColor(textField: textField, isDelete: true)
        executeEnteredOtpDelegate(isDeleted: true)
        textField.becomeFirstResponder()
    }

    private func executeEnteredOtpDelegate(isDeleted: Bool) {
        if isDeleted {
            delegate?.hasEnteredAllOTP(hasEnteredAll: false)
        } else {
            delegate?.enteredOTP(otp: enteredOTP())
        }
    }

}

// MARK: - Utils

public extension OTPFieldView {
    func deleteAllInput(isValidStatus: Bool) {
        secureEntryData.removeAll()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            for i in stride(from: 0, to: self.fieldsCount, by: 1) {
                (self.viewWithTag(i + 1) as? OTPTextField)?.text = ""
                self.secureEntryData.append("")
            }
            _ = (self.viewWithTag(1) as? OTPTextField)?.becomeFirstResponder()
            self.setUpTextAndShapeLayerColor(isValidStatus: isValidStatus)
        }
    }

    func setUpTextAndShapeLayerColor(isValidStatus: Bool) {
        isValidOtp = isValidStatus

        let textColor: UIColor = isValidStatus ? .blue : .red
        defaultBorderColor = textColor

        for i in stride(from: 0, to: fieldsCount, by: 1) {
            var otpField = viewWithTag(i + 1) as? OTPTextField
            if otpField == nil {
                otpField = otpTextField(forIndex: i)
            }

            let shapeLayerColor: CGColor
            if !(otpField?.text ?? "").isEmpty {
                shapeLayerColor = UIColor.clear.cgColor
            } else {
                shapeLayerColor = isValidStatus ? UIColor.blue.cgColor : UIColor.red.cgColor
            }
            otpField?.textColor = textColor
            otpField?.shapeLayer.fillColor = shapeLayerColor
            otpField?.shapeLayer.strokeColor = shapeLayerColor

            if let text = otpField?.text {
                otpField?.text = text
            }
        }
    }
}
