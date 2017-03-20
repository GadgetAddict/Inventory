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
        
        
 
        return true
        
    }
    
  
    
}   
