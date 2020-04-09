//
//  AppDelegate.swift
//  Stop
//
//  Created by Marcos Vicente on 05.04.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window?.overrideUserInterfaceStyle = .light
        
        return true
    }

}

