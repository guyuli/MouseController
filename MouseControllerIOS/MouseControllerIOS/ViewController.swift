//
//  ViewController.swift
//  MouseControllerIOS
//
//  Created by Guyu Li on 2018-03-01.
//  Copyright © 2018 Guyu Li. All rights reserved.
//

import UIKit
import CoreMotion
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var scrollBar: UIView!
    
    var motionManager = CMMotionManager()
    
    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    
    var mcDataSent:MCData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpConnectivity()
        
        // initialize mcDataSent
        mcDataSent = MCData(x: 0, y: 0, scroll: 0, leftClicked: false, rightClicked: false)
        
        // swipe gesture for scroll bar
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeScrollBar(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        scrollBar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeScrollBar(gesture:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        scrollBar.addGestureRecognizer(swipeDown)
        
        // configure motionManager
        motionManager.gyroUpdateInterval = 0.2
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data {
                //print(myData.rotationRate)
                if abs(myData.rotationRate.x) > 0.1 || abs(myData.rotationRate.y) > 0.1 {
                    self.mcDataSent.x = myData.rotationRate.x
                    self.mcDataSent.y = myData.rotationRate.y
                    self.sendData()
                }
            }
        }
    }
    
    /*
    override func viewDidDisappear(_ animated: Bool) {
        self.mcAdvertiserAssistant.stop()
    }
    */
    
    func setUpConnectivity() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        mcSession.delegate = self
        
        // hold a session automatically
        self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "send-data", discoveryInfo: nil, session: self.mcSession)
        self.mcAdvertiserAssistant.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickLeftButton(_ sender: UIButton) {
        print("left button clicked")
        mcDataSent.leftClicked = true;
        sendData()
        mcDataSent.leftClicked = false;
    }
    
    @IBAction func clickRightButton(_ sender: UIButton) {
        print("right button clicked")
        mcDataSent.rightClicked = true;
        sendData()
        mcDataSent.rightClicked = false;
    }
    
    @objc func swipeScrollBar(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                    print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                    print("Swiped down")
                    mcDataSent.scroll = -1;
                    sendData()
                    mcDataSent.scroll = 0;
            case UISwipeGestureRecognizer.Direction.left:
                    print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                    print("Swiped up")
                    mcDataSent.scroll = 1;
                    sendData()
                    mcDataSent.scroll = 0;
            default:
                break
            }
        }
    }
    
    // MC Adviser
    func sendData() {
        if mcSession.connectedPeers.count > 0 {
            if let mcData = try? JSONEncoder().encode(mcDataSent) {
                do {
                    try mcSession.send(mcData, toPeers: mcSession.connectedPeers, with: .reliable)
                }catch{
                    fatalError("Could not send todo item")
                }
            }
        }else{
            print("you are not connected to another device")
        }
    }

    // MC Browser
    //@IBAction func joinSession(_ sender: UIButton) {
        //let mcBrowser = MCBrowserViewController(serviceType: "send-xy", session: self.mcSession)
        //mcBrowser.delegate = self
        //self.present(mcBrowser, animated: true, completion: nil)
    //}
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        /*
        switch state {
            case MCSessionState.connected:
                print("Connected: \(peerID.displayName)")
            case MCSessionState.connecting:
                print("Connecting: \(peerID.displayName)")
            case MCSessionState.notConnected:
                print("Not Connected: \(peerID.displayName)")
            }
         */
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        /*
        do {
            let mcData = try JSONDecoder().decode(MCData.self, from: data)
            
            print("received x = ", mcData.x)
            print("received y = ", mcData.y)
            print("received leftClicked = ", mcData.leftClicked)
            print("received rightClicked = ", mcData.rightClicked)
            
            //DataManager.save(todoItem, with: todoItem.itemIdentifier.uuidString)
            
            /* reload table view
            DispatchQueue.main.async {
                self.todoItems.append(todoItem)
                
                let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
                
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            */
            
        }catch{
            fatalError("Unable to process recieved data")
        }
        */
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}

