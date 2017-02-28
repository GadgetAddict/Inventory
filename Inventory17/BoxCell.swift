//
//  BoxCell
//  Inventory
//
//  Created by Michael King on 4/3/16.
//  Copyright © 2016 Michael King. All rights reserved.
//


import UIKit
import Firebase


protocol BoxButtonCellDelegate {
        func cellTapped(cell: BoxCell)
    }
    
class BoxCell: UITableViewCell, UINavigationControllerDelegate {
    
    
    
        var buttonDelegate: BoxButtonCellDelegate?
  
        @IBAction func buttonTap(sender: AnyObject) {
            if let delegate = buttonDelegate {
                delegate.cellTapped(cell: self)
            }
        }
        
    
    
    
    var box: Box!
    var itemRef: String!

//    @IBOutlet weak var fragileImg: UIImageView!
    @IBOutlet weak var boxNumberLbl: UILabel!
    @IBOutlet weak var boxCatLbl: UILabel!
    @IBOutlet weak var boxStatusLbl: UILabel!
    @IBOutlet weak var boxNameLbl: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        
//        fragileImg.hidden = true
    
    }
    
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
    
    func configureCell(box: Box) {
        self.box = box
//        let isFragile = box.boxFragile
//        if isFragile == false {
//            fragileImg.hidden = true
//        } else {
//            fragileImg.hidden = false
//        }
        
        
//         did i even use this ?
//        itemRef = box.boxKey
//        print("Box Numbr: \(box.boxNumber)")
     

        if let boxName = box.boxName {
            self.boxNameLbl.text = boxName
        } else {
            self.boxNameLbl.text = "Box Number"
        }
        
        if let boxNumber = box.boxNumber {
            self.boxNumberLbl.text = ("\(boxNumber)")

        } else {
            self.boxNumberLbl.text = "00"
        }
        
        if let boxCategory = box.boxCategory {
           self.boxCatLbl.text =  boxCategory.capitalized
        }
        
      
        if let status = box.boxStatus {
            self.boxStatusLbl.text = status.capitalized
        } else {
            self.boxStatusLbl.text = "Not Set"
        }
        

        
    }
    
 

    
}
