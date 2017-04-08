//
//  ItemCell.swift
//  Inventory
//
//  Created by Michael King on 4/3/16.
//  Copyright © 2016 Michael King. All rights reserved.
//

import UIKit
import Firebase


class ItemCell: UITableViewCell, UINavigationControllerDelegate {
    
    
     @IBOutlet weak var rowLabel: UILabel!
    
       
    var item: Item!
     
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var subCategoryLbl: UILabel!
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var boxNumberLbl: UILabel!
    @IBOutlet weak var imgFragile: UIImageView!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var boxNumberScanBtnLbl: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }//awakeFromNib
    
    
    
    
//    override func draw(_ rect: CGRect) {
//        imageThumb.clipsToBounds = true
//    }
   
    func configureCell(item: Item, img: UIImage?) {
        self.item = item
     let getImage_QUEUE = DispatchQueue(label: "com.michael.getImagequeue", qos: DispatchQoS.userInteractive     )
//        
//
        
        if let qty = item.itemQty {
            self.qty.text = "\(qty)"
        } else {
            self.qty.text = "   "
        }
        
        self.nameLbl.text = item.itemName.capitalized
        self.categoryLbl.text = "\(item.itemCategory!.capitalized):"
        self.subCategoryLbl.text = "\(item.itemSubcategory!.capitalized)"
        if item.itemBoxNum != nil {
         self.boxNumberLbl.text = "Box  \(item.itemBoxNum!)"
//            self.boxNumberScanBtnLbl.setTitle("Change Box", forState: UIControlState.Normal)
            
        } else {
            self.boxNumberLbl.isHidden = true

//            self.boxNumberScanBtnLbl.setTitle("Add to Box", forState: UIControlState.Normal)
        }
 
        //check if fragile, show image or don't
        if item.itemFragile == false {
            self.imgFragile.isHidden = true
        }else{
            self.imgFragile.isHidden = false
            
        }
//        if img != nil {
//            self.imageThumb.image = img
//            } else {
//       getImage_QUEUE.async {
        if let URL = item.itemImgUrl {
            let ref = FIRStorage.storage().reference(forURL: URL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("MK: Unable to download image from Firebase storage")
                } else {
                    print("MK: Image downloaded from Firebase storage")
                    if let imgData = data {

    
                        if let img = UIImage(data: imgData) {
                          DispatchQueue.main.async {
                            self.imageThumb.image = img
                            itemFeedVC.imageCache.setObject(img, forKey: URL as NSString)
                            }
                            }
                        }
                    }
                })
            }
//        }
    
 
    }//ConfigureCell
    
    
    
    
    
}//ItemCell class









