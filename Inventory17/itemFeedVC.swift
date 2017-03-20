

//
//  BoxFeedVC.swift
//  Inventory17
//
//  Created by Michael King on 2/7/17.
//  Copyright © 2017 Microideas. All rights reserved.
//


import UIKit
import Firebase
import DZNEmptyDataSet



class itemFeedVC: UITableViewController ,UINavigationControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    
  static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var REF_ITEMS: FIRDatabaseReference!
    var items = [Item]()
    var resultSearchController = UISearchController()
    
    lazy var itemIndexPath: NSIndexPath? = nil
    var selectedItem: Item?
    var collectionID: String!
    
    
 
   
    override func viewDidLoad() {
     super.viewDidLoad()
        
        
print("ITEM FEED VIEW DID LOAD")
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "CollectionIdRef") != nil) {
            if let collectionId = defaults.string(forKey: "CollectionIdRef") {
                self.collectionID = collectionId
                self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(collectionId)/inventory/items")
                print("Load Collection REF: \(self.REF_ITEMS)")
                self.loadItems()
   
            }
        }
    
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.tableView.emptyDataSetSource = self
       self.tableView.emptyDataSetDelegate = self

       EZLoadingActivity.show("Loading Items", disableUI: true)
        
//        let when = DispatchTime.now() + 0 // change  to desired number of seconds
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            self.loadItems()
//        }
   
        let addBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        addBtn.setImage(UIImage(named: "Plus 2 Math_50"), for: UIControlState.normal)
        let newACtion = "newItem"
        addBtn.addTarget(self, action: Selector(newACtion), for:  UIControlEvents.touchUpInside)
        let rightItem = UIBarButtonItem(customView: addBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        searchBtn.setImage(UIImage(named: "Search_50"), for: UIControlState.normal)
        let searchAction = "searchTapped"
        searchBtn.addTarget(self, action: Selector(searchAction), for:  UIControlEvents.touchUpInside)
        let leftItem = UIBarButtonItem(customView: searchBtn)
        self.navigationItem.leftBarButtonItem = leftItem

    }
    
    func newItem()  {
        performSegue(withIdentifier: "newItem_SEGUE", sender: nil)

    }
    
    func searchTapped()  {
        print("in searchTapped")
//        performSegue(withIdentifier: "searchItem_SEGUE", sender: nil)
        
    }
    
    func loadItems(){
        print("in Function loadItems")
        
        DispatchQueue.main.async {
      
        
//        let queue1 = DispatchQueue(label: "com.michael.loadFB", qos: DispatchQoS.userInitiated)

//        queue1.async {
      
            print("in queue1.async")

       
        
        self.REF_ITEMS?.observe(.value, with: {(snapshot)  in
            self.items = [] // THIS IS THE NEW LINE
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let itemDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        print("ITEM Snap Key: \(snap.key)")
                        let item = Item(itemKey: key, dictionary: itemDict)
                            self.items.append(item)
                    }
                }
            }
            EZLoadingActivity.hide()
            self.tableView.reloadData()
        })
 }
    }
    
    
    
    func cancelButtonTapped(){
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
 
    }
    
    
        func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
            return UIImage(named: "package")
        }
    
        func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
            let text = "You Have No Items"
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
         self.performSegue(withIdentifier: "newItem_SEGUE", sender: self)
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let item = items[indexPath.row]
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as?  ItemCell {
                
                
                var img: UIImage?
                
                if let url = item.itemImgUrl {
                    img = itemFeedVC.imageCache.object(forKey: url  as NSString)
                }
                
                cell.configureCell(item: item, img: img)
                
                return cell
            } else {
                return ItemCell()
            }
    }
//            print("cellForRowAt: \(items.count)")
//    
//            let item = items[indexPath.row]
//    
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell {
//    
//                if let itemURL = item.itemImgUrl {
//            if let img = itemFeedVC.imageCache.object(forKey: itemURL as NSString) {
//                
//             
//                cell.configureCell(item: item, img: img)
//                    }
//                } else {
//                cell.configureCell(item: item,  img:nil)
//                   
//                        }
//                return cell
//                
//            } else {
//                return ItemCell()
//                }
             
    
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
        
        return [addToBoxAction, deleteAction ]
        
    }
    
    
    
    
    
    
//     Add To Box Method Confirmation and Handling
            func addToBoxMethod(item: String) {
                let alert = UIAlertController(title: "Add Item to Box", message: "Choose a method to locate the desired Box.", preferredStyle: .actionSheet)
    
                let ScanAction = UIAlertAction(title: "Scan QR", style: .default, handler: scanForBox)
                let PickAction = UIAlertAction(title: "Choose from List", style: .default, handler: pickForBox)
                let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteItem)
    
                alert.addAction(ScanAction)
                alert.addAction(PickAction)
                alert.addAction(CancelAction)
    
    
                self.present(alert, animated: true, completion: nil)
            }
    
    
    
    
    
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
    
    
    
    func cancelDeleteItem(alertAction: UIAlertAction!) {
        itemIndexPath = nil
        self.tableView.isEditing = false

    }
    
    
 
    
        func scanForBox(alertAction: UIAlertAction!) -> Void {
            print("Which segue remark is working / toScanQR")
    
            self.performSegue(withIdentifier: "toScanQR", sender: nil)
    
        }
    
        func pickForBox(alertAction: UIAlertAction!) -> Void {
            print("Which segue remark is working / BoxList")
//          if let indexPath = itemIndexPath {
//             let itemObject  = items[indexPath.row]
//           let itemCat = itemObject.itemCategory
    
            self.performSegue(withIdentifier: "showBoxList", sender: nil)
            
    }
 
     func showAlertForRow(row: Int) {
          // add item to box by scanning or by picking a number from table view
    
             let dict = items[row]
            let item = dict.itemName
    
            //ActionSheet to ask user to scan or choose
           let alertController = UIAlertController(title: "Add \(item) to Box", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
    
          let qrScanAction = UIAlertAction(title: "Scan Box QR", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
               print("Scan QR button tapped")
                self.performSegue(withIdentifier: "toScanQR", sender: nil)
   
    
           })
           alertController.addAction(qrScanAction)
          let showBoxListAction = UIAlertAction(title: "Pick from List of Boxes", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
              print("show List button tapped")
              self.performSegue(withIdentifier: "showBoxList", sender: nil)
    
           })
          alertController.addAction(showBoxListAction)
    
          let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert :UIAlertAction) in
              print("Cancel button tapped")
         })
         alertController.addAction(cancelAction)
    
           present(alertController, animated: true, completion: nil)
       }
   
     
        @IBAction func addToBox(sender: AnyObject) {
           print("Clicked Add to Box ACTION ")
           self.tableView.setEditing(true, animated: true)
     }
            
  
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print("prepareForSegue ")
    
                if segue.identifier == "showBoxList" {
                    print("identifier ==  showBoxList ")
    
                    if let indexPath = itemIndexPath {
                        let itemObject  = items[indexPath.row]
    
                        if let destination = segue.destination as? BoxFeedVC {
                        destination.boxLoadType = .category
                        destination.itemPassed = itemObject
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
      
    @IBAction func unwindToItemsFromBoxSel(_ segue:UIStoryboardSegue) {
        if let boxFeedViewController = segue.source as? BoxFeedVC {

            let selectedBox = boxFeedViewController.boxToPass.boxKey
            if let itemToBox = boxFeedViewController.itemPassed.itemKey {
            
                let REF_BOX = DataService.ds.REF_BASE.child("/collections/\(self.collectionID!)/inventory/boxes/\(selectedBox!)/items/")
                
                self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(self.collectionID!)/inventory/items/\(itemToBox)/")
                
                let boxNumDict: Dictionary<String, String> =
                    ["itemBoxNum" : selectedBox! ]
                
                let itemDict: Dictionary<String, String> =
                    ["itemKey" : itemToBox ]
                
                REF_BOX.setValue(itemDict)
                self.REF_ITEMS.updateChildValues(boxNumDict)

            }}
        }
 
    
    

    
}//itemFeedVC























////
////  itemFeedVC.swift
////  Inventory
////
////  Created by Michael King on 4/1/16.
////  Copyright © 2016 Michael King. All rights reserved.
////
//
//import UIKit
//import Firebase
//import DZNEmptyDataSet
//
//
//class itemFeedVC: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,


//     override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//                    itemIndexPath = indexPath as NSIndexPath?
//                    let itemToModify  = items[indexPath.row]
//                    let itemName = itemToModify.itemName
////                    let itemKey = itemToModify.itemKey
//
//        
//        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "\u{1F5d1}\n Delete", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
//
//            let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to permanently delete: \(itemName)?", preferredStyle: .actionSheet)
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
//        let addToBoxAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "\u{1f4e6}\n Box", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
//            let boxMenu = UIAlertController(title: nil, message: "Add Item to Box", preferredStyle: UIAlertControllerStyle.actionSheet)
//            let ScanAction = UIAlertAction(title: "Scan QR", style: .default, handler: self.scanForBox)
//            let PickAction = UIAlertAction(title: "Choose from List", style: .default, handler: self.pickForBox)
//            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteItem)
//            boxMenu.addAction(ScanAction)
//            boxMenu.addAction(PickAction)
//            boxMenu.addAction(CancelAction)
//
//            self.present(boxMenu, animated: true, completion: nil)
//        })
//        addToBoxAction.backgroundColor = UIColor.brown
//       
//        return [deleteAction, addToBoxAction]
//        
//    }
//    
//   
////    override  func tableView(_ tableView: UITableView, didSelectRowAt
////        indexPath: IndexPath){
////         self.selectedColor = colors[indexPath.row]
////        
////        self.performSegue(withIdentifier: "unwind_saveColorToItemDetails", sender: self)
////        
////    }
// 
//    

//    
//    
// 


//    
//    
//    

//    
//    func showAlertForRow(row: Int) {
////        // add item to box by scanning or by picking a number from table view
////        
////        let dict = items[row]
////        let item = dict.itemName
////        
////        
////        //ActionSheet to ask user to scan or choose
////        let alertController = UIAlertController(title: "Add \(item) to Box", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
////        
////        let qrScanAction = UIAlertAction(title: "Scan Box QR", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
////            print("Scan QR button tapped")
////            self.performSegue(withIdentifier: "toScanQR", sender: nil)
////            
////            
////        })
////        alertController.addAction(qrScanAction)
////        
////        let showBoxListAction = UIAlertAction(title: "Pick from List of Boxes", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
////            print("show List button tapped")
////            self.performSegue(withIdentifier: "showBoxList", sender: nil)
////
////        })
////        alertController.addAction(showBoxListAction)
////        
////        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert :UIAlertAction) in
////            print("Cancel button tapped")
////        })
////        alertController.addAction(cancelAction)
////        
////        present(alertController, animated: true, completion: nil)
//    }
//
//
//
//
//
// 
//
//    
////    
////    @IBAction func addToBox(sender: AnyObject) {
////        print("Clicked Add to Box ACTION ")
////        self.tableView.setEditing(true, animated: true)
////    }
//    
//
//    
//    
//    
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("prepareForSegue ")
//        
//            if segue.identifier == "showBoxList" {
//                print("identifier ==  showBoxList ")
//                
//                if let indexPath = itemIndexPath {
//                    let itemObject  = items[indexPath.row]
//           
//                    if let destination = segue.destination as? BoxFeedVC {
//                    destination.boxLoadType = .category
//                    destination.showBoxByCategory = itemObject.itemCategory!
//                        print("itemCategory ==  \(itemObject.itemCategory) ")
//
//                    }
//                }
//            } else {
//                if let cell = sender as? UITableViewCell {
//                    let indexPath = tableView.indexPath(for: cell)
//                    let itemToPass = items[indexPath!.row]
//
//                if segue.identifier == "existingItem_SEGUE" {
//                    print("existingItem_SEGUE ")
//                    
//                    if let destination = segue.destination as? ItemDetails {
//                        destination.passedItem = itemToPass
//                        destination.itemType = .existing
//                        print("Item to Pass is \(itemToPass.itemName)")
//                    }
//                }
//                
//            }
//        }
//    }
//    
//    
//    
////
////
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        print("prepareForSegue from item FEED")
////        
////      
////            print("prepare for segue: let indexPath ")
////
////            if segue.identifier == "existingItem_SEGUE" {
////                print("existingItem_SEGUE ")
////                if let destination = segue.destination as? ItemDetails {
////                    destination.passedItem = itemObject
////                    destination.itemType = .existing
////                    print("Item to Pass is \(itemObject.itemName)")
////                    
////                }
////            } else {
////            
////            if segue.identifier == "showBoxList" {
////                print("segue: showBoxList ")
////
////                if let indexPath = itemIndexPath {
////                    let itemObject  = items[indexPath.row]
////                    let itemCat = itemObject.itemCategory
////
////                
////                    if let addToBoxVC = segue.destination as? BoxFeedVC {
////                    print("segue: addToBoxVC destination ")
////
////                    addToBoxVC.showBoxByCategory = itemCat
////                    addToBoxVC.boxLoadType = .category
////                    print("item Category: \(itemCat) ")
////
////                        }
////    
////
////          
////            
////            }
////        }
////    }
////    }
////    
//// 

