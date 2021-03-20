//
//  RefreshTokenRequest.swift
//  Domain
//
//  Created by 김종권 on 2021/01/27.
//

import Foundation

public struct RefreshTokenRequest: Codable {
    public let refreshToken: String
    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
