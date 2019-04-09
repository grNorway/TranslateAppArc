//
//  UIButton+Extension.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 09/04/2019.
//  Copyright © 2019 Panagiotis Siapkaras. All rights reserved.
//

import UIKit

extension UIButton {
    
    func roundedLeftCorners(){
        let maskpath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft,.bottomLeft], cornerRadii: CGSize(width: 19, height: 0))
        let masklayer = CAShapeLayer()
        masklayer.frame = bounds
        masklayer.path = maskpath.cgPath
        layer.mask = masklayer
    }
    
    func rounderRightCorners() {
        let maskpath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: 19, height: 0))
        let masklayer = CAShapeLayer()
        masklayer.frame = bounds
        masklayer.path = maskpath.cgPath
        layer.mask = masklayer
    }
}
