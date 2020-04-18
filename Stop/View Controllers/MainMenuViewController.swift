//
//  ViewController.swift
//  Stop
//
//  Created by Marcos Vicente on 05.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import MultipeerConnectivity

enum TypeOfPlayer: String {
    case Host = "HostPlayer"
    case Invited = "InvitedPlayer"
}

class MainMenuViewController: BaseViewController {

    @IBOutlet weak var startNewGame: UIButton!

    @IBAction func startNewGameOnTouchUpInside(_ sender: Any) {
        Alert.shared.showInvitationAlert(on: self,
                                         with: NSLocalizedString("Invite players",
                                                                 comment: "Invite players Alert Title - Invite players"),
                                         message: nil)
    }
    
    @IBAction func showScoreboardOnTouchUpInside(_ sender: Any) {
        let scoreboardViewController = ScoreboardViewController.instantiate() as! ScoreboardViewController
        
        navigationController?.pushViewController(scoreboardViewController, animated: true)
    }
    
    @IBAction func showCategoriesOnTouchUpInside(_ sender: Any) {
        let categoriesViewController = CategoriesViewController.instantiate() as! CategoriesViewController
        categoriesViewController.previousViewController = self.viewControllerName
        navigationController?.pushViewController(categoriesViewController, animated: true)
    }
    
    
    
//    MARK: - PROPERTIES AND METHODS
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var viewControllerName = "MainMenuViewController"
    var gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.connectionManager.setupSession()
        appDelegate.connectionManager.startSelfAdvertising(advertise: true, viewController: self)
    }
    
    func invitePlayers(action: UIAlertAction!) {
        appDelegate.connectionManager.setupNearbyServiceBrowser(browse: true, viewController: self)
    }
}

