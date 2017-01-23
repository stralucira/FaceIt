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
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay(); leftEye.color = color ; rightEye.color = color  } }
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyesOpen: Bool = true { didSet { leftEye.eyesOpen = eyesOpen ; rightEye.eyesOpen = eyesOpen } }
    @IBInspectable
    var eyebrowTilt: Double = 0.0 { didSet { setNeedsDisplay() } }  //-1 full furrow, 1 fully relaxed
    @IBInspectable
    var mouthCurvature: Double = 1.0 { didSet { setNeedsDisplay() } }
    
    @objc func changeScale(_ recognizer: UIPinchGestureRecognizer){
        
        switch recognizer.state {
        case .changed, .ended:
            //print("I'm in changed or ended")
            self.scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    
    var width: CGFloat {
        return bounds.size.width
    }
    
    var height: CGFloat {
        return bounds.size.height
    }
    
    fileprivate var faceRadius: CGFloat {
        return (min(width,height) / 2)*scale
    }
    
    fileprivate var faceCenter: CGPoint {
        return convert(center, from: superview)
    }
    
    
    fileprivate struct Ratios {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
        static let FaceRadiusToBrowOffset: CGFloat = 5
        
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3

    }
    
    
    fileprivate enum Eye {
        case left
        case right
    }
    
    
    // draw function exists in UIView classes.
    // Only update draw() if you have custom drawing and stroke()
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI) , clockwise: true)
        
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
//        bezierPathForEye(.left).stroke()
//        bezierPathForEye(.right).stroke()
        
        bezierPathForMouth().stroke()
        
        pathForBrow(.left).stroke()
        pathForBrow(.right).stroke()
        
        
    }
    
    fileprivate func getEyeCenter(_ eye: Eye) -> CGPoint {
        
        
        let eyeVerticalOffset = faceRadius / Ratios.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeperation = faceRadius / Ratios.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch eye {
        case .left: eyeCenter.x -= eyeHorizontalSeperation / 2
        case .right: eyeCenter.x += eyeHorizontalSeperation / 2
        }
        return eyeCenter
    }
    
    private lazy var leftEye: EyeView = self.createEye()
    private lazy var rightEye: EyeView = self.createEye()
    
    
    private func createEye() -> EyeView {
        let eye = EyeView()
        eye.isOpaque = false
        eye.color = color
        eye.lineWidth = lineWidth
        self.addSubview(eye)
        return eye
    }
    
    private func positionEye(eye: EyeView, center: CGPoint) {
        
        let size = skullRadius / Ratios.SkullRadiusToEyeRadius * 2
        eye.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        eye.center = center
    }
    
    // Default function that gets called after initiation of the class.
    // Positioning code can only be called in this function.
    override func layoutSubviews() {
        super.layoutSubviews()
        positionEye(eye: leftEye, center: getEyeCenter(Eye.left))
        positionEye(eye: rightEye, center: getEyeCenter(Eye.right))
    }
    
    fileprivate func bezierPathForEye(_ whichEye: Eye) -> UIBezierPath {
        
        let eyeRadius = faceRadius / Ratios.FaceRadiusToEyeRadiusRatio
        
        let eyeCenter = getEyeCenter(whichEye)
        
        if eyesOpen {
            let eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
            eyePath.lineWidth = lineWidth
            return eyePath
        } else {
            let eyePath = UIBezierPath()
            eyePath.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            eyePath.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            eyePath.lineWidth = lineWidth
            return eyePath
        }
    }//end bezierPathForEye()
    
    fileprivate func pathForBrow(_ eye: Eye) -> UIBezierPath {
        
        var tilt = eyebrowTilt
        switch eye {
        case .left:
            tilt *= -1.0
        case .right:
            break
        }
        
        var browCenter = getEyeCenter(eye)
        browCenter.y -= faceRadius / Ratios.FaceRadiusToBrowOffset
        let eyeRadius = faceRadius / Ratios.FaceRadiusToEyeRadiusRatio
        let tiltOffset = CGFloat(max(-1,min(tilt,1)))*eyeRadius/2
        let browStart = CGPoint(x:browCenter.x - eyeRadius, y:browCenter.y - tiltOffset)
        let browEnd = CGPoint(x:browCenter.x + eyeRadius, y:browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    fileprivate func bezierPathForMouth() -> UIBezierPath {
        
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
        mouthPath.move(to: start)
        mouthPath.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        mouthPath.lineWidth = lineWidth
        
        return mouthPath
        
    }//end bezierPathForMouth()
    
}
