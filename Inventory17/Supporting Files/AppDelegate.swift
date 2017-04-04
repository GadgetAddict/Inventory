//
//  AppDelegate.swift
//  Inventory17
//
//  Created by Michael King on 1/15/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
      
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        FIRApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        FIRDatabase.database().persistenceEnabled = true

         
        UISearchBar.appearance().barTintColor = UIColor.candyBlue()
        UISearchBar.appearance().tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.candyBlue()
        return true
    }
    
  
    
}


extension UIColor {
    static func candyBlue() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
}
