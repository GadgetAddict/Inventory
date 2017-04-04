//
//  Item.swift
//  Inventory17
//
//  Created by Michael King on 1/20/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import Foundation
import Firebase

class Item  {
    
//    enum itemImageType {
//        case custom
//        case icon
//        
//    }
    
    
     private var _itemKey: String!
    private var _itemImgUrl: String?
//    private var _imageType: itemImageType!
    private var _itemName:String!
    private var _itemNotes: String?
    private var _itemCategory: String?
    private var _itemSubcategory: String?
    private var _itemBoxNum: Int?
    private var _itemBoxKey: String?
    private var _itemIsBoxed: Bool!
    private var _itemQty: String?
    private var _itemFragile: Bool!
    private var _itemColor: String?
    private var _tags: [String]?
    private var _qrCode: [String]?

    
    
    var itemKey: String? {
        return _itemKey
    }
    var itemColor: String? {
        return _itemColor
    }
    
    var itemName: String {
        return _itemName
    }
    
//    var itemImageType: itemImageType {
//        return _imageType
//    }

    var itemImgUrl: String? {
        return _itemImgUrl
    }
    
    var itemNotes: String? {
        return _itemNotes
    }
    
    
    var itemCategory: String? {
        return _itemCategory
    }
    
    var itemSubcategory: String? {
        return _itemSubcategory
    }
    
    var itemIsBoxed: Bool! {
        return _itemIsBoxed
    }
    var itemBoxNum: Int? {
        return _itemBoxNum
    }
    
    var itemBoxKey: String? {
        return _itemBoxKey
    }
    
    
    var itemQty: String! {
        return _itemQty
    }
    
    var itemFragile: Bool {
        return _itemFragile
    }
    
    var tags: [String]? {
        return _tags
    }
    
    var qrCode: [String]? {
        return _qrCode
    }
 
//    init( name: String,  notes: String, category: String, subcategory: String, qty: Int, fragile: Bool,  itemBoxNum: Int, itemColor: String, key: String, tags: [String]) {
//        self._itemKey = key
//        self._itemName = name
//        
//        self._itemImgUrl = itemImgUrl
//        self._itemNotes = notes
//        self._itemCategory = category
//        self._itemSubcategory = subcategory
//        self._itemBoxNum = itemBoxNum
//        self._itemQty = qty
//        self._itemFragile = fragile
//        self._itemColor = itemColor
//        self._tags = tags
//    }
    
    init(itemKey: String, dictionary: Dictionary <String, AnyObject> ) {
        self._itemKey = itemKey
 
        
        if let itemImgUrl = dictionary["imageUrl"] as? String {
            self._itemImgUrl = itemImgUrl
        }
        if let itemName = dictionary["itemName"] as? String {
            self._itemName = itemName
        }
        
        if let notes = dictionary["itemDescript"] as? String {
            self._itemNotes = notes
        }
        if let category = dictionary["itemCategory"] as? String {
            self._itemCategory = category
        }
        if let subcategory = dictionary["itemSubcategory"] as? String {
            self._itemSubcategory = subcategory
        }
        if let itemIsBoxed = dictionary["itemIsBoxed"] as? Bool {
            self._itemIsBoxed = itemIsBoxed
        }
        if let itemBoxNum = dictionary["itemBoxNumber"] as? Int {
            self._itemBoxNum = itemBoxNum
        }
        if let itemBoxKey = dictionary["itemBoxKey"] as? String {
            self._itemBoxKey = itemBoxKey
        }
        if let qty = dictionary["itemQty"] as? String {
            self._itemQty = qty
        }
        if let fragile = dictionary["itemFragile"] as? Bool {
            self._itemFragile = fragile
        }
        if let color = dictionary["itemColor"] as? String {
            self._itemColor = color
        }
        if let tags = dictionary["tags"] as? [String] {
            self._tags = tags
        }
        if let qrCode = dictionary["qrCode"] as? [String] {
            self._qrCode = qrCode
        }
    }
    
    
    init(itemName: String, itemCat: String, itemSubcat: String, itemColor: String?) {
        
        self._itemName = itemName
        self._itemCategory = itemCat
        self._itemSubcategory = itemSubcat
        
        if let color = itemColor {
            self._itemColor = color
        }
    }
    
    
//    init(snapshot: FDataSnapshot) {
//        _itemKey = snapshot.key
//        _itemName = snapshot.value["itemName"] as! String
//        _itemCategory = snapshot.value["itemCategory//\u{2605}\n "] as? String
//        
//        _itemRef = snapshot.ref
//    }
}



