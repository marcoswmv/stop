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
        
        let alertController = UIAlertController(title: "Stop", message: "'\(peerID.displayName)' wants to join the game. Do you accept?", preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default, handler: { [weak self] action in
            invitationHandler(true, self?.mcSession)
            
            let gameSetupViewController = GameSetupViewController.instantiate() as! GameSetupViewController

            self?.navigationController?.pushViewController(gameSetupViewController, animated: true)
        })
        let declineAction = UIAlertAction(title: "Decline", style: .cancel, handler: { [weak self] action in
            invitationHandler(false, self?.mcSession)
        })
        
        alertController.addAction(acceptAction)
        alertController.addAction(declineAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
