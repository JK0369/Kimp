//
//  PassThroughView.swift
//  BaseProject
//
//  Created by 김종권 on 2021/02/03.
//

import UIKit

class PassThroughViewMine: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
         // Get the hit view we would normally get with a standard UIView
         let hitView = super.hitTest(point, with: event)

         // If the hit view was ourself (meaning no subview was touched),
         // return nil instead. Otherwise, return hitView, which must be a subview.
         return hitView == self ? nil : hitView
     }
 }
