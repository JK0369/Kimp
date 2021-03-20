//
//  Double.swift
//  TapRider
//
//  Created by 김종권 on 2020/07/29.
//  Copyright © 2020 42dot. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
