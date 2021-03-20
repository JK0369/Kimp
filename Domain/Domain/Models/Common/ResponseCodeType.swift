//
//  ResponseCodeType.swift
//  Domain
//
//  Created by 김종권 on 2021/01/14.
//

import Foundation

public enum ResponseCodeType: Int, Codable {

    // MARK: - Common

    case commonOk = 0
    case commonUnknown = 101

    // MARK: - Auth

    case notValidToken = 207
    case memberNotFound = 601
    case passwordNotMatch = 602
    
}
