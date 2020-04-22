//
//  MainMenuVc+MCAdvertiserAssistantDelegate.swift
//  Stop
//
//  Created by Marcos Vicente on 08.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import MultipeerConnectivity

extension MainMenuViewController: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        let alertController = UIAlertController(title: "Stop",
                                                message: NSLocalizedString("'\(peerID.displayName)' is inviting you to join the game. Do you accept?", comment: "Invitation alert message - '\(peerID.displayName)' is inviting you to join the game. Do you accept?"), preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: NSLocalizedString("Accept", comment: "Invitation alert button - Accept"),
                                         style: .default, handler: { [weak self] action in
                                            
                                            let mcSession = self?.appDelegate.connectionManager.mcSession
                                            invitationHandler(true, mcSession)
                                            
                                            do {
                                                guard let game = context else { return }
                                                let gameToReceive = try JSONDecoder().decode(Game.self, from: game)
                                            
                                                guard let deviceName = self?.appDelegate.connectionManager.peerID.displayName else { return }
                                                guard let newPlayer = self?.gameManager.createNewPlayer(name: deviceName, deviceName: deviceName, game: gameToReceive) else { return }
                                                
                                                
                                                let gameSetupViewController = GameSetupViewController.instantiate() as! GameSetupViewController
                                                
                                                gameSetupViewController.newGame = gameToReceive
                                                gameSetupViewController.connectionManager = self?.appDelegate.connectionManager
                                                gameSetupViewController.typeOfPlayer = .Invited
                                                gameSetupViewController.newPlayer = newPlayer
                                                self?.navigationController?.pushViewController(gameSetupViewController, animated: true)
                                                
                                            } catch {
                                                Alert.shared.showReceptionError(on: UIApplication.getTopViewController()!, message: error.localizedDescription)
                                            }
        })
        let declineAction = UIAlertAction(title: NSLocalizedString("Decline", comment: "Invitation alert button - Decline"),
                                          style: .cancel, handler: { [weak self] action in
                                            
                                            let mcSession = self?.appDelegate.connectionManager.mcSession
                                            invitationHandler(false, mcSession)
        })
        
        alertController.addAction(acceptAction)
        alertController.addAction(declineAction)
        
        DispatchQueue.main.async { self.present(alertController, animated: true, completion: nil) }
    }
}
