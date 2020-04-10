//
//  GameSetupViewController.swift
//  Stop
//
//  Created by Marcos Vicente on 07.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

class GameSetupViewController: BaseViewController {

//    MARK: - OUTLETS
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var chooseLetter: UITextField!
    @IBOutlet weak var navigationBar: NavigationBarView!
    
    @IBAction func chooseCategoriesOnTouchUpInside(_ sender: Any) {
        let categoriesViewController = CategoriesViewController.instantiate() as!  CategoriesViewController
        
        navigationController?.pushViewController(categoriesViewController, animated: true)
    }
    
    @IBAction func startGameOnTouchUpInside(_ sender: Any) {
//        TODO: Start game
    }
    
    
    
    
//    MARK: - PROPERTIES AND METHODS
    
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var selectedLetter: String?
    
    
    deinit {
        print("\(self) is being deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.backButton.isHidden = true
        navigationBar.editButton.isHidden = true
        hideKeyboardWhenTappedAround()
        createLetterPicker()
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
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
