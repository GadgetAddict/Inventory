//
//  Status.swift
//  Inventory
//
//  Created by Michael King on 7/24/16.
//  Copyright © 2016 Michael King. All rights reserved.
//

import Foundation


class Status {
    
    var _statusName: String!
    var _statusKey: String?
    
    
    var statusName: String? {
        return _statusName
}

    var statusKey: String? {
        return _statusKey
    }
    
    
    init(statusKey: String?, statusName: String?) {
        self._statusName = statusName
        self._statusKey = statusKey
    }
    
    init (dictionary: Dictionary <String, AnyObject> ) { 
        if let statusName = dictionary["statusName"] as? String {
            self._statusName = statusName
        }
        
    }
    
    
    init (statusKey: String, dictionary: Dictionary <String, AnyObject> ) {
        self._statusKey = statusKey
        
        if let statusName = dictionary["statusName"] as? String {
            self._statusName = statusName
        }
        
    }
    
    
}