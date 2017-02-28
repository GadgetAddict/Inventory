//
//  ColorCell.swift
//  Inventory17
//
//  Created by Michael King on 2/12/17.
//  Copyright © 2017 Microideas. All rights reserved.
//


import UIKit
import Firebase


class ColorCell: UITableViewCell, UINavigationControllerDelegate {
    
    
    
    var color: Color!
    
    @IBOutlet weak var colorLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }//awakeFromNib
    
    
    func configureCell(color: Color) {
        self.color = color
        
        self.colorLabel.text = color.colorName?.capitalized
        
        
    }//ConfigureCell

}

    
