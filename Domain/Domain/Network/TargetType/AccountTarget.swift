//
//  AccountTarget.swift
//  Domain
//
//  Created by 김종권 on 2021/01/27.
//

import Foundation
import Moya

public enum AccountTarget {
    case signUp(SignUpRequest)
    case signIn(SignInRequest)
    case verifyToken(VerifyTokenRequest)
    case refreshToken(RefreshTokenRequest)
    case verifyBirthdate(VerifyBirthdateRequest)
}

extension AccountTarget: BaseTargetType {
    public var path: String {
        switch self {
        case .signUp:
            return "rider/member/signUp"
        case .signIn:
            return "rider/member/signIn"
        case .verifyToken:
            return "auth/token/verify"
        case .refreshToken:
            return "rider/member/signIn/refreshToken"
        case .verifyBirthdate:
            return "rider/member/confirm-pin"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var sampleData: Data {
        switch self {
        case .signUp:
            return """
                {
                   "responseCode":0,
                   "message":"COMMON_OK",
                   "result":{
                      "memberId":"IitrZs9TSuiq2UG0AHgQkQ",
                      "accessToken":"eyJzZXJ2aWNlTWVtYmVySWQiOiJJaXRyWnM5VFN1aXEyVUcwQUhnUWtRIiwiZGV2aWNlVW5pcXVlSWQiOiJkZXZpY2UwMDAifQ.SigRolYfAciV_d11kpvnhSjDpllu7eoExSwyEvEBzZc",
                      "refreshToken":"eyJzZXJ2aWNlTWVtYmVySWQiOiJJaXRyWnM5VFN1aXEyVUcwQUhnUWtRIiwiZGV2aWNlVW5pcXVlSWQiOiJkZXZpY2UwMDAifQ.-KWVtAFUReZinjG7C07izkh9_qU5hzLSprIZNujDKr0",
                      "firebaseAuthToken":"eyJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImNsYWltcyI6eyJhcHBUeXBlICI6MX0sImV4cCI6MTYxMDk0MDgyOCwiaWF0IjoxNjEwOTM3MjI4LCJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay04ejd4ZUB0YXAtZDcyZmEuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJmaXJlYmFzZS1hZG1pbnNkay04ejd4ZUB0YXAtZDcyZmEuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJ1aWQiOiJjOThlNWM1MS01ZGRlLTQ3MWQtOWRjZC05ZGQ3MGVmYWRmMjIifQ.eDScIfu0OLfIepA9oahucv6DNNsU71I9xZMZ7Iq_1nXqQs3wpwQCZQgFQ-rrDgItuVrakDJrzMhjYSGe0a7JpSgVP4bTIdW0KgOsSW9dEyKma1jojPaz3KRaa_EeI4kJSXzYiWha98r7tLEJ6A9CbsSwHtsJLFWLd2urU1vc89kSn9TGx2o8tdBpai1BLiemg19LSoN9Ams-ayIeiAw9KQSFSUcAsarGQAJAW2sd_Z1OTphfmWSKrlefvi_Dwq1er7k7M2PaJ7yL56FBaZGP1cJRY71F-YyROvHklVoC-frLfnr_VJx4kPiJsLcUALzlwLzmpsY9pY8w7u-E0vaMVQ"
                   }
                }
            """.data(using: .utf8)!
        case .signIn:
            return """
            {
              "responseCode" : 0,
              "message" : "COMMON_OK",
              "result" : {
                "accessToken" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXJ2aWNlTWVtYmVySWQiOiJTVVBFUi1UQVAtUklERVIiLCJkZXZpY2VVbmlxdWVJZCI6IiJ9.Ld7mhtepBUoMvjHluH9WhNkJnWBGUYwQagPqGK1cmUU",
                "refreshToken" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXJ2aWNlTWVtYmVySWQiOiJTVVBFUi1UQVAtUklERVIiLCJkZXZpY2VVbmlxdWVJZCI6IiJ9.eZCfVWkVHAq1tKewA0mWRrjt3aIwELc7x1OIeQQ8LAM"
              }
            }
            """.data(using: .utf8)!
        case .verifyToken:
            return """
                {
                  "responseCode" : 0,
                  "message" : "success",
                  "result" : {
                    "serviceMemberId" : "SUPER-TAP-RIDER",
                    "name" : "super rider",
                    "email" : "test-rider@42dot.ai",
                    "mobilePhoneNumber" : "01028101936",
                    "internationalCallingCountryNumber" : "+82",
                    "mobilePhoneNumberAuthenticationCompleted" : null,
                    "birthDate" : "1970-01-01",
                    "genderType" : ""
                    }
                }
                """.data(using: .utf8)!
        case .refreshToken:
            return """
                {
                  "responseCode" : 0,
                  "message" : "COMMON_OK",
                  "result" : {
                    "memberId" : "SUPER-TAP-RIDER",
                    "accessToken" : "eyJzZXJ2aWNlTWVtYmVySWQiOiJTVVBFUi1UQVAtUklERVIiLCJkZXZpY2VVbmlxdWVJZCI6IiJ9.YcGvtVux6mRa78Zp7gtWvcV_rIK30Z4egMaCL6k2U60",
                    "refreshToken" : "eyJzZXJ2aWNlTWVtYmVySWQiOiJTVVBFUi1UQVAtUklERVIiLCJkZXZpY2VVbmlxdWVJZCI6IiJ9.u1t3A1Q-Gd40qkEQbfozbfsae1hq-oYPXO5CUAAQYoE",
                    "firebaseAuthToken" : "eyJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsImNsYWltcyI6eyJhcHBUeXBlICI6MX0sImV4cCI6MTYxMDk0MDgyOSwiaWF0IjoxNjEwOTM3MjI5LCJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay04ejd4ZUB0YXAtZDcyZmEuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzdWIiOiJmaXJlYmFzZS1hZG1pbnNkay04ejd4ZUB0YXAtZDcyZmEuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJ1aWQiOiJjOThlNWM1MS01ZGRlLTQ3MWQtOWRjZC05ZGQ3MGVmYWRmMjIifQ.jr7ARDYCmoUJ_TVulrsdjAN6cl-tPG5Sd1RzwFQGF3CCtroXyzmOdtQxxzGRv-wmYqi1LGSeNsOpZAvo0QQYHC9wVQbpjp3hpfCv2uItKkIrUTIcUJPYs8nAqEqfcxzrjccvvgNN1eJSF1diVFA8AY9f_d-383CllHVnVRFuBiYAmfK9c9Ps7dEWiMHT8unfo5dYW0prk6EAzxi8Icsdkio3hxguodAsu093ZdCYuyDKNxuOcoNrhcc8fXjr6G5LMUgU835O9ZFQnjSSxjV07BERh2JJiiVj5uhKGw7PrfStChxcvbKsJk85fdJcrHND54SS_iArAh6M49JB9cKIjw"
                  }
                }
                """.data(using: .utf8)!
        case .verifyBirthdate:
            return """
                {
                  "responseCode" : 0,
                  "message" : "COMMON_OK"
                }
                """.data(using: .utf8)!
        }
    }

    public var task: Task {
        switch self {
        case .signUp(let request):
            return .requestJSONEncodable(request)
        case .signIn(let request):
            return .requestJSONEncodable(request)
        case .verifyToken(let request):
            return .requestJSONEncodable(request)
        case .refreshToken(let request):
            return .requestJSONEncodable(request)
        case .verifyBirthdate(let request):
            return .requestJSONEncodable(request)
        }
    }
}

// MARK: - sample: Domain/Models/{group}로 이동 필요
public struct SignUpRequest: Codable {
}
public struct SignInRequest: Codable {
}
public struct SignUpResponse: BaseResponsable {
    public var responseCode: Int
    public var message: String
}
public struct VerifyTokenRequest: Codable {
}
public struct VerifyBirthdateRequest: Codable {
}
