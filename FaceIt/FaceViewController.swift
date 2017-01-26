//
//  ViewController.swift
//  FaceIt
//
//  Created by Başar Oğuz on 09/06/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    var expression = FacialExpression(eyes: .open, eyeBrows: .relaxed, mouth: .smile){ didSet { updateUI() } }
    
    @IBOutlet weak var faceView: FaceView!{
        
        didSet {
            
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: Selector(("changeScale:"))))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness))
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            updateUI()
        }
    }
    
//    // This will be removed as a functionality.
//    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
//        
//        if recognizer.state == .ended  {
//            //print("I'm in")
//            switch expression.eyes{
//            case .open:
//                expression.eyes = .closed
//            case .closed:
//                expression.eyes = .open
//            case .squinting:
//                break
//            }
//        }
//    }
    
    private struct Animation {
        static let ShakeAngle = CGFloat(M_PI/6)
        static let ShakeDuration = 0.5
    }
    
    @IBAction func headShake(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(
            withDuration: Animation.ShakeDuration,
            animations: {
            self.faceView.transform = CGAffineTransform(rotationAngle: Animation.ShakeAngle)
            },
            completion: { finished in
                UIView.animate(
                    withDuration: Animation.ShakeDuration,
                    animations: {
                        self.faceView.transform = CGAffineTransform(rotationAngle: -Animation.ShakeAngle)
                },
                    completion: { finished in
                        UIView.animate(
                            withDuration: Animation.ShakeDuration,
                            animations: {
                                self.faceView.transform = CGAffineTransform(rotationAngle: 0.0)
                            },
                            completion: { finished in
                                //Nothing to do there, move along.
                                
                            }
                        )
                        
                    }
                )
                
            }
        )
    }
    
    
    
    @IBAction func changeBrows(_ recognizer: UIRotationGestureRecognizer) {
        
        switch recognizer.state {
            
        case .changed:
            
            //print("\(recognizer.rotation)")
            if (recognizer.rotation > 0.38539816339745) {
                expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
                recognizer.rotation = 0
            } else if (recognizer.rotation < -0.38539816339745) {
                expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
                recognizer.rotation = 0
            }
            
        default:
            break
        }
    }
    
    @IBAction func randomizeColor() {
        
        let hue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        let randomColor = UIColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 0.8)
        
        faceView.color = randomColor
    }
    
    @objc func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    @objc func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    
    fileprivate var mouthCurvatures = [FacialExpression.Mouth.frown:-1.0, .grin:0.5, .smile:1.0, .smirk:-0.5, .neutral:0.0]
    
    fileprivate var eyeBrowTilts = [FacialExpression.EyeBrows.furrowed:-0.5, .normal: 0.0, .relaxed: 0.5]
    
    
    fileprivate func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .open: faceView.eyesOpen = true
            case .closed: faceView.eyesOpen = false
            case .squinting: faceView.eyesOpen = false
            }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyebrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
}
