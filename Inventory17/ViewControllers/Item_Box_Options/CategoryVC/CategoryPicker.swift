//
//  CategoryPicker.swift
//  Inventory17
//
//  Created by Michael King on 2/15/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet

enum CategoryType:String {
    case category
    case subcategory
}


class CategoryPicker: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var passedCategory: String!
    var selectedCategory: Category!
    var categories = [Category]()
    var categoryType = CategoryType.category
    var categorySelection: CategorySelection = .item
    var categoryIndexPath: NSIndexPath? = nil
    
    
    
    
    
    var REF_CATEGORY: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPage()
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    
        
//        let defaults = UserDefaults.standard
//        
//        if (defaults.object(forKey: "CollectionIdRef") != nil) {
//            print("Category PIcker: Getting Defaults")
//            
//            if let collectionId = defaults.string(forKey: "CollectionIdRef") {
//                self.collectionID = collectionId
//            }
//        }
        
        self.REF_CATEGORY = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/categories/\(categoryType.rawValue)")
        
        loadDataFromFirebase()
        
    }// End ViewDidLoad

    func setupPage() {
        
        
        switch  categoryType {
        case .category:
            self.title = "Categories"

        case .subcategory:
            self.title = "Subcategories"

            
        }
        
        switch categorySelection {

        case .item:
         print("This is the ITEMS Category selection")
        case .box:
            print("This is the BOX Category selection")

        case .settings:
            if categoryType == .subcategory {
                tableView.allowsSelection = false
            }
            
        }
        
    }
    
    
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        switch categorySelection {
        case .item:
            self.performSegue(withIdentifier: "unwindCancelCategoryPicker", sender: self)
            
        case .box:
            self.performSegue(withIdentifier: "unwindToBoxDetailsCancel", sender: self)
            
        case .settings:
            self.performSegue(withIdentifier: "unwindCancelCategoryPicker", sender: self)

 
            
            
        }

        
    }
    
    
//    MARK: DNZ Empty Table View 
    
    
    
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
        let text = "Add your first item by tapping the + button."
        
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
        print( "Add First Item" )
        
        let text = "Add First Item"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
            NSForegroundColorAttributeName: view.tintColor
            ] as [String : Any]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        print("something tappped")
    }
    
    
    
//    MARK: TableView Setup
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("CALLING THE SEGUE CELL")
        self.selectedCategory = categories[indexPath.row]
        
        switch categorySelection {
        case .item:
            self.performSegue(withIdentifier: "unwindWithSelectedCategory", sender: self)

        case .box:
            self.performSegue(withIdentifier: "unwindToBoxDetailsWithCategory", sender: self)

        case .settings:
            self.performSegue(withIdentifier: "unwindWithSelectedCategory", sender: self)

          }
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tableView.backgroundView = nil
//        
//        
//        if categories.count > 0 {
//            
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//            return categories.count
//        } else {
//            
//            let emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height: 32))
//            emptyStateLabel.font = emptyStateLabel.font.withSize(14)
//            emptyStateLabel.text = "Click the ' + ' button to Choose a Category"
//            emptyStateLabel.textColor = UIColor.lightGray
//            emptyStateLabel.textAlignment = .center;
//            tableView.backgroundView = emptyStateLabel
//            
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        }
//        
//        return 0
        return categories.count
    }
    
    
    
    
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        self.performSegue(withIdentifier: "unwindWithSelectedLocation", sender: self)
    //
    //    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categories[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryPickerCell") as? CategoryPickerCell {
            cell.configureCell(category: category, categoryType: categoryType)
            
            
            return cell
        } else {
            return LocationPickerCell()
        }
    }
    
    
    
    
    // MARK: UITableViewDelegate Methods
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .delete {
            categoryIndexPath = indexPath
            let category  = categories[indexPath.row]
            if categoryType.rawValue == "category" {
                let categoriesToDelete = category.category
                confirmDelete(Item: categoriesToDelete!)
                
            } else {
                let categoriesToDelete = category.subcategory
                confirmDelete(Item: categoriesToDelete!)
                
            }
            
            
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
        
        categoryIndexPath = indexPath as NSIndexPath?
        let categoriesToDelete  = categories[indexPath.row]
        let categoryName = categoriesToDelete.category
        
        
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "\u{1F5d1}\n Delete", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to permanently delete: \(categoryName)?", preferredStyle: .actionSheet)
            
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
        let alert = UIAlertController(title: "Delete \(categoryType.rawValue.capitalized)", message: "Are you sure you want to permanently delete '\(Item)' ?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteItem)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteItem)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteItem(alertAction: UIAlertAction!) -> Void {
        if let indexPath = categoryIndexPath {
            
            tableView.beginUpdates()
            let category  = categories[indexPath.row]
            let categoryKey = category.categoryKey
            print("Cat Key is \(categoryKey)")
            self.REF_CATEGORY.child(categoryKey!).removeValue()
            categoryIndexPath = nil
            tableView.endUpdates()
            
        }
    }
    
    
    
    
    
    func cancelDeleteItem(alertAction: UIAlertAction!) {
        categoryIndexPath = nil
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    
    
    
    
    func showErrorAlert(title: String, msg: String) {
        let alertView = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
        
    }
    
    
    
    
    
    @IBAction func addNewCategory(sender: AnyObject) {
        
        var exampleText: String!
        
        switch categoryType {
            
        case .category:
            exampleText = "Holiday, Christmas, Kitchen, Outdoor"
        case .subcategory:
            exampleText = "Lights, Decorations, Glasses, Camping"
            
        }
        
        
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "New \(categoryType.rawValue.capitalized)",
            message: "Enter a name for this new \(categoryType.rawValue.capitalized)",
            preferredStyle: .alert)
        
        alertController!.addTextField(
            configurationHandler: {(textField: UITextField!) in
                textField.placeholder = exampleText
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
    
    
    
    
    
    func writeToFb(enteredText: String) {
        
        
        
        print("I'm in postToFirebase")
        
        let newCategoryTrimmed = enteredText.trimmingCharacters(in: NSCharacterSet.whitespaces).capitalized
        
        let category = [categoryType.rawValue : newCategoryTrimmed]
        
        
        //        let REF_LOCATION = DataService.ds.REF_BASE.child("/collections/\(self.collectionID!)/inventory/locations/\(locationType.rawValue)").childByAutoId()
        
        REF_CATEGORY.childByAutoId().setValue(category)
        
        //                self.dismiss(animated: true, completion: {})
        
    }
    
    
    
    func loadDataFromFirebase() {
        
        if categoryType == .subcategory {
            self.REF_CATEGORY = self.REF_CATEGORY.child(passedCategory!)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //         REF_STATUS.queryOrdered(byChild: "statusName").observe(.value, with: { snapshot in
        
        self.REF_CATEGORY.observe(.value, with: { snapshot in
            
            self.categories = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("Cat Snap: \(snap)")
                    
                    if let categoryDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let category = Category(categoryKey: key, dictionary: categoryDict)
                        self.categories.append(category)
                    }
                }
            }
            
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue from Category PIcker ")
        if let cell = sender as? UITableViewCell {
            print("sender as? UITableViewCell ")
            
            let indexPath = tableView.indexPath(for: cell)
            
            self.selectedCategory = categories[indexPath!.row]
            
            //            if segue.identifier == "unwindWithSelectedLocation" {
            //                print("saveLocationDetail SEGUE ")
            //
            //
            //                }
        }
        
    }
    
}


