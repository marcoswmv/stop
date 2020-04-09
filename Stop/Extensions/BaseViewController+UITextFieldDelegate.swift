//
//  BaseViewController+UITextFieldDelegate.swift
//  Stop
//
//  Created by Marcos Vicente on 08.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

extension BaseViewController: UITextFieldDelegate {
    
    func textControlShouldBeginEditing(textControl: UITextField) -> Bool {
        
        self.currentTextField = textControl
        
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignKeyboard))
        doneBarButton.tintColor = UIColor(named: "Red App")
            
        let keyboardToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40.0))
        keyboardToolBar.barStyle = .default
            
        var barItems : [UIBarButtonItem] = []

        barItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        barItems.append(doneBarButton)
        keyboardToolBar.setItems(barItems, animated: false)
        self.currentTextField?.inputAccessoryView = keyboardToolBar

        return true;
    }

    @objc func resignKeyboard() {
        
        if(self.currentTextField != nil){
            self.currentTextField?.resignFirstResponder()
            self.currentTextField = nil;
        }
    }
}
