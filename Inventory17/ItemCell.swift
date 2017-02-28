//
//  ItemCell.swift
//  Inventory
//
//  Created by Michael King on 4/3/16.
//  Copyright © 2016 Michael King. All rights reserved.
//

import UIKit
import Firebase

protocol ButtonCellDelegate {
    func cellTapped(cell: ItemCell)
}


class ItemCell: UITableViewCell, UINavigationControllerDelegate {
    
    
    var buttonDelegate: ButtonCellDelegate?
    @IBOutlet weak var rowLabel: UILabel!
    
    @IBAction func buttonTap(sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.cellTapped(cell: self)
        }
    }
    
    
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
    
    
    
    
    override func draw(_ rect: CGRect) {
        imageThumb.clipsToBounds = true
    }
   
    func configureCell(item: Item, img: UIImage? = nil) {
        self.item = item
        
        if let qty = item.itemQty {
            self.qty.text = "\(qty)"
        } else {
            self.qty.text = "   "
        }
        
        self.nameLbl.text = item.itemName.capitalized
        self.categoryLbl.text = "\(item.itemCategory!.capitalized)"
        self.subCategoryLbl.text = "\(item.itemSubcategory!.capitalized)"
        if item.itemBoxNum != nil {
         self.boxNumberLbl.text = "Box  \(item.itemBoxNum!)"
//            self.boxNumberScanBtnLbl.setTitle("Change Box", forState: UIControlState.Normal)
            
        } else {
            self.boxNumberLbl.isHidden = true

//            self.boxNumberScanBtnLbl.setTitle("Add to Box", forState: UIControlState.Normal)
        }
        
        
        
        if img != nil {
            self.imageThumb.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: item.itemImgUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("JESS: Unable to download image from Firebase storage")
                } else {
                    print("JESS: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.imageThumb.image = img
                            itemFeedVC.imageCache.setObject(img, forKey: item.itemImgUrl as NSString)
                        }
                    }
                }
            })
        }
        
        //check if fragile, show image or don't
        
        if item.itemFragile == false {
            self.imgFragile.isHidden = true
        }else{
            self.imgFragile.isHidden = false
            
        }//end ifFragile
        
        
        
        
    }//ConfigureCell
    
    
    
    
    
}//ItemCell class









