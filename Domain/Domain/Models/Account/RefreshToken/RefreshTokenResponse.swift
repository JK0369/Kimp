//
//  RefreshTokenResponse.swift
//  Domain
//
//  Created by 김종권 on 2021/01/27.
//

import Foundation

// MARK: - RefreshTokenResponse
public struct RefreshTokenResponse: BaseResponsable {
    public let responseCode: Int
    public let message: String
    public let result: RefreshTokenResult
}

// MARK: - Result
public struct RefreshTokenResult: Codable {
    public let memberID, accessToken, refreshToken, firebaseAuthToken: String

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case accessToken, refreshToken, firebaseAuthToken
    }
}
