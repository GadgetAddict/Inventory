//
//  BoxCell
//  Inventory
//
//  Created by Michael King on 4/3/16.
//  Copyright © 2016 Michael King. All rights reserved.
//


import UIKit
import Firebase
import QRCode
 
    
class BoxCell: UITableViewCell, UINavigationControllerDelegate {
 
    
    var box: Box!
    var itemRef: String!

//    @IBOutlet weak var fragileImg: UIImageView!
//    @IBOutlet weak var boxNumberLbl: UILabel!
    @IBOutlet weak var boxCatLbl: UILabel!
    @IBOutlet weak var boxStatusLbl: UILabel!
    @IBOutlet weak var boxNameLbl: UILabel!
    @IBOutlet weak var boxNumberLbl: UILabel!
    @IBOutlet weak var boxItemCount: UILabel!
    @IBOutlet weak var QrCodeImage: UIImageView!
    
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
  
        
        
//        QrCodeImage.image = {
//            var qrCode = QRCode("http://github.com/aschuch/QRCode")!
//            qrCode.size = self.QrCodeImage.bounds.size
//            qrCode.errorCorrection = .High
//            qrCode.color = CIColor(rgba: "996633")
//
//            return qrCode.image
//        }()
        
//         did i even use this ?
//        itemRef = box.boxKey
//        print("Box Numbr: \(box.boxNumber)")
     

        if let boxName = box.boxName {
            self.boxNameLbl.text = boxName
        } else {
            self.boxNameLbl.text = "Box Number"
        }
        

        if let boxItemCount = box.boxItemCount {
 
        self.boxItemCount.text = ("\(boxItemCount)")

        } else {
            self.boxItemCount.text = "0"
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
