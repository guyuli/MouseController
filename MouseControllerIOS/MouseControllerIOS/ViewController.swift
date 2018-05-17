//
//  ViewController.swift
//  MouseControllerIOS
//
//  Created by Guyu Li on 2018-03-01.
//  Copyright © 2018 Guyu Li. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var scrollBar: UIView!
    
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // swipe gesture for scroll bar
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeScrollBar(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        scrollBar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeScrollBar(gesture:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        scrollBar.addGestureRecognizer(swipeDown)
        
        // configure motionManager
        motionManager.gyroUpdateInterval = 0.2
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data {
                print(myData.rotationRate)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickLeftButton(_ sender: UIButton) {
        print("left button clicked")
    }
    
    @IBAction func clickRightButton(_ sender: UIButton) {
        print("right button clicked")
    }
    
    @objc func swipeScrollBar(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                    print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                    print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                    print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                    print("Swiped up")
            default:
                break
            }
        }
    }
}

