//
//  Location.swift
//  Inventory17
//
//  Created by Michael King on 2/13/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit

struct Location {
    var locationKey: String!
    var locationName: String!
    var locationDetail: String?
    var locationArea: String?
    
    init(name: String!, detail: String?, area: String?) {
        self.locationName = name
        self.locationDetail = detail
        self.locationArea = area
    }
    
    
    init (locationKey: String, dictionary: Dictionary <String, AnyObject> ) {
        self.locationKey = locationKey
        
        if let locationName = dictionary["name"] as? String {
            self.locationName = locationName
        }
        
        if let locationDetail = dictionary["detail"] as? String {
            self.locationDetail = locationDetail
        }
        
        if let locationArea = dictionary["area"] as? String {
            self.locationArea = locationArea
        }
        
    }
  
}
 
