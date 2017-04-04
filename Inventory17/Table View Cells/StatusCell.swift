//
//  StatusCell.swift
//  Inventory17
//
//  Created by Michael King on 2/12/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit
import Firebase

class StatusCell: UITableViewCell, UINavigationControllerDelegate {
    
    
    
    var status: Status!
    
    @IBOutlet weak var statusLabel: UILabel!
 
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }//awakeFromNib

    
    func configureCell(status: Status) {
        self.status = status
        
            self.statusLabel.text = status.statusName?.capitalized
       
        
    }//ConfigureCell
    
    
    
    
    
}


