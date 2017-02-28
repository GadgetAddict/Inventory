//
//  DashboardVC.swift
//  Inventory17
//
//  Created by Michael King on 1/20/17.
//  Copyright © 2017 Microideas. All rights reserved.
//


import UIKit
import Firebase

class DashViewController: UIViewController {
    
     let defaults = UserDefaults.standard
    
     @IBOutlet weak var collectionNickName_label: UILabel!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let name = self.defaults.string(forKey: "CollectionName") {
//            self.collectionNickName_label.text = name
//        } else {
//            print("WHERE IS THE NAME")
//        }
        
    }
    
    @IBAction func newItem_Button_tapped(_ sender: UIButton) {
    newItem()
    }
    
    @IBAction func newItem_Gesture_tapped(_ sender: UIGestureRecognizer) {
     newItem()
    }
    
    func newItem() {
           print("New Item Gesture Tapped")
    }
    
    
    
    @IBAction func newBox_Button_tapped(_ sender: UIButton) {
    newBox()
    }
    
    @IBAction func newBox_Gesture_tapped(_ sender: UIGestureRecognizer) {
     newBox()
    }
    
    func newBox() {
        print("New Box Gesture Tapped")
    }
    
    
    
    
    @IBAction func settings_Button_tapped(_ sender: UIButton) {
    settings()
    }
    
    @IBAction func settings_Gesture_tapped(_ sender: UIGestureRecognizer) {
     settings()
    }
    
    func settings() {
        print("Settings Gesture Tapped")
        self.performSegue(withIdentifier: "SETTINGS_SEGUE", sender: nil)

    }
    
    
    
    @IBAction func signOut_Button_tapped(_ sender: UIButton) {
        signout()
    }
 
    @IBAction func signOut_gesture_tapped(_ sender: UIGestureRecognizer) {
        signout()
    }
    
    func signout() {
        print("LOGOUT Gesture Tapped")

    let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            self.defaults.set(nil, forKey: "CollectionIdRef")
            self.defaults.set(nil, forKey: "CollectionName")

            self.dismiss(animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }

    }
    
    
//    @IBAction func items_segue_tab(_ sender: Any) {
//        tabBarController!.selectedIndex = 1
//}
//    
// 
//    @IBAction func boxes_segue_tab(_ sender: Any) {
//        tabBarController!.selectedIndex = 2
//    }
//
//    @IBAction func itemsTapped(_ sender: Any) {
//      print("gesture recognizer")
//        tabBarController!.selectedIndex = 1
//    }
    
    @IBAction func unwindFromClientList(sender: UIStoryboardSegue){
        self.tabBarController?.tabBar.isHidden = true

    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
