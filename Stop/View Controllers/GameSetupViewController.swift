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
        setupNewGame()
    }
    
    
    
    
//    MARK: - PROPERTIES AND METHODS
    
    var connectionManager: ConnectionManager!
    var session: MCSession!
    
    var isLoading = false
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIAppearance()
        createLetterPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if typeOfPlayer == TypeOfPlayer.Host {
            chooseLetterCell.isHidden = false
            chooseCategoriesButton.isHidden = false
        } else {
            chooseLetterCell.isHidden = true
            chooseCategoriesButton.isHidden = true
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
        
//        Alert.shared.showBasicAlert(on: self, with: "DATA", message: gameManager.getGame(with: gameID).description)
    }
    
    func checkTypeOfPlayer(type: TypeOfPlayer, gameID: String, player: Player) {
        if typeOfPlayer == .Host {
            gameManager.setGameParameters(gameID: gameID,
                                          start: true,
                                          letter: selectedLetter ?? "",
                                          letters: letters,
                                          categories: selectedCategories,
                                          player: player)
            
            let game = gameManager.getGame(with: gameID)
            let data = ["game": game]     // NOTE: To stop the game im going to send a data object ["flag": true]
            
            connectionManager.sendData(dataDictionary: data)
            
//            let gameViewController = GameViewController.instantiate() as! GameViewController
//            navigationController?.pushViewController(gameViewController, animated: true)
        } else {
            // Invited player joining the game
            gameManager.joinGame(gameID: gameID, player: player)
            
            isLoading = true
            
            if isLoading {
                displayLoading(with: "The Host player is setting the game. It won't take to long", loading: isLoading)
            } else {
                displayLoading(with: "The Host player is setting the game. It won't take to long", loading: isLoading)
                
                
//                let gameViewController = GameViewController.instantiate() as! GameViewController
//                navigationController?.pushViewController(gameViewController, animated: true)
            }
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
