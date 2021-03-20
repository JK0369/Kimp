//
//  UIDevice.swift
//  TapRider
//
//  Created by 김종권 on 2020/07/31.
//  Copyright © 2020 42dot. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    public var deviceIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
