//
//  View.swift
//  BooksReader
//
//  Created by com on 12/30/20.
//

import Foundation
import UIKit

extension UIView {
    
    func rounded(bkColor: UIColor? = nil, radius: CGFloat = -1, borderColor: UIColor? = nil, borderWidth: CGFloat = 0) {
        if let bkColor = bkColor {
            backgroundColor = bkColor
        }
        
        if radius == -1 {
            layer.cornerRadius = frame.height / 2
        } else {
            layer.cornerRadius = radius
        }
        clipsToBounds = true
        
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
        }
        
        layer.borderWidth = borderWidth
    }
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor? = UIColor.white, borderWidth: CGFloat = 1) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        layer.mask = mask
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor?.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = self.bounds
        layer.addSublayer(borderLayer)
    }
    
    
    func shadow(bkColor: UIColor? = nil, radius: CGFloat = -1, borderColor: UIColor? = nil, borderWidth: CGFloat = 0) {
        if let bkColor = bkColor {
            backgroundColor = bkColor
        }
        
        if radius == -1 {
            layer.cornerRadius = frame.height / 2
        } else {
            layer.cornerRadius = radius
        }
        clipsToBounds = true
        
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
        }
        
        layer.borderWidth = borderWidth
        
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
}
