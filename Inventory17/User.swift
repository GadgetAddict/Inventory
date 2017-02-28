//
//  User.swift
//  ClientColorKeeper
//
//  Created by Michael King on 11/15/16.
//  Copyright © 2016 Microideas. All rights reserved.
//

import Foundation
import Firebase

class User {
 
    
    private var _uid: String!
    private var _email: String!
    private var _firstName: String!
    private var _lastName: String!
    private var _collectionRef: FIRDatabaseReference!
    
    
    var uid: String {
        return _uid
    }
    var email: String {
        return _email
    }
    var firstName: String {
        return _firstName
    }
    var lastName: String {
        return _lastName
    }
    var collectionRef: FIRDatabaseReference {
        return _collectionRef
    }
    
    
    
        init(authData: FIRUser, name:String) {
            _uid = authData.uid
            _email = authData.email!
            _firstName = name
        }
    
        init(uid: String, email: String, name: String) {
            _uid = uid
            _email = email
            _firstName = name
        }
    
    
    
    
    
}
