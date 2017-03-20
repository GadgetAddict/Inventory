//
//  Box.swift
//  Inventory
//
//  Created by Michael King on 4/1/16.
//  Copyright © 2016 Michael King. All rights reserved.
//

import Foundation
import Firebase

class Box  {
    private var _boxKey: String!
    private var _boxNumber: Int!
    private var _boxQRnumber: String?
    private var _boxFragile: Bool!
    private var _boxStackable: Bool!
    private var _boxCategory: String!
    private var _boxName: String?
    private var _boxLocationName: String?
    private var _boxLocationDetail: String?
    private var _boxLocationArea: String?
    private var _boxStatus: String?
    private var _boxColor: String?
   
    var boxItemCount: Int?


    
    
    
    var boxKey: String! {
        return _boxKey
    }
    
    var boxQRnumber: String? {
        return _boxQRnumber
    }
    var boxNumber:Int! {
        return _boxNumber
    }
    
    var boxFragile:Bool {
        return _boxFragile
    }
    
    var boxStackable:Bool {
        return _boxStackable
    }
    
    var boxCategory:String? {
        return _boxCategory
    }

    var boxName:String? {
        return _boxName
    }
    
    var boxLocationName:String? {
        return _boxLocationName
    }
    
    var boxLocationDetail:String? {
        return _boxLocationDetail
    }
    
    var boxLocationArea:String? {
        return _boxLocationArea
    }
    
    var boxStatus:String? {
        return _boxStatus
    }
    
    var boxColor:String? {
        return _boxColor
    }
//    var boxItemCount:Int? {
//        return _boxItemCount
//    }
    
    
    init(location: String!, area: String?, detail: String?) {
   
        self._boxLocationName = location
        
        if let locArea = area {
            self._boxLocationArea = locArea
        }
        if let locDetail = detail {
            self._boxLocationDetail = locDetail
        }
        
    }
 
    
    
    
    init(number: String, fragile: Bool, stackable: Bool,  category: String,  description: String, located : String, locDetail: String, locArea : String) {
        self._boxNumber = boxNumber
        self._boxFragile = fragile
        self._boxStackable = stackable
        self._boxCategory = category
        self._boxName = description
        self._boxLocationName = located
        self._boxLocationDetail = locDetail
        self._boxLocationArea = locArea
    }
    
    init (boxKey: String, dictionary: Dictionary <String, AnyObject>) {
        self._boxKey = boxKey
        
        if let fragile = dictionary["fragile"] as? Bool {
            self._boxFragile = fragile
        }
        
        if let stackable = dictionary["stackable"] as? Bool {
            self._boxStackable = stackable
        }
        
        if let category = dictionary["boxCategory"] as? String {
            self._boxCategory  =  category
        }
        
        if let name = dictionary["name"] as? String {
            self._boxName  =  name
        }
        
        if let boxNumber = dictionary["boxNum"] as? Int {
             self._boxNumber = boxNumber
        }
        
        if let boxQR = dictionary["boxQR"] as? String {
            self._boxQRnumber = boxQR
        }
        
        if let located = dictionary["location"] as? String {
            self._boxLocationName = located
        }
        
        if let locDetail = dictionary["location_detail"] as? String {
              self._boxLocationDetail = locDetail
        }
        
        if let locArea = dictionary["location_area"] as? String {
              self._boxLocationArea = locArea
        }
        
        if let status = dictionary["status"] as? String {
            self._boxStatus = status
        }
        
        if let color = dictionary["color"] as? String {
            self._boxColor = color
        }
        
       
        
     }
 

     
//    func getBoxNumber (newBoxCategory:Category ) {
//        let refBox  = PassKeyData.sharedInstance.REF_BOXES
//
//        print("getBoxNumberRunning ")
 //        
//        let newBoxCategoryKey = newBoxCategory.catKey
//        let catRef  = PassKeyData.sharedInstance.REF_CATEGORY.childByAppendingPath(newBoxCategoryKey)
//        catRef.observeEventType(.Value, withBlock: { snapshot in
//            print("Category Value: \(snapshot.value)")
//            
//            if let categoryStartingNumber = snapshot.value["startingNumber"] as? Int {
//                print("categoryStartingNumber: \(categoryStartingNumber)")
//                
//                
//                //         Test if any boxes exist at all -
//                self.refBox.observeEventType(.Value, withBlock: { snapshot in
//                    if snapshot.value is NSNull {
//                        
//                        print("No Boxes exist")
//                        self.nextBoxNumber = categoryStartingNumber
//                        self.segToBoxDetails()
//                        
//                    } else {
//                        print("boxes do exist")
//                        print("I still know the starting number: \(categoryStartingNumber)")
//                        let endingNum = categoryStartingNumber + 98
//                        print("I hate math- endingNum: \(endingNum)")
//                        
//                        
//                        self.refBox.queryOrderedByChild("boxNum").queryLimitedToLast(1).queryStartingAtValue(categoryStartingNumber).queryEndingAtValue(endingNum).observeEventType(.ChildAdded, withBlock: { snapshot in
//                            print("query :\(snapshot.value)")
//                            if let tempBoxNum = snapshot.value["boxNum"] as? Int {
//                                print("temp: \(tempBoxNum)")
//                                
//                                // add 1 to last box number to make the next box number to be created
//                                self.nextBoxNumber = (tempBoxNum + 1)
//                            }else {
//                                print("ELSE  IF LET TEMPBOXNUM")
//                                
//                            }
//                            print("out of the IF LET TEMPBOXNUM")
//                            self.segToBoxDetails()
//                        })
//                    }
//                    print("OUT OF THE ELSE BLOCK   ")
//                })
//            }
//        })
//        
//    }
//    
 
    
    
} // class





