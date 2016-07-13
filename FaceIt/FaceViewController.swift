//
//  ViewController.swift
//  FaceIt
//
//  Created by Başar Oğuz on 09/06/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    var expression = FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smile){ didSet { updateUI() } }
    
    @IBOutlet weak var faceView: FaceView!{
        
        didSet {
            
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "changeScale:"))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness))
            happierSwipeGestureRecognizer.direction = .Up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderSwipeGestureRecognizer.direction = .Down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(recognizer: UITapGestureRecognizer) {
        
        if recognizer.state == .Ended  {
            //print("I'm in")
            switch expression.eyes{
            case .Open:
                expression.eyes = .Closed
            case .Closed:
                expression.eyes = .Open
            case .Squinting:
                break
            }
        }
    }
    
    
    @IBAction func changeBrows(recognizer: UIRotationGestureRecognizer) {
        
        switch recognizer.state {
            
        case .Changed:
            
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
    
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown:-1.0, .Grin:0.5, .Smile:1.0, .Smirk:-0.5, .Neutral:0.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Furrowed:-0.5, .Normal: 0.0, .Relaxed: 0.5]
    
    
    private func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyebrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
}
