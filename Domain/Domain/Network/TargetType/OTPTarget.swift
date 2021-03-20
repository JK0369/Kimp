//
//  OTPTarget.swift
//  Domain
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation
import Moya
import CommonExtension

// 주입 받는 쪽 : VM의 dependencies에 BaseService<OTPTarget>
// 주입 하는 쪽 : Builder에서 BaseService<OTPTarget>.makeProvider()

public enum OTPTarget {
    case sms(SmsOtpRequest)
    case verifySms(SmsOtpResponse)
}

extension OTPTarget: BaseTargetType {
    public var path: String {
        switch self {
        case .sms:
            return "auth/otp/sms/request"
        case .verifySms:
            return "auth/otp/sms/verify"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var sampleData: Data {
        switch self {
        case .sms:
            return """
                {
                  "responseCode" : 0,
                  "message" : "COMMON_OK"
                }
                """.data(using: .utf8)!
        case .verifySms:
            return """
                {
                  "responseCode" : 0,
                  "message" : "COMMON_OK",
                  "result" : {
                    "riderMemberId" : "BE5-RIDER",
                    "driverMemberId" : "driver",
                    "email" : "moran.kim@42dot.ai"
                  }
                }
                """.data(using: .utf8)!
        }
    }

    public var task: Task {
        switch self {
        case .sms(let request):
            return .requestJSONEncodable(request)
        case .verifySms(let request):
            return .requestJSONEncodable(request)
        }
    }
}

/*

 - query parameter request방법: task에서,

 case .estimate(let request):
     return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)

 - bearer token 보내는 방법
 * extension _Target: 여기에 AccessTokenAuthorizable추가
 * public var authorizationType추가
 public var authorizationType: AuthorizationType? {
     switch self {
     default:
         return .bearer
     }
 }

 */
