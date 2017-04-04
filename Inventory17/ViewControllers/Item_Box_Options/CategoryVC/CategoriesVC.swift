//
//  CategoriesVC.swift
//  Inventory17
//
//  Created by Michael King on 2/15/17.
//  Copyright © 2017 Microideas. All rights reserved.
//


import UIKit
import Firebase

class CategoriesVC: UITableViewController {
    
    var categories = [Category]()
    var collectionID: String!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.allowsSelection = false
       
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

 



func loadDataFromFirebase() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    let REF_CATS = DataService.ds.REF_BASE.child("/collections/\(self.collectionID!)/inventory/colors")
    
    //         REF_STATUS.queryOrdered(byChild: "statusName").observe(.value, with: { snapshot in
    
        REF_CATS.observe(.value, with: { snapshot in
        
        self.categories = []
        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
            for snap in snapshots {
                print("CatsSnap: \(snap)")
                
                if let catDict = snap.value as? Dictionary<String, AnyObject> {
                    let key = snap.key
                    let cats = Category(categoryKey: key, dictionary: catDict)
                    self.categories.append(cats)
                }
            }
        }
        
        self.tableView.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    })
}


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = nil
        
         if categories.count > 0 {
             self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            return categories.count
        } else {
            
            let emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height: 32))
            emptyStateLabel.font = emptyStateLabel.font.withSize(14)
            emptyStateLabel.text = "Click the ' + ' button to Choose a Category"
            emptyStateLabel.textColor = UIColor.lightGray
            emptyStateLabel.textAlignment = .center;
            tableView.backgroundView = emptyStateLabel
            
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath)
                as! CategoriesCell
            
            let category = categories[indexPath.row] as Category
            cell.category = category
            return cell
    }
    
    
//    MARK  Navigation
    
//    override  func tableView(_ tableView: UITableView, didSelectRowAt
//        indexPath: IndexPath){
//        print("CALLING THE SEGUE CELL")
//            self.categoryToUse = categories[indexPath.row]
//
//        self.performSegue(withIdentifier: "unwind_saveCategoryToItemDetails", sender: self)
//        
//    }
 

//    // Mark Unwind Segues
//    @IBAction func unwind_cancelToCategoriesVC(_ segue:UIStoryboardSegue) {
//    }
//    
//    @IBAction func unwind_saveCategoryDetail(_ segue:UIStoryboardSegue) {
//        if let categoryDetailsVC = segue.source as? CategoryDetailsVC {
//            
//            
//            //add the new location to the  array
//            if let category = categoryDetailsVC.category {
//                categories.append(category)
//                
//                //update the tableView
//                let indexPath = IndexPath(row: categories.count-1, section: 0)
//                tableView.insertRows(at: [indexPath], with: .automatic)
//            }
//            
//        }
//        
//    }
//    
 
}
