//
//  ViewController.swift
//  MouseControllerOSX
//
//  Created by Guyu Li on 2018-05-17.
//  Copyright © 2018 Guyu Li. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

class ViewController: NSViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {

    
    @IBOutlet weak var xTextField: NSTextField!
    @IBOutlet weak var yTextField: NSTextField!
    @IBOutlet weak var clickTextField: NSTextField!
    @IBOutlet weak var scrollTextField: NSTextField!
    
    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    
    var mcBrowser:MCBrowserViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpConnectivity()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func setUpConnectivity() {
        peerID = MCPeerID(displayName: "GuyuMac")
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        mcSession.delegate = self
        
        // hold a session automatically
        //self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "send-xy", discoveryInfo: nil, session: self.mcSession)
        //self.mcAdvertiserAssistant.start()
    }
    
    
    @IBAction func holdSession(_ sender: NSButton) {
        mcBrowser = MCBrowserViewController(serviceType: "send-data", session: self.mcSession)
        mcBrowser.delegate = self
        self.presentViewControllerAsSheet(mcBrowser)
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let mcData = try JSONDecoder().decode(MCData.self, from: data)
            
            print("received x = ", mcData.x)
            print("received y = ", mcData.y)
            print("received leftClicked = ", mcData.leftClicked)
            print("received rightClicked = ", mcData.rightClicked)
            print("received scroll = ", mcData.scroll)
            
            DispatchQueue.main.async {
                self.xTextField.stringValue = mcData.x.description
                self.yTextField.stringValue = mcData.y.description
                if (mcData.leftClicked) {
                    self.clickTextField.stringValue = "L Clicked"
                }
                else if (mcData.rightClicked) {
                    self.clickTextField.stringValue = "R Clicked"
                }
                else {
                    self.clickTextField.stringValue = ""
                }
                if (mcData.scroll == 1) {
                    self.scrollTextField.stringValue = "Up"
                }
                else if (mcData.scroll == -1) {
                    self.scrollTextField.stringValue = "Down"
                }
                else {
                    self.scrollTextField.stringValue = ""
                }
            }
            
            
        }catch{
            fatalError("Unable to process recieved data")
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.dismissViewController(browserViewController)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.dismissViewController(browserViewController)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }

}

