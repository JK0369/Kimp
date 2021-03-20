//
//  Keychain.swift
//  BaseProject
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation
import KeychainAccess
import Domain
import CommonExtension

public class KeychainService: KeyValueStore {

    // Access Group will be used when there is a extension

    public static let shared = KeychainService()

    let lockCredentials = Keychain()

    // MARK: Save
    public func save(key: String, value: String) {
        do {
            if let encryptValue = Crypto.encrypt(input: value) {
                Log.debug("CRPYTO", "SAVE", key, value, "->", encryptValue)
                try lockCredentials.set(encryptValue, key: key)
            } else {
                Log.debug("CRPYTO", "SAVE FAILED", key, value)
            }
        } catch let error {
            Log.error("KEYCHAIN SAVE :: Failed to save this value with this key \(key) => \(error)")
        }

    }

    public func save(key: String, value: Data) {
        do {
            try lockCredentials.set(value, key: key)
        } catch {
            Log.error("KEYCHAIN SAVE OBJ :: Failed to save this object with this key \(key)")
        }
    }

    // MARK: Get

    public func get(key: String) -> String? {
        var decrypt: String?
        var encrypt: String?
        if let value = lockCredentials[string: key] {
            encrypt = value
            decrypt = Crypto.decrypt(input: value)
        }
        Log.debug("CRPYTO", "GET", key, String(describing: encrypt), "->", String(describing: decrypt))
        return decrypt
    }

    public func getData(for key: String) -> Data? {

        do {
            guard let key = try lockCredentials.getData(key) else { return nil }
            return key
        } catch {
            Log.error(error)
            return nil
        }
    }

    func getObject(key: String) -> Any {

        var storedData: Any?
        storedData = NSKeyedUnarchiver.unarchiveObject(with: lockCredentials[data: key]!)

        guard let data = storedData else {
            return ""
        }

        return data
    }

    // MARK: Delete
    public func delete(key: String) {
        do {
            try lockCredentials.remove(key)
        } catch {
            Log.error("KEYCHAIN DELETE :: Failed to remove keychain data with this key : \(key)")
        }
    }

    // MARK: Remove All
    public func removeAll() {
        do {
            try lockCredentials.removeAll()
        } catch {
            Log.error("KEYCHAIN REMOVE ALL :: Failed to remove all keychain data")
        }
    }
}


public class KeychainMock: KeyValueStore {

    var stores: [String: Any] = [:] {
        didSet {
            Log.debug("keychian values ", stores)
        }
    }

    public init() {

    }

    public func save(key: String, value: String) {
        stores[key] = value
    }

    public func save(key: String, value: Data) {
        stores[key] = value
    }

    public func get(key: String) -> String? {
        return stores[key] as? String
    }

    public func getData(for key: String) -> Data? {
        return stores[key] as? Data
    }

    public func delete(key: String) {
        stores.removeValue(forKey: key)
    }

    public func removeAll() {
        stores.removeAll()
    }

}
