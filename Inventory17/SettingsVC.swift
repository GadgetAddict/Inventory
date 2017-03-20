//
//  mainMenuVC.swift
//  Inventory
//
//  Created by Michael King on 4/15/16.
//  Copyright © 2016 Michael King. All rights reserved.
//


import UIKit
import Firebase

class SettingsVC: UITableViewController {

        override func viewDidLoad() {
        super.viewDidLoad()
                    

     }//end ViewDidLoad
    
//    Add this to make the table cell separator fill entire width of table
      func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }

    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
}
    

    @IBAction func unwindCancelToSettings(_ segue:UIStoryboardSegue) {
    }
    
    
    @IBAction func unwindLocationsToSettings(_ segue:UIStoryboardSegue) {
    
    
    }
    
    
    @IBAction func signOut_Tapped(_ sender: UIBarButtonItem) {
        
            print("LOGOUT Gesture Tapped")
        let defaults = UserDefaults.standard
        
        
        if (defaults.object(forKey: "CollectionIdRef") != nil) {
            if let collectionId = defaults.string(forKey: "CollectionIdRef") {
                 print("Collection ID is \(collectionId)")
            } else {
            print("Collection ID is nil")
            }
            
        }
        
        
        if (defaults.object(forKey: "CollectionName") != nil) {
            if let CollectionName = defaults.string(forKey: "CollectionName") {
                print("CollectionName ID is \(CollectionName)")
            } else {
                print("CollectionName ID is nil")
            }
            
        }

        

            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
                defaults.set(nil, forKey: "CollectionIdRef")
                defaults.set(nil, forKey: "CollectionName")
           
                self.performSegue(withIdentifier: "unwindToLogout", sender: self)

//                self.dismiss(animated: true, completion: nil)
                
            } catch let signOutError as NSError {
                print ("Error signing out: \(signOutError.localizedDescription)")
            }
            
        
    if (defaults.object(forKey: "CollectionIdRef") != nil) {
    if let collectionId = defaults.string(forKey: "CollectionIdRef") {
    print("Collection ID is \(collectionId)")
    }
    }

    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue FROM SETTINGS")
        
        if let colorsVC = segue.destination as? ColorTableVC {
            colorsVC.colorLoadsFrom = .settings
        } else {
        
            if segue.identifier == "locationSettings" {
                print("Going to locationSettings ")
                
                if let locationsVC = segue.destination as? LocationDetailsVC {
                        locationsVC.locationSelection = .settings
                 }
            } else {
        
         if segue.identifier == "categorySettings" {
            print("segue.identifier to cats from settings")
        if let categoryDetails = segue.destination as? CategoryDetailsVC {
                print("going to cats from settings")

                    categoryDetails.categorySelectionOption = .settings
            }
                }
        }
        }
    }
    
    
//     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        
//        if let locationsVC = segue.destination as? LocationsVC {
//            print("destination as? LocationPickerVC")
//            
//            if segue.identifier == "locationSettings" {
//                locationsVC.fromSettings = true
//                
//                }
//            }
//        }
}

