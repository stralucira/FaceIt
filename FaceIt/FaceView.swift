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
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    
    private struct Ratios {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let faceRadius = min(width,height) / 2
        
        let faceCenter = CGPoint(x: bounds.midX, y:bounds.midY)
        
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI) , clockwise: true)
        
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        bezierPathForMouth().stroke()
        
        
    }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        
        let eyeRadius = faceRadius / Ratios.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Ratios.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeperation = faceRadius / Ratios.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
            case .Left: eyeCenter.x -= eyeHorizontalSeperation / 2
            case .Right: eyeCenter.x += eyeHorizontalSeperation / 2
        }
        let eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
            
        eyePath.lineWidth = lineWidth
        
        return eyePath
    }
    
    private func bezierPathForMouth() -> UIBezierPath {
        
        let mouthHeight = faceRadius / Ratios.FaceRadiusToMouthHeightRatio
        let mouthWidth = faceRadius / Ratios.FaceRadiusToMouthWidthRatio
        let mouthVerticalOffset = faceRadius / Ratios.FaceRadiusToMouthOffsetRatio
        
        let mouthRect = CGRect(
            x: faceCenter.x - mouthWidth/2,
            y: faceCenter.y + mouthVerticalOffset,
            width: mouthWidth,
            height: mouthHeight)
        
        let mouthCurvature: Double = 1
        
        let smileOffset = CGFloat(max(-1,min(mouthCurvature,1)))*mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.minY + smileOffset)
        
        let mouthPath = UIBezierPath()
        mouthPath.moveToPoint(start)
        mouthPath.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        mouthPath.lineWidth = lineWidth
        
        return mouthPath
    }
    
}
