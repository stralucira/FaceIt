//
//  EyeView.swift
//  FaceIt
//
//  Created by Başar Oğuz on 21/01/17.
//  Copyright © 2017 basaroguz. All rights reserved.
//

import UIKit

class EyeView: UIView {

    var lineWidth: CGFloat = 3.0 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    
    
    var _eyesOpen: Bool = true { didSet { setNeedsDisplay() } }

    var eyesOpen: Bool {
        get {
            return _eyesOpen
        }
        set{
            UIView.transition(
                with: self,
                duration: 0.2,
                options: [.transitionFlipFromTop,.curveLinear],
                animations: {
                    self._eyesOpen = newValue
                },
                completion: nil
            )
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        var path: UIBezierPath!
        
        if eyesOpen {
            path = UIBezierPath(ovalIn: bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2))
            
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        }

        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
        
    }
 

    
    
}
