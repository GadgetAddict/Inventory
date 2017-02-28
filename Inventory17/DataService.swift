//
//  DataService.swift
//  Inventory
//
//  Created by Michael King on 1/1/17.
//  Copyright © 2017 Michael King. All rights reserved.
//


import Foundation
import Firebase
import FirebaseStorage

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    // DB references
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    // Storage references
   private var _REF_ITEM_IMAGES = STORAGE_BASE.child("itemImages")

    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
 
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
     var REF_USER_CURRENT: FIRDatabaseReference {
            let userID = FIRAuth.auth()?.currentUser?.uid
            let userRef = REF_USERS.child(userID!).child("collectionAccess/collectionId")
        
        return userRef
        }
    

   
    
    var REF_ITEM_IMAGES: FIRStorageReference {
        return _REF_ITEM_IMAGES
    }
 
    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    func getInventoryReference()  {
        print("getInventoryReference")

        DataService.ds.REF_USER_CURRENT.observe(.value, with: {(snapshot)  in
            print("DataService.GetCollectionRef Snapshot is \(snapshot)")
            if let collectionRefString = snapshot.value as? String {
                print("Collection ID is \(collectionRefString)")
                
                        let defaults = UserDefaults.standard
                        defaults.set(collectionRefString, forKey: "CollectionIdRef")

                
                
                         let REF_COLLECTION_NAME = DataService.ds.REF_BASE.child("/collections/\(collectionRefString)/inventoryName")

                        REF_COLLECTION_NAME.observe(.value, with: {(snapshot)  in
                            if let name = snapshot.value  as? String {
//                                print("Collection Name is \(name)")

                                defaults.set(name, forKey: "CollectionName")
                                
                            }
                        })
            }
        })
          
    }
    
//    func completeSignIn(id: String, userData: Dictionary<String, String>) {
//        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
//        //let keychainResult = KeychainWrapper.setString(id, forKey: KEY_UID)
//        let keychainResult = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
//        print("MICHAEL: Data saved to keychain \(keychainResult)")
//    }

    
}
