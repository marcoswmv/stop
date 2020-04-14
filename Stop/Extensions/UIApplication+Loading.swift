//
//  UIApplication+Loading.swift
//  Stop
//
//  Created by Marcos Vicente on 11.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIApplication {
    
    /// Display fullscreen loading indicator
    class func displayLoading(with message: String, loading: Bool, color: UIColor = .white) {
    
        if loading {
            let config = ActivityData(size: CGSize(width: 150, height: 150), message: message, type: .ballScale, color: color, backgroundColor: UIColor(named: "Loading Red")!)
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(config)
        }else {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
}
