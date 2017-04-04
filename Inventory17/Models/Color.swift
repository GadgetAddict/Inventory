//
//  Color.swift
//  Inventory17
//
//  Created by Michael King on 2/12/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import Foundation

class Color {

var _colorName: String!
var _colorKey: String?


var colorName: String? {
    return _colorName
}

var colorKey: String? {
    return _colorKey
}


init(colorKey: String?, colorName: String?) {
    self._colorName = colorName
    self._colorKey = colorKey
}

init (dictionary: Dictionary <String, AnyObject> ) {
    if let colorName = dictionary["colorName"] as? String {
        self._colorName = colorName
    }
    
}


init (colorKey: String, dictionary: Dictionary <String, AnyObject> ) {
    self._colorKey = colorKey
    
    if let colorName = dictionary["colorName"] as? String {
        self._colorName = colorName
        }
    
    }
}
    
