//
//  Circle.swift
//  The Patel
//
//  Created by Akash on 23/02/24.
//

import Foundation
import UIKit

class Circle: UIView{
    override func draw(_ rect: CGRect) {
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2
            
            let startAngle: CGFloat = 0
            let endAngle: CGFloat = .pi / 2
            
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addLine(to: center)
            path.close()
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = UIColor.black.cgColor
            
            layer.addSublayer(shapeLayer)
        }
}
