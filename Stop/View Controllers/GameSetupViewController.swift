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
        categoriesViewController.gameID = self.newGame?.id
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
    
    var newGame: Game?
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
    
//    MARK: - GAME ONLY ENABLES 2 PLAYERS TO PLAY AT THE MOMENT
    
    func startGameIfReady() {
//        gameManager.joinGame(gameToJoin: newGame!, player: newPlayer!)
        
        completionHandler = { [weak self] isReady, game in
        
            if self!.isReady {
//                print("In general the player is ready")
                
                if isReady {
//                    print("All players are ready - so start game")
                    
                    if let receivedGame = game, let currentPlayer = self?.newPlayer {
                        self?.newGame = self?.gameManager.updateGameWithDataFromHost(gameToUpdate: receivedGame, player: currentPlayer)
                        
                        guard let classGame = self?.newGame else { return }
                        let data = ["game": classGame, "isReady": true] as [String : Any]
                        self?.connectionManager.sendData(dataDictionary: data)
                        
                        let stopLoading = !isReady
                        self?.displayLoading(loading: stopLoading)

                        let gameViewController = GameViewController.instantiate() as! GameViewController
                        
                        gameViewController.game = classGame
                        gameViewController.player = self?.newPlayer
                        gameViewController.connectionManager = self?.connectionManager
                        self?.navigationController?.pushViewController(gameViewController, animated: true)
                    }
                } else {
//                    print("Other players are not ready but I am so display loading for me")
                    
                    let startLoading = !isReady
                    self?.displayLoading(with: "The other player is not ready\nbut it won't take too long to start the game.\nPlease, wait a little bit!", loading: startLoading)
                }
            } else {
//                print("I'm not ready, so display loading for other player")
                
                if let receivedGame = game {
                    self?.newGame = self?.gameManager.updateGameWithDataFromHost(gameToUpdate: receivedGame)
                    
                    guard let classGame = self?.newGame else { return }
                    let data = ["game": classGame, "isReady": false] as [String : Any]
                    self?.connectionManager.sendData(dataDictionary: data)
                }
            }
        }
    }
    
    func setupNewGame() {
        if let playerName = playerName.text {
            if playerName != "" {
                newPlayer = gameManager.updatePlayers(player: newPlayer!, name: playerName)
                if typeOfPlayer == .Host {
                    newGame = gameManager.setGameParameters(gameToSet: newGame!,
                                                            letter: selectedLetter ?? "",
                                                            letters: letters,
                                                            categories: selectedCategories,
                                                            typeOfPlayer: .Host,
                                                            player: newPlayer!)
                } else {
                    newGame = gameManager.setGameParameters(gameToSet: newGame!,
                                                            typeOfPlayer: .Invited,
                                                            player: newPlayer!)
                }
            }
        }
        
        guard let game = newGame else { return }
        let data = ["game": game, "isReady": true] as [String : Any]
        connectionManager.sendData(dataDictionary: data)
    }
    
    func setupUIAppearance() {
        navigationBar.backButton.isHidden = true
        navigationBar.editButton.isHidden = true
        hideKeyboardWhenTappedAround()
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
