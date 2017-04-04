//
//  LocationPickerCell.swift
//  Inventory17
//
//  Created by Michael King on 2/14/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import Firebase
import UIKit

class LocationPickerCell: UITableViewCell, UINavigationControllerDelegate {
    
    var location: Location!
    
        @IBOutlet weak var locationLabel: UILabel!
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
            
        }//awakeFromNib
        
        
    func configureCell(location: Location, locationType:LocationType) {
        
        switch locationType {
        case .area :
            print("configureCell AREA ")
            self.locationLabel.text = location.locationArea

        case .name:
            print("configureCell NAME")
            self.locationLabel.text = location.locationName
        case .detail:
            print("configureCell DETAIL")
            self.locationLabel.text = location.locationDetail
            
        }
        
        
            
        }//ConfigureCell

}


    
