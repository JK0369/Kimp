//
//  Constants.swift
//  BaseProject
//
//  Created by 김종권 on 2020/12/27.
//

import Foundation
import UIKit

struct Constants {

    struct System {
        static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
        static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        static func latestVersion() -> String? {
            let appleID = "이곳에 apple ID"
            guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)"),
                  let data = try? Data(contentsOf: url),
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results[0]["version"] as? String else {
                return nil
            }
            return appStoreVersion
        }
    }

    struct Storyboard {
        static let splash = "Splash"
        static let dialog = "Dialog"
        static let floatingPanelExample = "FloatingPanelExample"
    }

    static let throttleDurationMilliseconds = 500

    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/1548711244" // 1548711244는 Apple ID

    struct ComponentStyle {
        static let intervalSizeBetweenButtonAndKeyboard: CGFloat = 16
    }
}
