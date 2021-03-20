//
//  CLLocationCoordinate2D.swift
//  TapRider
//
//  Created by 김종권 on 2020/07/29.
//  Copyright © 2020 42dot. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {

    func isEqual(_ coord: CLLocationCoordinate2D, decimalPlace: Int) -> Bool {
        return (self.latitude.roundTo(places: decimalPlace) == coord.latitude.roundTo(places: decimalPlace)) &&
            (self.longitude.roundTo(places: decimalPlace) == coord.longitude.roundTo(places: decimalPlace))
    }

    func isEqual(_ coord: CLLocationCoordinate2D) -> Bool {
        return latitude == coord.latitude && longitude == coord.longitude
    }
}
