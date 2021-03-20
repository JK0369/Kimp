//
//  UserDefaultWrapper.swift
//  Domain
//
//  Created by 김종권 on 2021/01/12.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct UserDefaultsManager {
    @UserDefaultWrapper(key: "userDefaultExample", defaultValue: false)
    static var userDefaultExample: Bool

}
