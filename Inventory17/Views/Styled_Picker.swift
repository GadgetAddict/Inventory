//
//  Styled_Picker.swift
//  Inventory17
//
//  Created by Michael King on 1/26/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit

class StyledPicker: UIPickerView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
}
