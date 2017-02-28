//
//  itemFeedVC.swift
//  Inventory
//
//  Created by Michael King on 4/1/16.
//  Copyright © 2016 Michael King. All rights reserved.
//

import UIKit
import Firebase



class itemFeedVC: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, ButtonCellDelegate{
    
    internal func cellTapped(cell: ItemCell) {
        self.showAlertForRow(row: tableView.indexPath(for: cell)!.row)
    }


  
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var InventoryRefString: String!
    var REF_ITEMS: FIRDatabaseReference!
    var items = [Item]()
    var selectedItem: Item?
    
    var itemIndexPath: NSIndexPath? = nil
//    var passedInfo = PassKeyData.sharedInstance   //Holds Item from Cell Button for Add to Box


 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.delegate = self
        tableView.dataSource = self
   
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        getCollection {
                loadFirebaseData()
                }
            }
    


    
    func getCollection(finished: () -> Void) {
         let defaults = UserDefaults.standard
        if (defaults.object(forKey: "CollectionIdRef") != nil) {
            
            if let collectionId = defaults.string(forKey: "CollectionIdRef") {
                
                self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(collectionId)/inventory/items")
                
            }}
        
        finished()
    }
    
  
    func loadFirebaseData(){
  
        
        print("LOAD FIREBASE DATA")
        self.items = [] // THIS IS THE NEW LINE

        self.REF_ITEMS.observe(.value, with: {(snapshot)  in
 

            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let itemDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Item(itemKey: key, dictionary: itemDict)
                        print("item \(item.itemName)")

                        self.items.append(item)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = nil
        
        if items.count > 0 {
            
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            return items.count
        } else {
            
            let emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height: 32))
            emptyStateLabel.font = emptyStateLabel.font.withSize(14)
            emptyStateLabel.text = "Tap '+' to Begin adding Items"
            emptyStateLabel.textAlignment = .center;
            tableView.backgroundView = emptyStateLabel
            
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell {
            
        if let img = itemFeedVC.imageCache.object(forKey: item.itemImgUrl as NSString) {
            cell.configureCell(item: item, img: img)
            } else {
            cell.configureCell(item: item)
                if cell.buttonDelegate == nil {
                    cell.buttonDelegate = self
                }
                    }
            return cell
        } else {
            return ItemCell()
        }
    }

     override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
                    itemIndexPath = indexPath as NSIndexPath?
                    let itemToModify  = items[indexPath.row]
                    let itemName = itemToModify.itemName
//                    let itemKey = itemToModify.itemKey

        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "\u{1F5d1}\n Delete", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in

            let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to permanently delete: \(itemName)?", preferredStyle: .actionSheet)
            
            let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteItem)
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteItem)
            
            alert.addAction(DeleteAction)
            alert.addAction(CancelAction)
            
            
            self.present(alert, animated: true, completion: nil)
 
        })
        
        deleteAction.backgroundColor = UIColor.red
        
        let addToBoxAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "\u{1f4e6}\n Box", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            let boxMenu = UIAlertController(title: nil, message: "Add Item to Box", preferredStyle: UIAlertControllerStyle.actionSheet)
            let ScanAction = UIAlertAction(title: "Scan QR", style: .default, handler: self.scanForBox)
            let PickAction = UIAlertAction(title: "Choose from List", style: .default, handler: self.pickForBox)
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteItem)
            boxMenu.addAction(ScanAction)
            boxMenu.addAction(PickAction)
            boxMenu.addAction(CancelAction)

            self.present(boxMenu, animated: true, completion: nil)
        })
        addToBoxAction.backgroundColor = UIColor.brown
       
        return [deleteAction, addToBoxAction]
        
    }
    
   
//    override  func tableView(_ tableView: UITableView, didSelectRowAt
//        indexPath: IndexPath){
//         self.selectedColor = colors[indexPath.row]
//        
//        self.performSegue(withIdentifier: "unwind_saveColorToItemDetails", sender: self)
//        
//    }
 
    
    
//    // Add To Box Method Confirmation and Handling
//    func addToBoxMethod(item: String) {
//        let alert = UIAlertController(title: "Add Item to Box", message: "Choose a method to locate the desired Box.", preferredStyle: .actionSheet)
//        
//        let ScanAction = UIAlertAction(title: "Scan QR", style: .default, handler: scanForBox)
//        let PickAction = UIAlertAction(title: "Choose from List", style: .default, handler: pickForBox)
//        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteItem)
//        
//        alert.addAction(ScanAction)
//        alert.addAction(PickAction)
//        alert.addAction(CancelAction)
//        
//        
//        self.present(alert, animated: true, completion: nil)
//    }
//    
    
    
 
    
    func handleDeleteItem(alertAction: UIAlertAction!) -> Void {
      print("IN THE DELETE FUNCTION")
        if let indexPath = itemIndexPath {
            
            tableView.beginUpdates()
            let itemObject  = items[indexPath.row]
            let itemKey = itemObject.itemKey
            self.REF_ITEMS.child(itemKey!).removeValue()
            itemIndexPath = nil
            tableView.endUpdates()
            
        }
    }
    
    func scanForBox(alertAction: UIAlertAction!) -> Void {
        print("Which segue remark is working / toScanQR")
        
        self.performSegue(withIdentifier: "toScanQR", sender: nil)
        
    }
    
    func pickForBox(alertAction: UIAlertAction!) -> Void {
        print("Which segue remark is working / BoxList")
//        if let indexPath = itemIndexPath {
//            let itemObject  = items[indexPath.row]
//            let itemCat = itemObject.itemCategory

        self.performSegue(withIdentifier: "showBoxList", sender: nil)
        }
    
    
    
    
    func cancelDeleteItem(alertAction: UIAlertAction!) {
        itemIndexPath = nil
    }

    
    func showAlertForRow(row: Int) {
//        // add item to box by scanning or by picking a number from table view
//        
//        let dict = items[row]
//        let item = dict.itemName
//        
//        
//        //ActionSheet to ask user to scan or choose
//        let alertController = UIAlertController(title: "Add \(item) to Box", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
//        
//        let qrScanAction = UIAlertAction(title: "Scan Box QR", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
//            print("Scan QR button tapped")
//            self.performSegue(withIdentifier: "toScanQR", sender: nil)
//            
//            
//        })
//        alertController.addAction(qrScanAction)
//        
//        let showBoxListAction = UIAlertAction(title: "Pick from List of Boxes", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
//            print("show List button tapped")
//            self.performSegue(withIdentifier: "showBoxList", sender: nil)
//
//        })
//        alertController.addAction(showBoxListAction)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert :UIAlertAction) in
//            print("Cancel button tapped")
//        })
//        alertController.addAction(cancelAction)
//        
//        present(alertController, animated: true, completion: nil)
    }





 

    
//    
//    @IBAction func addToBox(sender: AnyObject) {
//        print("Clicked Add to Box ACTION ")
//        self.tableView.setEditing(true, animated: true)
//    }
    

    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue ")
        
            if segue.identifier == "showBoxList" {
                print("identifier ==  showBoxList ")
                
                if let indexPath = itemIndexPath {
                    let itemObject  = items[indexPath.row]
           
                    if let destination = segue.destination as? BoxFeedVC {
                    destination.boxLoadType = .category
                    destination.showBoxByCategory = itemObject.itemCategory!
                        print("itemCategory ==  \(itemObject.itemCategory) ")

                    }
                }
            } else {
                if let cell = sender as? UITableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    let itemToPass = items[indexPath!.row]

                if segue.identifier == "existingItem_SEGUE" {
                    print("existingItem_SEGUE ")
                    
                    if let destination = segue.destination as? ItemDetails {
                        destination.passedItem = itemToPass
                        destination.itemType = .existing
                        print("Item to Pass is \(itemToPass.itemName)")
                    }
                }
                
            }
        }
    }
    
    
    
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("prepareForSegue from item FEED")
//        
//      
//            print("prepare for segue: let indexPath ")
//
//            if segue.identifier == "existingItem_SEGUE" {
//                print("existingItem_SEGUE ")
//                if let destination = segue.destination as? ItemDetails {
//                    destination.passedItem = itemObject
//                    destination.itemType = .existing
//                    print("Item to Pass is \(itemObject.itemName)")
//                    
//                }
//            } else {
//            
//            if segue.identifier == "showBoxList" {
//                print("segue: showBoxList ")
//
//                if let indexPath = itemIndexPath {
//                    let itemObject  = items[indexPath.row]
//                    let itemCat = itemObject.itemCategory
//
//                
//                    if let addToBoxVC = segue.destination as? BoxFeedVC {
//                    print("segue: addToBoxVC destination ")
//
//                    addToBoxVC.showBoxByCategory = itemCat
//                    addToBoxVC.boxLoadType = .category
//                    print("item Category: \(itemCat) ")
//
//                        }
//    
//
//          
//            
//            }
//        }
//    }
//    }
//    
// 
 
    @IBAction func unwindToItemsFromBoxSel(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.sourceViewController
//            as? SelectBoxVC {
//            let selectedBox = sourceViewController.selectedBox  //passed from PickBox VC
//            
//            //save box key to Item
//            let itemRef = DataService.ds.REF_ITEMS.childByAppendingPath(self.selectedItem.itemKey).childByAppendingPath("inBox")
//            let boxData = [selectedBox : true ]
//            itemRef.setValue(boxData)
//
//            //save item key to box
//            let boxRef = DataService.ds.REF_BOXES.childByAppendingPath(selectedBox).childByAppendingPath("items")
//            let itemData = [self.selectedItem.itemKey : true ]
//            boxRef.setValue(itemData)
//
//            
//        }
    }
    
    }//itemFeedVC


