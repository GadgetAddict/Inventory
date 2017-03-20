//
//  ColorTableVC.swift
//  Inventory17
//
//  Created by Michael King on 2/12/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit
import Firebase

enum ColorLoadsFrom:String {
    case box
    case item
    case settings
}

class ColorTableVC: UITableViewController {

    var segueId: String!
        var colors = [Color]()
         var colorLoadsFrom: ColorLoadsFrom = .box
        var selectedColor: Color?
        var colorIndexPath: NSIndexPath? = nil
        var collectionID: String!
         var REF_COLOR: FIRDatabaseReference!
        
        
        @IBAction func doneButton(sender: UIBarButtonItem) {
            //        self.dismiss(animated: true, completion: nil)
            _ = navigationController?.popViewController(animated: true)
            
        }
        
        @IBAction func addNewColor(sender: AnyObject) {
            
            var alertController:UIAlertController?
            alertController = UIAlertController(title: "New Color",
                                                message: "Enter a new color",
                                                preferredStyle: .alert)
            
            alertController!.addTextField(
                configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = "Enter new Color"
            })
            
            let action = UIAlertAction(title: "Submit",
                                       style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
                                        if let textFields = alertController?.textFields{
                                            let theTextFields = textFields as [UITextField]
                                            let enteredText = theTextFields[0].text
                                            //
                                            
                                            self!.writeToFb(enteredText: enteredText!)
                                            
                                        }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                
            }
            
            alertController?.addAction(action)
            alertController?.addAction(cancel)
            alertController!.view.setNeedsLayout()
            self.present(alertController!,
                         animated: true,
                         completion: nil)
        }
        
  
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.tableFooterView = UIView()
            tableView.tableFooterView = UIView(frame: CGRect.zero)
            
            switch colorLoadsFrom {
            case .box:
                print("BOX")
                self.segueId = "unwindToBoxDetailsWithColor"

            case .item:
                self.segueId = "unwind_saveColorToItemDetails"
            case .settings:
                tableView.allowsSelection = false
                
            }
            
            
            
            let defaults = UserDefaults.standard
            
            if (defaults.object(forKey: "CollectionIdRef") != nil) {
                print("Getting Defaults")
                
                if let collectionId = defaults.string(forKey: "CollectionIdRef") {
                    self.collectionID = collectionId
                }
            }
            
            loadDataFromFirebase()
            
            // End ViewDidLoad
            
        }
        
    
    
        
        func writeToFb(enteredText: String) {
            print("I'm in postToFirebase")
            
            let newColorTrimmed = enteredText.trimmingCharacters(in: NSCharacterSet.whitespaces)
            
            let color = ["colorName": newColorTrimmed.capitalized]
            
            
            let REF_COLOR = DataService.ds.REF_BASE.child("/collections/\(self.collectionID!)/inventory/colors").childByAutoId()
            
            REF_COLOR.setValue(color)
            
            //                self.dismiss(animated: true, completion: {})
            
        }
        
        
        
        
        func loadDataFromFirebase() {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            self.REF_COLOR = DataService.ds.REF_BASE.child("/collections/\(self.collectionID!)/inventory/colors")
            
            //         REF_STATUS.queryOrdered(byChild: "statusName").observe(.value, with: { snapshot in
            
            self.REF_COLOR.observe(.value, with: { snapshot in
                
                self.colors = []
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        print("ColorSnap: \(snap)")
                        
                        if let colorDict = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let color = Color(colorKey: key, dictionary: colorDict)
                                self.colors.append(color)
                         }
                    }
                }
                
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            })
        }
        
        
        // MARK: - Table view data source
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            tableView.backgroundView = nil
 
            if colors.count > 0 {
                
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                return colors.count
            } else {
                
                let emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height: 32))
                emptyStateLabel.font = emptyStateLabel.font.withSize(14)
                emptyStateLabel.text = "Tap '+' to Begin adding Colors"
                emptyStateLabel.textAlignment = .center;
                tableView.backgroundView = emptyStateLabel
                
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }
            
            return 0
    }
    
    
      
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let color = colors[indexPath.row]
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell") as? ColorCell {
                cell.configureCell(color: color)
                
                
                return cell
            } else {
                return ColorCell()
            }
        }
        
        
        
        
        // MARK: UITableViewDelegate Methods
        func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .delete {
                colorIndexPath = indexPath
                let color  = colors[indexPath.row]
                let colorsToDelete = color.colorName
                confirmDelete(Item: colorsToDelete!)
            } else {
                if editingStyle == .insert {
                    tableView.beginUpdates()
                    
                    //                tableView.insertRowsAtIndexPaths([
                    //                    NSIndexPath(forRow: statuses.count-1, inSection: 0)
                    //                    ], withRowAnimation: .Automatic)
                    //
                    tableView.endUpdates()
                }
            }
        }
        
        
        func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
            
          colorIndexPath = indexPath as NSIndexPath?
            let colorsToDelete  = colors[indexPath.row]
            let colorName = colorsToDelete.colorName
            
            
            
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "\u{1F5d1}\n Delete", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
                
                let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to permanently delete: \(colorName)?", preferredStyle: .actionSheet)
                
                let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteItem)
                let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteItem)
                
                alert.addAction(DeleteAction)
                alert.addAction(CancelAction)
                
                
                self.present(alert, animated: true, completion: nil)
                
            })
            
            deleteAction.backgroundColor = UIColor.red
            
            return [deleteAction]
        }
        
        func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        
        // Delete Confirmation and Handling
        func confirmDelete(Item: String) {
            let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to permanently delete '\(Item)' ?", preferredStyle: .actionSheet)
            
            let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteItem)
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteItem)
            
            alert.addAction(DeleteAction)
            alert.addAction(CancelAction)
            
            
            self.present(alert, animated: true, completion: nil)
        }
        
        func handleDeleteItem(alertAction: UIAlertAction!) -> Void {
            if let indexPath = colorIndexPath {
                
                tableView.beginUpdates()
                let color  = colors[indexPath.row]
                let colorKey = color.colorKey
                print("Color Key is \(colorKey)")
                self.REF_COLOR.child(colorKey!).removeValue()
                colorIndexPath = nil
                tableView.endUpdates()
                
            }
        }
        
        
        
        
        
        func cancelDeleteItem(alertAction: UIAlertAction!) {
           colorIndexPath = nil
        }
        
        func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            // the cells you would like the actions to appear needs to be editable
            return true
        }
        
        
        
        override  func tableView(_ tableView: UITableView, didSelectRowAt
            indexPath: IndexPath){
            print("CALLING THE SEGUE CELL")
            self.selectedColor = colors[indexPath.row]
            
            self.performSegue(withIdentifier: self.segueId , sender: self)
        }
        
        func showErrorAlert(title: String, msg: String) {
            let alertView = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertView, animated: true, completion: nil)
            
        }
        
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
    
}  //End Class

