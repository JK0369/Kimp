//
//  Constants.swift
//  Domain
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation

struct Constants {
    struct Storyboard {
        static let dialog = "Dialog"
    }

    struct KeychainKey {
        static let name = "name"
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let memberID = "memberID"
        static let firebaseAuthToken = "firebaseAuthToken"
        static let uuid = "uuid"
    }

    // sample
    struct DeeplinkKey {
        static let host = "hostSample"
        static let apnKey = "apnKey"
        static let orderID = "orderId"
        static let status = "status"
    }
}
