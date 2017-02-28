//
//  LocationsCell.swift
//  Inventory17
//
//  Created by Michael King on 2/13/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit

class LocationsCell: UITableViewCell {

    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAreaLabel: UILabel!
    @IBOutlet weak var locationDetailLabel: UILabel!

    
    var location: Location! {
        didSet {
            locationNameLabel.text = location.locationName
            locationAreaLabel.text = location.locationDetail
            locationDetailLabel.text = location.locationArea
        }
    }
    
  
    
    
}
