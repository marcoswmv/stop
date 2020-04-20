//
//  Alert.swift
//  Stop
//
//  Created by Marcos Vicente on 10.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import RealmSwift
import MultipeerConnectivity

class Alert {
    
    static let shared = Alert()
    
    func showBasicAlert(on viewController: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Alert button - OK"),
                                      style: .default,
                                      handler: nil))
        DispatchQueue.main.async { viewController.present(alert, animated: true, completion: nil) }
    }
    
    func showSendError(on viewController: UIViewController, message: String) {
        showBasicAlert(on: viewController,
                       with: NSLocalizedString("Send Error", comment: "Send Error Title"),
                       message: message)
    }
    
    func showReceptionError(on viewController: UIViewController, message: String) {
        showBasicAlert(on: viewController,
                       with: NSLocalizedString("Reception Error", comment: "Reception Error Title"),
                       message: message)
    }
    
    func showInvitationAlert(on viewController: UIViewController, with title: String, message: String?) {
        let mainMenuViewController = viewController as! MainMenuViewController
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let sendInvitationAction = UIAlertAction(title: NSLocalizedString("Send Invitation", comment: "Connection Alert button - Send Invitation"),   style: .default, handler: mainMenuViewController.invitePlayers(action:))
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Invite players Alert button - Cancel"), style: .cancel)
        
        alertController.addAction(sendInvitationAction)
        alertController.addAction(cancel)
        
        DispatchQueue.main.async { viewController.present(alertController, animated: true, completion: nil) }
    }
    
    func showNewCategoryAlert(on viewController: UIViewController, with title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: NSLocalizedString("Done", comment: "Alert button - Done"), style: .default, handler: { action in
            
            let categoriesViewController = viewController as! CategoriesViewController
            
            let categoryName = alertController.textFields?.first?.text?.capitalizingFirstLetter()
            let newCategory = Category(id: UUID().uuidString, name: categoryName!)
            let databaseManager = DataBaseManager()
            
            databaseManager.createCategory(newCategory: newCategory)
            
            categoriesViewController.dataSource?.reload()
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Alert button - Cancel"), style: .cancel, handler: nil)
        
        alertController.addTextField { (textField) in
            textField.autocapitalizationType = .sentences
            textField.borderStyle = .none
            textField.placeholder = NSLocalizedString("Enter a name for the category", comment: "Alert Textfield Placeholder - Enter a name for the category")
            textField.font = UIFont(name: "AvenirNext-Regular", size: 15)
            textField.textColor = UIColor(named: "Red App")
        }
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async { viewController.present(alertController, animated: true, completion: nil) }
    }
    
}
