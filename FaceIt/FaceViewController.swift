//
//  ViewController.swift
//  FaceIt
//
//  Created by Başar Oğuz on 09/06/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile){ didSet { updateUI() } }
    
    
    @IBOutlet weak var faceView: FaceView!{ didSet { updateUI() } }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown:-1.0, .Grin:1, .Smile:1.0, .Smirk:-0.5, .Neutral:0.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Furrowed:-0.5, .Normal: 0.0, .Relaxed: 0.5]
    
    
    private func updateUI() {
        switch expression.eyes {
        case .Open: faceView.eyesOpen = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyebrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        
    }
}
