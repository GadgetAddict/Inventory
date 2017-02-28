//
//  CategoriesCell.swift
//  Inventory17
//
//  Created by Michael King on 2/16/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit

class CategoriesCell: UITableViewCell {
    
    
    @IBOutlet weak var categoryLabel: UILabel!
 
    
    
    var category: Category! {
        didSet {
            categoryLabel.text = category.category
           
        }
    }
}
    
