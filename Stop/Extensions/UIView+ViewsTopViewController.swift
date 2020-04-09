//
//  UIView+ViewsTopViewController.swift
//  Stop
//
//  Created by Marcos Vicente on 09.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

extension UIView {
    
    func getViewsTopViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.getViewsTopViewController()
        } else {
            return nil
        }
    }
    
}
