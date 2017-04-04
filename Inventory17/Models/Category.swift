//
//  Category.swift
//  Inventory17
//
//  Created by Michael King on 2/15/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import Foundation




struct Category {
    var categoryKey: String!
    var category: String!
    var subcategory: String?
    
    init(category: String!, subcategory: String?) {
        self.category = category
        self.subcategory = subcategory
     }
    
    
    init (categoryKey: String, dictionary: Dictionary <String, AnyObject> ) {
        self.categoryKey = categoryKey
        
        if let category = dictionary["category"] as? String {
            self.category = category
        }
        
        if let subcategory = dictionary["subcategory"] as? String {
            self.subcategory = subcategory
        }
     
    }
    
     
   
}
