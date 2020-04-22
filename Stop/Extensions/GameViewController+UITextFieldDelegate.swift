//
//  GameViewController+UITextFieldDelegate.swift
//  Stop
//
//  Created by Marcos Vicente on 19.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

extension GameViewController {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let indexPaths = tableView.indexPathsForVisibleRows!
        var categoryIndexPath = IndexPath()
        
        for indexPath in indexPaths {
            if textField.tag == indexPath.row {
                categoryIndexPath = indexPath
            }
        }
        
        let cell = tableView.cellForRow(at: categoryIndexPath) as! GameCategoryTableViewCell
        categoryName = cell.category.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let answer = textField.text!
        let answerFirstLetter = answer.first?.lowercased()
        let letter = game?.letter?.first?.lowercased()
        
        if answerFirstLetter == letter {
            guard let categoryName = categoryName else { return }
            let categoryID = gameManager.getCategoryID(name: categoryName)
            
            gameManager.saveAnswer(categoryID: categoryID, word: answer, player: player!)
            gameManager.retrievePlayerAnswers(player: player!)
        }
    }
    
}
