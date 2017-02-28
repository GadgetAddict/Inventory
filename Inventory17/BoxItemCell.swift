//
//  BoxItemCell.swift
//  Inventory17
//
//  Created by Michael King on 2/24/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit

protocol BoxItemsButtonCellDelegate {
    func cellTapped(cell: BoxItemCell)
}

class BoxItemCell: UITableViewCell {
    
    var buttonDelegate: BoxItemsButtonCellDelegate?
    @IBOutlet weak var rowLabel: UILabel!
    
    @IBAction func buttonTap(sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.cellTapped(cell: self)
        }
    }
    

    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var checkMarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var item: Item!
 
 
    
    func configureCell(item: Item) {
        
      self.itemLabel.text = item.itemName
            
        
    }//ConfigureCell

}
