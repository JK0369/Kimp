//
//  LocalizableExtension.swift
//  CommonExtension
//
//  Created by 김종권 on 2021/01/20.
//

import UIKit

// MARK: - Localizable

public protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

// MARK: - XIBLocalizable

public protocol XIBLocalizable {
    var localizableKey: String? { get set }
    var placeholderKey: String? { get set }
}

public extension XIBLocalizable {
    var placeholderKey: String? {
        get {
            return nil
        }
        set {
            _ = newValue
        }
    }
}

extension UILabel: XIBLocalizable {
    @IBInspectable public var localizableKey: String? {
        get {
            return nil
        }
        set(key) {
            text = key?.localized
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable public var localizableKey: String? {
        get {
            return nil
        }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
   }
}

extension UITextField: XIBLocalizable {
    @IBInspectable public var placeholderKey: String? {
        get {
            return nil
        }
        set(key) {
            placeholder = key?.localized
        }
    }
    @IBInspectable public var localizableKey: String? {
        get {
            return nil
        }
        set(key) {
            text = key?.localized
        }
   }
}


extension UITextView: XIBLocalizable {
    @IBInspectable public var localizableKey: String? {
        get {
            return nil
        }
        set(key) {
            text = key?.localized
        }
   }
}
