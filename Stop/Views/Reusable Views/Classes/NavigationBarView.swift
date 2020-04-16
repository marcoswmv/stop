//
//  NavigationBarView.swift
//  Stop
//
//  Created by Marcos Vicente on 07.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit


class NavigationBarView: UIViewWithXib {
    
    @IBInspectable var navigationBarTitle: String?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var gameLetter: UILabel!
    @IBOutlet weak var backButton: IBDesignableButton!
    @IBOutlet weak var editButton: IBDesignableButton!
    
    @IBAction func goBackOnTouchUpInside(_ sender: Any) {
        self.getViewsTopViewController()?.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editOnTouchUpInside(_ sender: Any) {
        let categoriesViewController = self.getViewsTopViewController() as! CategoriesViewController
        
        if categoriesViewController.tableView.isEditing {
            if categoriesViewController.previousViewController == "GameSetupViewController" {
                categoriesViewController.doneButton.isHidden = !categoriesViewController.doneButton.isHidden ? true : false
            }
            categoriesViewController.tableView.setEditing(true, animated: true)
            categoriesViewController.deleteCategory.isHidden = true
            categoriesViewController.addCategory.isHidden = true
            categoriesViewController.tableView.isEditing = false
        } else {
            if categoriesViewController.previousViewController == "GameSetupViewController" {
                categoriesViewController.doneButton.isHidden = !categoriesViewController.doneButton.isHidden ? true : false
            }
            categoriesViewController.tableView.setEditing(false, animated: true)
            categoriesViewController.deleteCategory.isHidden = false
            categoriesViewController.addCategory.isHidden = false
            categoriesViewController.tableView.isEditing = true
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.title.text = navigationBarTitle
    }
    
}
