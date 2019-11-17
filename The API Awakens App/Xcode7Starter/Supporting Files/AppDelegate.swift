//
//  AppDelegate.swift
//  Xcode7Starter
//
//  Created by Pasan Premaratne on 10/25/16.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    
    let mainMenuController = MainMenuController()
    let navigationController = UINavigationController(rootViewController: mainMenuController)
    navigationController.navigationBar.barTintColor = UIColor.Theme.dark
    
    
    window?.rootViewController = navigationController
    
    return true
  }

}

