//
//  boxStatusTableVC.swift
//  Inventory
//
//  Created by Michael King on 7/25/16.
//  Copyright © 2016 Michael King. All rights reserved.
//


import UIKit
import Firebase
import DZNEmptyDataSet

class BoxStatusTableVC: UITableViewController, UINavigationControllerDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    
    var statuses = [Status]()
    var fromSettings: Bool = false
    
    var selecteStatus: Status?
    var statusIndexPath: NSIndexPath? = nil
    var REF_STATUS: FIRDatabaseReference!
    
    
 
    
    @IBAction func addNewStatus(sender: AnyObject) {
        createNewStatus()
    }
    
    
    func createNewStatus(){
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "New Status",
                                            message: "Enter a new status",
                                            preferredStyle: .alert)
        
        alertController!.addTextField(
            configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Example: Empty, Packed, Stored"
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
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        if fromSettings == true {
            tableView.allowsSelection = false
        }
        
        
//        let defaults = UserDefaults.standard
//        
//        if (defaults.object(forKey: "CollectionIdRef") != nil) {
//            print("Getting Defaults")
//            
//            if let collectionId = defaults.string(forKey: "CollectionIdRef") {
//                COLLECTION_ID = collectionId
//            }
//        }
        
        loadDataFromFirebase()
        
        // End ViewDidLoad
        
    }
    
    
    
    
    func writeToFb(enteredText: String) {
        print("I'm in Status postToFirebase")
        
        let newStatusTrimmed = enteredText.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        let status = ["statusName": newStatusTrimmed.capitalized]
        
        
        self.REF_STATUS = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/status").childByAutoId()
        
        REF_STATUS.setValue(status)
        
        //                self.dismiss(animated: true, completion: {})
        
    }
    
    
    
    
    func loadDataFromFirebase() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.REF_STATUS = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/status")
        
        //         REF_STATUS.queryOrdered(byChild: "statusName").observe(.value, with: { snapshot in
        
        self.REF_STATUS.observe(.value, with: { snapshot in
            
            self.statuses = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("StatusSnap: \(snap)")
                    
                    if let statusDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let status = Status(statusKey: key, dictionary: statusDict)
                        self.statuses.append(status)
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
 
            return statuses.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let status = statuses[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell") as? StatusCell {
            cell.configureCell(status: status)
            
            
            return cell
        } else {
            return StatusCell()
        }
    }
    
    
    
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "package")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Create a list of statuses"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Add a new status tapping the + button."
        
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
        
        let text = "Create your first Status"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
            NSForegroundColorAttributeName: view.tintColor
            ] as [String : Any]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        createNewStatus()
    }
    
 
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
  
        
        statusIndexPath = indexPath as NSIndexPath?
        let statusesToDelete  = statuses[indexPath.row]
        let statusName = statusesToDelete.statusName
        
        
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "\u{1F5d1}\n Delete", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to permanently delete: \(statusName)?", preferredStyle: .actionSheet)
            
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
        if let indexPath = statusIndexPath {
            
            tableView.beginUpdates()
            let status  = statuses[indexPath.row]
            let statusKey = status.statusKey
            print("Status Key is \(statusKey)")
            self.REF_STATUS.child(statusKey!).removeValue()
            statusIndexPath = nil
            tableView.endUpdates()
            
        }
    }
    
    
    
    
    
    func cancelDeleteItem(alertAction: UIAlertAction!) {
        statusIndexPath = nil
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        print("CALLING THE SEGUE CELL")
        self.selecteStatus = statuses[indexPath.row]
        
        self.performSegue(withIdentifier: "unwindToBoxDetailsWithStatus", sender: self)
        
    }
    
    
    func showErrorAlert(title: String, msg: String) {
        let alertView = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
        
    }
    
    
    
}





















//
//    var fromSettings: Bool = false
//
//    var statusArray = [String]()
//    var selectedStatus: String!
//    var statusIndexPath: NSIndexPath? = nil
//    var collectionID: String!
//    var itemIndexPath: NSIndexPath? = nil
//    var REF_STATUS: FIRDatabaseReference!
//
//    var statuses = [Status]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if fromSettings == true {
//            tableView.allowsSelection = false
//
//        } else {
//            tableView.allowsSelection = true
//
//        }
//
////        self.navigationController?.navigationBar.tintColor = UIColor.white
//
//        tableView.tableFooterView = UIView()
//        tableView.tableFooterView = UIView(frame: CGRect.zero)
//
//
//        let defaults = UserDefaults.standard
//
//        if (defaults.object(forKey: "CollectionIdRef") != nil) {
////            print("Getting Defaults")
//            
//            if let collectionId = defaults.string(forKey: "CollectionIdRef") {
//                COLLECTION_ID = collectionId
//            }
//        }
//        
//        loadDataFromFirebase()
//        
//        // End ViewDidLoad
//        
//    }
//   
//    
////        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////            selectedStatus = statusArray[indexPath.row]
////
////            self.performSegue(withIdentifier: "unwindToBoxDetailsWithStatus:", sender: self)
////    
////        }
//    
//    
//    
//    @IBAction func doneButton(sender: UIBarButtonItem) {
////        self.dismiss(animated: true, completion: nil)
//                    _ = navigationController?.popViewController(animated: true)
//
//    }
//    
//    @IBAction func addNewStatus(sender: AnyObject) {
//        
//            var alertController:UIAlertController?
//            alertController = UIAlertController(title: "New Status",
//                                                message: "Enter text below",
//                                                preferredStyle: .alert)
//            
//        alertController!.addTextField(
//            configurationHandler: {(textField: UITextField!) in
//                    textField.placeholder = "Example: Empty, Packed, Stored"
//            })
//            
//            let action = UIAlertAction(title: "Submit",
//                               style: UIAlertActionStyle.default,
//                               handler: {[weak self]
//                                (paramAction:UIAlertAction!) in
//                                if let textFields = alertController?.textFields{
//                                    let theTextFields = textFields as [UITextField]
//                                    let enteredText = theTextFields[0].text
////
//                                    
//                                    self!.writeToFb(enteredText: enteredText!)
//                                            
//                                        }
//                })
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
//
//        }
//        
//                alertController?.addAction(action)
//                alertController?.addAction(cancel)
//                alertController!.view.setNeedsLayout()
//            self.present(alertController!,
//                                       animated: true,
//                                       completion: nil)
//        }
//    
//  
//    
//
//    
//    func writeToFb(enteredText: String) {
////              print("I'm in postToFirebase")
//        
//        let newStatusTrimmed = enteredText.trimmingCharacters(in: NSCharacterSet.whitespaces)
//
//        let status = ["statusName": newStatusTrimmed]
//
//        
//        let REF_STATUS = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/status").childByAutoId()
//        
//            REF_STATUS.setValue(status)
//            
//            //                self.dismiss(animated: true, completion: {})
//        
//        }
//    
//    
//    
//    
//    func loadDataFromFirebase() {
//         UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        
//         self.REF_STATUS = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/status")
//
////         REF_STATUS.queryOrdered(byChild: "statusName").observe(.value, with: { snapshot in
//        
//           self.REF_STATUS.observe(.value, with: { snapshot in
//            
//            self.statuses = []
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap in snapshots {
////                    print("statusSnap: \(snap)")
//                    
//                    if let statusDict = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let stat = Status(statusKey: key, dictionary: statusDict)
//                      self.statuses.append(stat)
////                        self.statusArray.append(stat.statusName!)
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
//    // MARK: - Table view data source
//    
//     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // the cells you would like the actions to appear needs to be editable
//        return true
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//      
//        tableView.backgroundView = nil
//
//        
//        if statuses.count > 0 {
//            
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//            return statuses.count
//            
//        } else {
//            
//            let emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height: 32))
//            emptyStateLabel.font = emptyStateLabel.font.withSize(14)
//            emptyStateLabel.text = "Tap '+' to Create your first Box Status. ie: Empty, Packed, Stored"
//            emptyStateLabel.textColor = UIColor.lightGray
//            emptyStateLabel.textAlignment = .center;
//            tableView.backgroundView = emptyStateLabel
//            
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        }
//        
//        return 0
//    }
//
// 
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let status = statuses[indexPath.row]
//        
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell") as? StatusCell {
//            cell.configureCell(status: status)
//            
//    
//            return cell
//        } else {
//            return StatusCell()
//        }
//    }
//
//
//    
//    
//    // MARK: UITableViewDelegate Methods
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .delete {
//            statusIndexPath = indexPath
//            let status  = statuses[indexPath.row]
//            let statusToDelete = status.statusName
//             confirmDelete(Item: statusToDelete!)
//        } else {
//            if editingStyle == .insert {
//                tableView.beginUpdates()
//
//               
//                tableView.endUpdates()
//            }
//    }
//    }
//    
//    
//     func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        
//        itemIndexPath = indexPath as NSIndexPath?
//        let statusTodelete  = statuses[indexPath.row]
//        let statusName = statusTodelete.statusName
//
//        
//        
//        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "\u{1F5d1}\n Delete", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
//            
//            let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to permanently delete: \(statusName)?", preferredStyle: .actionSheet)
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
//    
////     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
////        cell.separatorInset = UIEdgeInsets.zero
////        cell.layoutMargins = UIEdgeInsets.zero
////    }
//    
    
    // Delete Confirmation and Handling
//    func confirmDelete(Item: String) {
//        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to permanently delete '\(Item)' ?", preferredStyle: .actionSheet)
//        
//        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteItem)
//        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteItem)
//        
//        alert.addAction(DeleteAction)
//        alert.addAction(CancelAction)
//        
//     
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    
//    func handleDeleteItem(alertAction: UIAlertAction!) -> Void {
//        if let indexPath = statusIndexPath {
//            
//            tableView.beginUpdates()
//            let status  = statuses[indexPath.row]
//            let statusKey = status.statusKey
////            print("Status Key is \(statusKey)")
//            self.REF_STATUS.child(statusKey!).removeValue()
//            statusIndexPath = nil
//            tableView.endUpdates()
//            
//        }
//    }
//    
//    func cancelDeleteItem(alertAction: UIAlertAction!) {
//        statusIndexPath = nil
//    }
//
//    
//
//    
 
    
    
    
    
    //        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    ////
    ////            //Other row is selected - need to deselect it
    //            if let index = selectedColorIndex {
    //                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
    //                cell?.accessoryType = .None
    //            }
    //
    //            selectedColor = tags[indexPath.row]
    //
    //            //update the checkmark for the current row
    //            let cell = tableView.cellForRowAtIndexPath(indexPath)
    //            cell?.accessoryType = .Checkmark
    //        }
    
//    
//    func showErrorAlert(title: String, msg: String) {
//        let alertView = UIAlertController(title: title, message: msg, preferredStyle: .alert)
//        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        present(alertView, animated: true, completion: nil)
//        
//    }
//    
    
//     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "statusUnwind" {
//            if let cell = sender as? UITableViewCell {
//                let indexPath = tableView.indexPath(for: cell)
//                if let index = indexPath?.row {
//                    
//                      let status = statuses[index]
//                        self.selectedStatus  = status.statusName
//                }
//            }
//        }
//    }
    
    
 
