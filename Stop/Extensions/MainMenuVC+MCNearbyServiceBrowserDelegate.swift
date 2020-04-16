//
//  MainMenuViewController+MCBrowserViewControllerDelegate.swift
//  Stop
//
//  Created by Marcos Vicente on 06.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import MultipeerConnectivity

extension MainMenuViewController: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let newGameID = gameManager.createNewGame().id // Where I create the GameID
        let data = Data(newGameID!.utf8)
        let session = appDelegate.connectionManager.mcSession!
        let waitingTime = TimeInterval(0)
        
//        Inviting all the players that are nearby
        browser.invitePeer(peerID, to: session, withContext: data, timeout: waitingTime)
                
//        Switching to game setup
        let gameSetupViewController = GameSetupViewController.instantiate() as! GameSetupViewController

        gameSetupViewController.newGameID = newGameID
        gameSetupViewController.connectionManager = appDelegate.connectionManager
        gameSetupViewController.session = appDelegate.connectionManager.mcSession
        gameSetupViewController.typeOfPlayer = .Host

        navigationController?.pushViewController(gameSetupViewController, animated: true)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("The peer \(peerID) was lost!")
    }
}
