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
        let newGame = gameManager.createNewGame()
        let deviceName = appDelegate.connectionManager.peerID.displayName
        let newPlayer = gameManager.createNewPlayer(name: deviceName, deviceName: deviceName, game: newGame)
        let session = appDelegate.connectionManager.mcSession!
        let waitingTime = TimeInterval(0)
        
        do {
            let gameAsData = try JSONEncoder().encode(newGame)
            browser.invitePeer(peerID, to: session, withContext: gameAsData, timeout: waitingTime)
        } catch {
            Alert.shared.showSendError(on: UIApplication.getTopViewController()!, message: error.localizedDescription)
        }
        
        let gameSetupViewController = GameSetupViewController.instantiate() as! GameSetupViewController

        gameSetupViewController.newGame = newGame
        gameSetupViewController.connectionManager = appDelegate.connectionManager
        gameSetupViewController.typeOfPlayer = .Host
        gameSetupViewController.newPlayer = newPlayer
        navigationController?.pushViewController(gameSetupViewController, animated: true)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("The peer \(peerID) was lost!")
    }
}
