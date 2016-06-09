//
//  FaceView.swift
//  FaceIt
//
//  Created by Başar Oğuz on 09/06/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit

class FaceView: UIView {

    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let width = bounds.size.width
        let height = bounds.size.height
        
        let faceRadius = min(width,height) / 2
        
        let faceCenter = CGPoint(x: bounds.midX, y:bounds.midY)
        
        let face = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI) , clockwise: true)
        
        face.lineWidth = 5.0
        
        UIColor.greenColor().setStroke()
        
        face.stroke()
    }
}
