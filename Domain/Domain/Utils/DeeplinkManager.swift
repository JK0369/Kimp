//
//  DeeplinkManager.swift
//  Domain
//
//  Created by 김종권 on 2020/11/09.
//  Copyright © 2020 42dot. All rights reserved.
//

import Foundation
import UIKit

enum DeeplinkTarget {
    case receipt(orderID: Int)
    case riding
    case qna
}

enum HostType: String {
    case navigation
}

public class DeeplinkManager {
    static var postTaskManager: PostTaskManager!

    // e.g.: taprider://navigation?orderId=7988&status=ODST000013
    public static func processDeeplink(response: UNNotificationResponse, postTaskManager: PostTaskManager) {
        self.postTaskManager = postTaskManager
        let userInfo = response.notification.request.content.userInfo

        guard let url = deeplinkURL(userInfo: userInfo),
              let host = url.host,
              let hostType = HostType(rawValue: host) else {
            return
        }

        sectionizeDeeplink(url: url, hostType: hostType)
    }

    static private func deeplinkURL(userInfo: [AnyHashable: Any]) -> URLComponents? {

        guard let abURI = userInfo[Constants.DeeplinkKey.apnKey] as? String,
              let url = URLComponents(string: abURI) else {
            return nil
        }
        return url
    }

    static private func sectionizeDeeplink(url: URLComponents, hostType: HostType) {
        switch hostType {
        case .navigation:
            // deeplink to receipt
            if let orderID = url.queryItems?.first(where: { $0.name == Constants.DeeplinkKey.orderID })?.value?.toInt,
               let status = url.queryItems?.first(where: { $0.name == Constants.DeeplinkKey.status })?.value,
               status.contains("MKMK000001") {
                registerDeeplinkTask(deeplinkTarget: .receipt(orderID: orderID))
                return
            }
        }

        // TODO: deeplink to qna
    }

    static private func registerDeeplinkTask(deeplinkTarget: DeeplinkTarget) {

        switch deeplinkTarget {

        case .receipt(let orderID):
//            postTaskManager.register(
//                postTask: PostTask(
//                    target: .home,
//                    task: .receipt(orderID: orderID)
//                )
//            )
//            NotificationCenter.default.post(name: .home, object: nil)

        /* 사용하는쪽
         NotificationCenter.default.rx.notification(.home)
             .asDriverOnErrorNever()
             .drive(onNext: { [weak self] _ in
                 self?.processPostTask()
             }).disposed(by: disposeBag)
         */
            print(orderID)
            break
        case .riding:
            break

        case .qna:
            // TODO
            break
        }
    }
}
