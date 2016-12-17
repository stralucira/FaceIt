//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Başar Oğuz on 07/07/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//
import UIKit

class EmotionsViewController: UIViewController {

    fileprivate let emotions: Dictionary<String, FacialExpression> = [
        "angry" : FacialExpression(eyes: .closed, eyeBrows: .furrowed, mouth: .frown),
        "happy" : FacialExpression(eyes: .open, eyeBrows: .relaxed, mouth: .smile),
        "worried" : FacialExpression(eyes: .open, eyeBrows: .relaxed, mouth: .smirk),
        "playful" : FacialExpression(eyes: .open, eyeBrows: .furrowed, mouth: .grin),
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationvc = segue.destination
        
        if let facevc = destinationvc as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotions[identifier]{
                    facevc.expression = expression
                    if let sendingButton = sender as? UIButton{
                        facevc.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }
}
