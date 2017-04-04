//
//  BoxNumberLabel.swift
//  Inventory17
//
//  Created by Michael King on 3/23/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit

class BoxNumberLabel: UILabel {

    
    // Used in boxFeed to write   number of items in box
    override func awakeFromNib() {
//        override func draw(_ rect: CGRect) {

     layer.cornerRadius = 25
    layer.borderWidth = 3.0
   layer.backgroundColor = UIColor.clear.cgColor
    layer.borderColor = UIColor.brown.cgColor
 
    
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
