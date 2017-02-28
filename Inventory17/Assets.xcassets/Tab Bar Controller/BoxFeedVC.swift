//
//  BoxFeedVC.swift
//  Inventory17
//
//  Created by Michael King on 2/7/17.
//  Copyright © 2017 Microideas. All rights reserved.
//


import UIKit
import Firebase

enum BoxLoadType{
        case all
        case query
        case category
    
}


class BoxFeedVC: UITableViewController ,UINavigationControllerDelegate, BoxButtonCellDelegate{

    internal func cellTapped(cell: BoxCell) {
        self.showAlertForRow(row: tableView.indexPath(for: cell)!.row)
    }

    var InventoryRefString: String!
    var REF_BOXES: FIRDatabaseReference!
    var boxes = [Box]()
    var itemIndexPath: NSIndexPath? = nil
    var showBoxByCategory: String?
    var boxLoadType: BoxLoadType = .all
    var boxToPass: Box!
    
    
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            tableView.delegate = self
            tableView.dataSource = self
            
            
            tableView.tableFooterView = UIView()
            tableView.tableFooterView = UIView(frame: CGRect.zero)
             
        
            loadBoxes()
      
        }
    
  
    func loadBoxes(){
        
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "CollectionIdRef") != nil) {
            if let collectionId = defaults.string(forKey: "CollectionIdRef") {
                self.REF_BOXES = DataService.ds.REF_BASE.child("/collections/\(collectionId)/inventory/boxes")
                print("Load Collection REF: \(self.REF_BOXES)")
                
            }
        }
        
        
        var boxesREF: FIRDatabaseQuery?
 
        switch boxLoadType {
        case .all:
              boxesREF = (self.REF_BOXES)
              
              let qrNavButton = UIImage(named: "qrCodeSet")
              
              let leftBarButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.done, target: self, action: #selector(qrCodeButtonTapped))
              leftBarButton.image = qrNavButton
              
              self.navigationItem.leftBarButtonItem = leftBarButton

            print("Show all boxes")
            
        case .query:
              boxesREF = (self.REF_BOXES.child("boxCategory").queryEqual(toValue: ""))

            print("Show only query boxes")
            
        case .category:
              self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
              
            print("Show category")
            if let category = self.showBoxByCategory {
                self.title = "\(category.capitalized) Boxes"

             boxesREF = REF_BOXES.queryOrdered(byChild: "boxCategory").queryEqual(toValue: category)
                print("Show Querty: \(boxesREF)")

            }
 
        }
 
        
 
        boxesREF?.observe(.value, with: {(snapshot)  in
            self.boxes = [] // THIS IS THE NEW LINE

            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let boxDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        print("Box Snap Key: \(snap.key)")
                        let box = Box(boxKey: key, dictionary: boxDict)
                        self.boxes.append(box)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    
    func qrCodeButtonTapped() {
        
    }
    
    
    func cancelButtonTapped(){
        _ = navigationController?.popViewController(animated: true)

    }
    
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if boxes.count > 0 {
                
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                return boxes.count
            } else {
                
                let emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height: 32))
                emptyStateLabel.font = emptyStateLabel.font.withSize(14)
                emptyStateLabel.text = "Tap 'New Box' to Create your first empty Box"
                emptyStateLabel.textAlignment = .center;
                tableView.backgroundView = emptyStateLabel
                
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }
            
            return 0
    }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell  = tableView.dequeueReusableCell(withIdentifier: "BoxCell") as? BoxCell {
            
            let box = boxes[indexPath.row]
            cell.configureCell(box: box)
            
            return cell
        } else {
            return BoxCell()
        }
    }

    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch boxLoadType {
            case .all:
                print("selected  \(boxes[indexPath.row].boxCategory)")

                self.boxToPass = boxes[indexPath.row]
                self.performSegue(withIdentifier: "existingBox_SEGUE", sender: self)

            case .category:
                print("selected  \(boxes[indexPath.row])")
                
                if let cell = tableView.cellForRow(at: indexPath) {
                    if cell.isSelected {
                        cell.accessoryType = .checkmark
                    }
                }
                
            case .query:
                self.boxToPass = boxes[indexPath.row]
                self.performSegue(withIdentifier: "existingBox_SEGUE", sender: self)
                
            }
    }
        
    
        
       override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            
            itemIndexPath = indexPath as NSIndexPath?
            let boxToModify  = boxes[indexPath.row]
            let boxNumber = boxToModify.boxNumber
            //                    let itemKey = itemToModify.itemKey
            
            
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "\u{1F5d1}\n Delete", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
                
                let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to permanently delete: \(boxNumber)?", preferredStyle: .actionSheet)
                
                let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteItem)
                let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteItem)
                
                alert.addAction(DeleteAction)
                alert.addAction(CancelAction)
                
                
                self.present(alert, animated: true, completion: nil)
                
            })
            
            deleteAction.backgroundColor = UIColor.red
            
//            let addToBoxAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "\u{1f4e6}\n Box", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
//                let boxMenu = UIAlertController(title: nil, message: "Add Item to Box", preferredStyle: UIAlertControllerStyle.actionSheet)
//                let ScanAction = UIAlertAction(title: "Scan QR", style: .default, handler: self.scanForBox)
//                let PickAction = UIAlertAction(title: "Choose from List", style: .default, handler: self.pickForBox)
//                let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteItem)
//                boxMenu.addAction(ScanAction)
//                boxMenu.addAction(PickAction)
//                boxMenu.addAction(CancelAction)
//                
//                self.present(boxMenu, animated: true, completion: nil)
//            })
//            addToBoxAction.backgroundColor = UIColor.brown
            
            return [deleteAction ]
            
        }
        
        
        
        
        
        
        // Add To Box Method Confirmation and Handling
//        func addToBoxMethod(item: String) {
//            let alert = UIAlertController(title: "Add Item to Box", message: "Choose a method to locate the desired Box.", preferredStyle: .actionSheet)
//            
//            let ScanAction = UIAlertAction(title: "Scan QR", style: .default, handler: scanForBox)
//            let PickAction = UIAlertAction(title: "Choose from List", style: .default, handler: pickForBox)
//            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteItem)
//            
//            alert.addAction(ScanAction)
//            alert.addAction(PickAction)
//            alert.addAction(CancelAction)
//            
//            
//            self.present(alert, animated: true, completion: nil)
//        }
//        
    
        
    
        
        func handleDeleteItem(alertAction: UIAlertAction!) -> Void {
            print("IN THE DELETE FUNCTION")
            if let indexPath = itemIndexPath {
                
                tableView.beginUpdates()
                let boxObject  = boxes[indexPath.row]
                let boxKey = boxObject.boxKey
                self.REF_BOXES.child(boxKey!).removeValue()
                itemIndexPath = nil
                tableView.endUpdates()
                
            }
        }
        
    
        
        func cancelDeleteItem(alertAction: UIAlertAction!) {
            itemIndexPath = nil
        }
        
        
        func showAlertForRow(row: Int) {
            // add item to box by scanning or by picking a number from table view
            
//            let dict = boxes[row]
//            let boxNumber = dict.boxNumber
//            
//            
//            //ActionSheet to ask user to scan or choose
//            let alertController = UIAlertController(title: "Add \(item) to Box", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
//            
//            let qrScanAction = UIAlertAction(title: "Scan Box QR", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
//                print("Scan QR button tapped")
//                self.performSegue(withIdentifier: "toScanQR", sender: nil)
//                
//                
//            })
//            alertController.addAction(qrScanAction)
//            
//            let showBoxListAction = UIAlertAction(title: "Pick from List of Boxes", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
//                print("show List button tapped")
//                
//            })
//            alertController.addAction(showBoxListAction)
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert :UIAlertAction) in
//                print("Cancel button tapped")
//            })
//            alertController.addAction(cancelAction)
//            
//            present(alertController, animated: true, completion: nil)
        }
        
        
        
        
        
  
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("boxFeed prepareForSegue ")
 
            
            if segue.identifier == "existingBox_SEGUE" {
                print("existing Box _SEGUE ")
                
                if let destination = segue.destination as? BoxDetails {
                    destination.box = boxToPass
                    destination.boxIsNew = false
//                    print("Item to Pass is \(itemToPass.itemName)")
                }
            }
            
        }
    
    
}//itemFeedVC


