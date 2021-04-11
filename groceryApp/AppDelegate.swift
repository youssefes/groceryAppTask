//
//  AppDelegate.swift
//  groceryApp
//
//  Created by youssef on 4/11/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?
    var Coordinator : AppCoordinator!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        Coordinator = AppCoordinator(Window: window!)

        IQKeyboardManager.shared.enable = true
        Coordinator.start()
        
        
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.05824901909, green: 0.3847238421, blue: 0.412258476, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
         UINavigationBar.appearance().isTranslucent = false
        return true
    }



}

