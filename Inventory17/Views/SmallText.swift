//
//  SmallText.swift
//  Inventory17
//
//  Created by Michael King on 3/24/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit



    class SettingsTextStyle: UILabel {
        
        override func awakeFromNib() {

        textColor = UIColor.darkGray
        font = UIFont(name: "PingFang SC Light", size: 24)
        
        
        }

        
    }



//class SmallText: UILabel {
//
//    override func awakeFromNib() {
//
////        let size:CGFloat = 35.0 // 35.0 chosen arbitrarily
//        let countLabel = UILabel()
//        countLabel.text = "Items"
//
//        countLabel.textAlignment = .center
//        countLabel.font = UIFont.systemFont(ofSize: 10.0)
//         countLabel.layer.backgroundColor = UIColor.clear.cgColor
//        countLabel.layer.borderColor = UIColor.green.cgColor
//
////        countLabel.center = CGPointMake(200.0, 200.0)
//
//    }
//



//        let size:CGFloat = 35.0 // 35.0 chosen arbitrarily
//        
//        let countLabel = UILabel()
//        countLabel.text = "5"
//        countLabel.textColor = .greenColor()
//        countLabel.textAlignment = .Center
//        countLabel.font = UIFont.systemFontOfSize(14.0)
//        countLabel.bounds = CGRectMake(0.0, 0.0, size, size)
//        countLabel.layer.cornerRadius = size / 2
//        countLabel.layer.borderWidth = 3.0
//        countLabel.layer.backgroundColor = UIColor.clearColor().CGColor
//        countLabel.layer.borderColor = UIColor.greenColor().CGColor
//        
//        countLabel.center = CGPointMake(200.0, 200.0)
//        
//        self.view.addSubview(countLabel)

