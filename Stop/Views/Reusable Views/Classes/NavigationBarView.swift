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
    @IBOutlet weak var backButton: IBDesignableButton!
    @IBOutlet weak var doneButton: IBDesignableButton!
    
    @IBAction func goBackOnTouchUpInside(_ sender: Any) {
        self.getViewsTopViewController()?.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneOnTouchUpInside(_ sender: Any) {
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.title.text = navigationBarTitle
    }
    
}
