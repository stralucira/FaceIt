//
//  FaceView.swift
//  FaceIt
//
//  Created by Başar Oğuz on 09/06/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit

class FaceView: UIView {

    var lineWidth: CGFloat = 3.0 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    
    var width: CGFloat {
        return bounds.size.width
    }
    
    var height: CGFloat {
        return bounds.size.height
    }
    
    var faceRadius: CGFloat {
        return min(width,height) / 2
    }
    
    
    private struct Ratios {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let faceRadius = min(width,height) / 2
        
        let faceCenter = CGPoint(x: bounds.midX, y:bounds.midY)
        
        let face = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI) , clockwise: true)
        
        face.lineWidth = 5.0
        
        UIColor.greenColor().setStroke()
        
        face.stroke()
    }
    
}
