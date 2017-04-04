//
//  ItemRoundButton.swift
//  Inventory17
//
//  Created by Michael King on 3/27/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit

class ItemRoundButton: UIButton {
    
    override func awakeFromNib() {
     
    imageView?.contentMode = .scaleAspectFit
    layer.borderWidth = 1.4
    layer.borderColor = UIColor.white.cgColor
    layer.cornerRadius = layer.frame.height / 2.0
    layer.backgroundColor = UIColor(red: 64/255, green: 143/255, blue: 223/255, alpha: 1).cgColor
    //        qrButton.layer.cornerRadius = 21
    layer.masksToBounds = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
