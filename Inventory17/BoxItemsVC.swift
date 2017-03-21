//
//  BoxItemsVC.swift
//  Inventory17
//
//  Created by Michael King on 2/24/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet

class BoxItemsVC: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
  
    
  
        var items = [Item]()
        var box: Box!
        var selectedItems = [Item]()
        var boxItemIndexPath: NSIndexPath? = nil
        var collectionID: String!
        var REF_ITEMS: FIRDatabaseReference!
 
    @IBAction func addToBoxBtn(_ sender: UIBarButtonItem) {
//        Take all checked items that are in the array and add their keys to the Box/contents in Firebase
    
    
    
    }
    
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
    
            tableView.tableFooterView = UIView()
            tableView.tableFooterView = UIView(frame: CGRect.zero)
    
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            
            
//            let defaults = UserDefaults.standard
//    
//            if (defaults.object(forKey: "CollectionIdRef") != nil) {
//                print("Getting Defaults")
//    
//                if let collectionId = defaults.string(forKey: "CollectionIdRef") {
//                    COLLECTION_ID = collectionId
//                }
//            }
    
            loadDataFromFirebase()
    
    
    
        }   // End ViewDidLoad
    
    
    
        func loadDataFromFirebase() {
            print("loadDataFromFirebase")

            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/boxes/\(self.box.boxKey!)/items")
//                  print("REFERENCE: \(myRef)")
       
            //         REF_STATUS.queryOrdered(byChild: "statusName").observe(.value, with: { snapshot in
    
            self.REF_ITEMS.observe(.value, with: { snapshot in
    
                self.items = []
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        print("ItemSnap: \(snap)")
    
                        if let itemDict = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                             let item = Item(itemKey: key, dictionary: itemDict)
                            self.items.append(item)
                        }
                    }
                }
                
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            })
        }
    
   
 
    //MARK: - UITableViewDataSource
    

//        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return items.count
//        }
//    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                tableView.backgroundView = nil
        
                if items.count > 0 {
        
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                    return items.count
                } else {
        
                    let emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height: 32))
                    emptyStateLabel.font = emptyStateLabel.font.withSize(14)
                    emptyStateLabel.text = "Tap 'Add Items' to fill this box"
                    emptyStateLabel.textAlignment = .center;
                    tableView.backgroundView = emptyStateLabel
        
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
                }
                
                return 0
            }
        
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let item = items[indexPath.row]
            
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "boxItemsCell") as? BoxItemCell {
                        cell.configureCell(item: item)
                        cell.accessoryType = .none
                        return cell
                    } else {
                        return BoxItemCell()
                    }
                }
    
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "package")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "This Box is Empty"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Add Items By Tapping the + Button."
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.byWordWrapping
        para.alignment = NSTextAlignment.center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.lightGray,
            NSParagraphStyleAttributeName: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        
        let text = "Add Your First Item"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
            NSForegroundColorAttributeName: view.tintColor
            ] as [String : Any]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        self.performSegue(withIdentifier: "addToBox", sender: self)
    }

    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        boxItemIndexPath = indexPath as NSIndexPath?
        let boxItemToModify  = items[indexPath.row]
        let itemName = boxItemToModify.itemName
        //                    let itemKey = itemToModify.itemKey
        
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Remove", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to remove \(itemName) from this box?", preferredStyle: .actionSheet)
            
            let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteItem)
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteItem)
            
            alert.addAction(DeleteAction)
            alert.addAction(CancelAction)
            
            
            self.present(alert, animated: true, completion: nil)
            
        })
        
        deleteAction.backgroundColor = UIColor.red
        

        return [deleteAction ]
        
    }
    
    func handleDeleteItem(alertAction: UIAlertAction!) -> Void {
        print("IN THE DELETE FUNCTION")
        if let indexPath = boxItemIndexPath {
            
            tableView.beginUpdates()
            let itemObject  = items[indexPath.row]
            let itemKey = itemObject.itemKey
            self.REF_ITEMS.child(itemKey!).removeValue()
            boxItemIndexPath = nil
            tableView.endUpdates()
            
        }
    }
    
    
    
    func cancelDeleteItem(alertAction: UIAlertAction!) {
        boxItemIndexPath = nil
    }
    



        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print("BoxItems: prepareForSegue ")
            
            if let addItemsVC = segue.destination as? AddItemsToBoxVC {
                addItemsVC.box = self.box
            }

                
//            if let cell = sender as? UITableViewCell {
//                let indexPath = tableView.indexPath(for: cell)
//                let itemToPass = items[indexPath!.row]
//               
//                    if segue.identifier == "itemDetails_SEGUE" {
//                        print("Box to itemDetails_SEGUE ")
            
                        if let addItem = segue.destination as? AddItemsToBoxVC {
                            addItem.box = self.box
//                            addItem.boxItemKey = itemToPass.itemKey
//                            itemDetailVC.itemType = .boxItem
//                            print("Item to Pass is \(itemToPass.itemName)")
//                            print("Item to Pass is \(itemToPass.itemKey)")

                    }
                    
                }
    
    
    
}  //end of class

//    var items = [Item]()
//
//    var selectedItems = [Item]()
////    var colorIndexPath: NSIndexPath? = nil
//    var collectionID: String!
//    var REF_ITEMS: FIRDatabaseReference!
//    
//    
//    @IBAction func doneButton(sender: UIBarButtonItem) {
//        //        self.dismiss(animated: true, completion: nil)
//        _ = navigationController?.popViewController(animated: true)
//        
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.tableFooterView = UIView()
//        tableView.tableFooterView = UIView(frame: CGRect.zero)
//      
//        
//        let defaults = UserDefaults.standard
//        
//        if (defaults.object(forKey: "CollectionIdRef") != nil) {
//            print("Getting Defaults")
//            
//            if let collectionId = defaults.string(forKey: "CollectionIdRef") {
//                COLLECTION_ID = collectionId
//            }
//        }
//        
//        loadDataFromFirebase()
//        
//       
//        
//    }   // End ViewDidLoad
//    
//    
//    
//    func loadDataFromFirebase() {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        
//        self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/items")
//        
//        //         REF_STATUS.queryOrdered(byChild: "statusName").observe(.value, with: { snapshot in
//        
//        self.REF_ITEMS.observe(.value, with: { snapshot in
//            
//            self.items = []
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap in snapshots {
//                    print("ItemSnap: \(snap)")
//                    
//                    if let itemDict = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let item = Item(itemKey: key, dictionary: itemDict)
//                        self.items.append(item)
//                    }
//                }
//            }
//            
//            self.tableView.reloadData()
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            
//        })
//    }
//    
//
//    
//    // MARK: - Table view data source
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        print("selected  \(items[indexPath.row])")
//        
//        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
//            if cell.isSelected {
//                cell.accessoryType = .checkmark
//            }
//        }
//        
//        if let sr = tableView.indexPathsForSelectedRows {
//            print("didDeselectRowAtIndexPath selected rows:\(sr)")
//        }
//    }
//    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        print("deselected  \(items[indexPath.row])")
//        
//        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
//            cell.accessoryType = .none
//        }
//        
//        if let sr = tableView.indexPathsForSelectedRows {
//            print("didDeselectRowAtIndexPath selected rows:\(sr)")
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let item = items[indexPath.row]
//        
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "boxItemsCell") as? BoxItemCell {
//            cell.configureCell(item: item)
//            cell.accessoryType = .none
//            return cell
//        } else {
//            return BoxItemCell()
//        }
//    }
//    
    
    
    
//    // MARK: UITableViewDelegate Methods
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .delete {
//            colorIndexPath = indexPath
//            let color  = colors[indexPath.row]
//            let colorsToDelete = color.colorName
//            confirmDelete(Item: colorsToDelete!)
//        } else {
//            if editingStyle == .insert {
//                tableView.beginUpdates()
//                
//                //                tableView.insertRowsAtIndexPaths([
//                //                    NSIndexPath(forRow: statuses.count-1, inSection: 0)
//                //                    ], withRowAnimation: .Automatic)
//                //
//                tableView.endUpdates()
//            }
//        }
//    }
    
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        
//        colorIndexPath = indexPath as NSIndexPath?
//        let colorsToDelete  = colors[indexPath.row]
//        let colorName = colorsToDelete.colorName
//        
//        
//        
//        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "\u{1F5d1}\n Delete", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
//            
//            let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to permanently delete: \(colorName)?", preferredStyle: .actionSheet)
//            
//            let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteItem)
//            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteItem)
//            
//            alert.addAction(DeleteAction)
//            alert.addAction(CancelAction)
//            
//            
//            self.present(alert, animated: true, completion: nil)
//            
//        })
//        
//        deleteAction.backgroundColor = UIColor.red
//        
//        return [deleteAction]
//    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.separatorInset = UIEdgeInsets.zero
//        cell.layoutMargins = UIEdgeInsets.zero
//    }
//    
// 
//    
//
//    
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // the cells you would like the actions to appear needs to be editable
//        return true
//    }
//    
    
    
//    override  func tableView(_ tableView: UITableView, didSelectRowAt
//        indexPath: IndexPath){
//        print("CALLING THE SEGUE CELL")
//        self.selectedItems = [items[indexPath.row]]
//        
//        self.performSegue(withIdentifier: "unwind_saveColorToItemDetails", sender: self)
//        
//    }
    
//    
//    func showErrorAlert(title: String, msg: String) {
//        let alertView = UIAlertController(title: title, message: msg, preferredStyle: .alert)
//        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        present(alertView, animated: true, completion: nil)
//        
//    }
//    
    //
    //        func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //            if segue.identifier == "unwind_saveColorToItemDetails" {
    //                print("unwind_saveColorToItemDetails" )
    //                if let cell = sender as? UITableViewCell {
    //                    let indexPath = tableView.indexPath(for: cell)
    //                    if let index = indexPath?.row {
    //                        print("Color  IF LET CELL" )
    //
    //                        let color = colors[index]
    //                        self.selectedColor  = color.colorName
    //                    }
    //                }
    //            }
    //        }
    //
    
  //End Class

