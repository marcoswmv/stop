//
//  ViewController.swift
//  Stop
//
//  Created by Marcos Vicente on 05.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MainMenuViewController: BaseViewController {

    @IBOutlet weak var startNewGame: UIButton!

    @IBAction func startNewGameOnTouchUpInside(_ sender: Any) {
        showConnectionPrompt()
        messageToSend = "Sending a message from game host"
    }
    
    @IBAction func showScoreboardOnTouchUpInside(_ sender: Any) {
        
    }
    
    @IBAction func showCategoriesOnTouchUpInside(_ sender: Any) {
        let categoriesViewController = CategoriesViewController.instantiate() as!  CategoriesViewController
        
        navigationController?.pushViewController(categoriesViewController, animated: true)
    }
    
//    deinit {
//        print("\(self) is being deinitialized")
//    }
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser?
    let serviceType = "mwmv-stop"
    
    var messageToSend: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConectivitySession()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sendDataToPeer()
    }
    
    func setupConectivitySession() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }

//    TODO: Method to send data
    func sendDataToPeer() {
        
        if mcSession.connectedPeers.count > 0 {
            
            if let message = messageToSend {
                
                let data = Data(message.utf8)
                
                do {
                    
                    try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                    
                } catch {
                    
//                    TODO: Implement a helper class "Alert
                    
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    func showConnectionPrompt() {
        let alertController = UIAlertController(title: "Connect to other players", message: nil, preferredStyle: .alert)
        
        let hostSessionAction = UIAlertAction(title: "Host game", style: .default, handler: startHostingSession(action:))
        let joinSessionAction = UIAlertAction(title: "Join the game",   style: .default, handler: joinSession(action:))
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(hostSessionAction)
        alertController.addAction(joinSessionAction)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func startHostingSession(action: UIAlertAction!) {
        mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        mcNearbyServiceAdvertiser?.delegate = self
        mcNearbyServiceAdvertiser?.startAdvertisingPeer()
    }

    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: serviceType, session: mcSession)
        
        mcBrowser.minimumNumberOfPeers = 2
        mcBrowser.delegate = self
        
        present(mcBrowser, animated: true)
    }

}

