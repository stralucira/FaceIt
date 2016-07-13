//
//  FaceView.swift
//  FaceIt
//
//  Created by Başar Oğuz on 09/06/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var lineWidth: CGFloat = 3.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyesOpen: Bool = true { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyebrowTilt: Double = 0.0 { didSet { setNeedsDisplay() } }  //-1 full furrow, 1 fully relaxed
    @IBInspectable
    var mouthCurvature: Double = 1.0 { didSet { setNeedsDisplay() } }
    
    @objc func changeScale(recognizer: UIPinchGestureRecognizer){
        
        switch recognizer.state {
        case .Changed, .Ended:
            //print("I'm in changed or ended")
            self.scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    
    var width: CGFloat {
        return bounds.size.width
    }
    
    var height: CGFloat {
        return bounds.size.height
    }
    
    private var faceRadius: CGFloat {
        return (min(width,height) / 2)*scale
    }
    
    private var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    
    private struct Ratios {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
        static let FaceRadiusToBrowOffset: CGFloat = 5
    }
    
    
    private enum Eye {
        case Left
        case Right
    }
    
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI) , clockwise: true)
        
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        bezierPathForMouth().stroke()
        
        pathForBrow(.Left).stroke()
        pathForBrow(.Right).stroke()
        
        
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        
        
        let eyeVerticalOffset = faceRadius / Ratios.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeperation = faceRadius / Ratios.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeHorizontalSeperation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeperation / 2
        }
        return eyeCenter
    }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        
        let eyeRadius = faceRadius / Ratios.FaceRadiusToEyeRadiusRatio
        
        let eyeCenter = getEyeCenter(whichEye)
        
        if eyesOpen {
            let eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
            eyePath.lineWidth = lineWidth
            return eyePath
        } else {
            let eyePath = UIBezierPath()
            eyePath.moveToPoint(CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            eyePath.addLineToPoint(CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            eyePath.lineWidth = lineWidth
            return eyePath
        }
    }//end bezierPathForEye()
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        
        var tilt = eyebrowTilt
        switch eye {
        case .Left:
            tilt *= -1.0
        case .Right:
            break
        }
        
        var browCenter = getEyeCenter(eye)
        browCenter.y -= faceRadius / Ratios.FaceRadiusToBrowOffset
        let eyeRadius = faceRadius / Ratios.FaceRadiusToEyeRadiusRatio
        let tiltOffset = CGFloat(max(-1,min(tilt,1)))*eyeRadius/2
        let browStart = CGPoint(x:browCenter.x - eyeRadius, y:browCenter.y - tiltOffset)
        let browEnd = CGPoint(x:browCenter.x + eyeRadius, y:browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.moveToPoint(browStart)
        path.addLineToPoint(browEnd)
        path.lineWidth = lineWidth
        return path
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
        
    }//end bezierPathForMouth()
    
}
