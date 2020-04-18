//
//  GameSetupViewController.swift
//  Stop
//
//  Created by Marcos Vicente on 07.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift
import MultipeerConnectivity

class GameSetupViewController: BaseViewController {

//    MARK: - OUTLETS
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var chooseLetter: UITextField!
    @IBOutlet weak var chooseLetterCell: IBDesignableView!
    @IBOutlet weak var chooseCategoriesButton: IBDesignableButton!
    @IBOutlet weak var navigationBar: NavigationBarView!
    
    @IBAction func chooseCategoriesOnTouchUpInside(_ sender: Any) {
        let categoriesViewController = CategoriesViewController.instantiate() as! CategoriesViewController
        
        categoriesViewController.completionHandler = { categories in
            self.selectedCategories = categories
        }
        categoriesViewController.gameID = self.newGameID
        categoriesViewController.previousViewController = self.viewControllerName
        navigationController?.pushViewController(categoriesViewController, animated: true)
    }
    
    @IBAction func startGameOnTouchUpInside(_ sender: Any) {
        isReady = true
        setupNewGame()
    }
    
    
//    MARK: - PROPERTIES
    
    var connectionManager: ConnectionManager!
    
    var viewControllerName = "GameSetupViewController"
    
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I",
                   "J", "K", "L", "M", "N", "O", "P", "Q", "R",
                   "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var selectedLetter: String?
    var selectedCategories = List<Category>()
    
    var gameManager = GameManager()
    var typeOfPlayer: TypeOfPlayer?
    
    var newGameID: String?
    var newPlayer: Player?
    
    var completionHandler: ((Bool, Game?) -> Void)?
    
    var isReady = false
    
    
//    MARK: - METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIAppearance()
        createLetterPicker()
        startGameIfReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if typeOfPlayer == .Host {
            chooseLetterCell.isHidden = false
            chooseCategoriesButton.isHidden = false
        } else {
            chooseLetterCell.isHidden = true
            chooseCategoriesButton.isHidden = true
        }
    }
    
    
    func startGameIfReady() {            
        completionHandler = { [weak self] isReady, game in
        
            
            if self!.isReady {
                print("In general the player is ready")
                
                if isReady {
                    print("All players are ready - so start game")
                    
                    var gameToPass = game
                    
//                    if self?.typeOfPlayer == .Invited {
//                        print("I am an invited player, so i'll wait")
//                        if let receivedGame = game, let invitedPlayer = self?.newPlayer {
//                            receivedGame.players.append(invitedPlayer)
//                            self?.gameManager.updateGameWithDataFromHost(updatedGame: receivedGame)
//
//                            gameToPass = self?.gameManager.getGame(with: receivedGame.id!)
//                        }
//                    } else {
//                        print("I am the host, so wait for me")
//                        
//
//                    }
                    
                    let data = ["game": game!, "isReady": true] as [String : Any]
                    self?.connectionManager.sendData(dataDictionary: data)
                    
                    let stopLoading = !isReady
                    self?.displayLoading(loading: stopLoading)

                    let gameViewController = GameViewController.instantiate() as! GameViewController
                    gameViewController.game = gameToPass
                    self?.navigationController?.pushViewController(gameViewController, animated: true)

                } else {
                    print("Other players are not ready but I am so display loading for me")
                    let startLoading = !isReady
                    self?.displayLoading(with: "Some player(s) is(are) not ready\nbut it won't take too long to start the game.\nPlease, wait a little bit!", loading: startLoading)
                }
            } else {
                print("Other player is not ready, so display loading for him")
                let data = ["game": game!, "isReady": false] as [String : Any]
                self?.connectionManager.sendData(dataDictionary: data)
            }
        }
    }
    
    
    func setupUIAppearance() {
        navigationBar.backButton.isHidden = true
        navigationBar.editButton.isHidden = true
        hideKeyboardWhenTappedAround()
    }
    
    func setupNewGame() {
        let deviceName = connectionManager.peerID.displayName
        
        if let playerName = playerName.text {
            if playerName != "" {
                newPlayer = gameManager.createNewPlayer(name: playerName, deviceName: deviceName)
            } else {
                newPlayer = gameManager.createNewPlayer(name: deviceName, deviceName: deviceName)
            }
        }
        
        guard let gameID = newGameID else { return }
        guard let newPlayer = newPlayer else { return }
        
        checkTypeOfPlayer(type: typeOfPlayer!, gameID: gameID, player: newPlayer)
    }
    
    func checkTypeOfPlayer(type: TypeOfPlayer, gameID: String, player: Player) {
        if typeOfPlayer == .Host {
            gameManager.setGameParameters(gameID: gameID,
                                          letter: selectedLetter ?? "",
                                          letters: letters,
                                          categories: selectedCategories,
                                          player: player)
            
            let game = gameManager.getGame(with: gameID)
            let data = ["game": game, "isReady": true] as [String : Any]
            
            connectionManager.sendData(dataDictionary: data)
            
        } else {
            
//            var data = [String : Any]()
            
//            if let receivedGame = connectionManager.receivedGame {
//                receivedGame.players.append(player)
//                gameManager.updateGameWithDataFromHost(updatedGame: receivedGame)
//
//                let game = gameManager.getGame(with: receivedGame.id!)
//
//                data = ["game": game, "isReady": true] as [String : Any]
//            } else {
            gameManager.joinGame(gameID: gameID, player: player)
            let game = gameManager.getGame(with: gameID)
                
            let data = ["game": game, "isReady": true] as [String : Any]
//            }
            connectionManager.sendData(dataDictionary: data)
        }
    }
    
    func createLetterPicker(){
        
        let letterPicker = UIPickerView()
        letterPicker.delegate = self
        letterPicker.backgroundColor = .white
        
        chooseLetter.inputView = letterPicker
        chooseLetter.inputAccessoryView = createPickerToolbar()
    }
    
    func createPickerToolbar() -> UIToolbar {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        toolbar.barTintColor = .white
        toolbar.tintColor = UIColor(named: "Red App")
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Letter Picker Toolbar button - Done"), style: .plain, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
