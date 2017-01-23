//
//  BlinkingFaceViewController.swift
//  FaceIt
//
//  Created by Başar Oğuz on 19/01/17.
//  Copyright © 2017 basaroguz. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController {

    var blinking: Bool = false {
        
        didSet{
            startBlink()
        }
    }
    
    private struct BlinkRate {
        static let ClosedDuration = 0.4
        static let OpenDuration = 2.5
    }
    
    func startBlink() {
        
        //if the system is in a blinking state ;)

        if blinking {
            faceView.eyesOpen = false
            
            //after a moment open them again
            Timer.scheduledTimer(timeInterval: BlinkRate.ClosedDuration,
                                 target: self,
                                 selector: #selector(endBlink),
                                 userInfo: nil,
                                 repeats: false)
        }
    }
    
    func endBlink() {
        
        faceView.eyesOpen = true
        
        Timer.scheduledTimer(timeInterval: BlinkRate.OpenDuration,
                             target: self,
                             selector: #selector(startBlink),
                             userInfo: nil,
                             repeats: false)
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blinking = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blinking = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
