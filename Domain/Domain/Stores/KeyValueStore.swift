//
//  KeyValueStore.swift
//  Domain
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation

public protocol KeyValueStore {
    func save(key: String, value: String)
    func get(key: String) -> String?
    func delete(key: String)
    func removeAll()
}

public extension KeyValueStore {

    // MARK: - Getter

    func name() -> String {
        return get(key: Constants.KeychainKey.name) ?? ""
    }

    func userAccessToken() -> String {
        return get(key: Constants.KeychainKey.accessToken).orElse("")
    }

    func userRefreshToken() -> String {
        return get(key: Constants.KeychainKey.refreshToken).orElse("")
    }

    func memberID() -> String {
        return get(key: Constants.KeychainKey.memberID).orElse("")
    }

    func uuid() -> String {
        return get(key: Constants.KeychainKey.uuid).orElse("")
    }

    // MARK: - Setter

    func saveName(_ name: String) {
        save(key: Constants.KeychainKey.name, value: name)
    }

    func saveAccessToken(_ accessToken: String) {
        return save(key: Constants.KeychainKey.accessToken, value: accessToken)
    }

    func saveRefreshToken(_ refreshToken: String) {
        return save(key: Constants.KeychainKey.refreshToken, value: refreshToken)
    }

    func saveMemberID(_ memberID: String) {
        return save(key: Constants.KeychainKey.memberID, value: memberID)
    }

    func setUUID(_ uuid: String) {
        return save(key: Constants.KeychainKey.uuid, value: uuid)
    }

    // MARK: - Delete

    func deleteUserInfo() {
        delete(key: Constants.KeychainKey.name)
        delete(key: Constants.KeychainKey.accessToken)
        delete(key: Constants.KeychainKey.refreshToken)
        delete(key: Constants.KeychainKey.firebaseAuthToken)

    }
}
