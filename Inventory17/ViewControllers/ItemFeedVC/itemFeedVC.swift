

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
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredItems = [Item]()

    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var REF_ITEMS: FIRDatabaseReference!
    var items = [Item]()
    
    lazy var itemIndexPath: NSIndexPath? = nil
    var selectedItem: Item?
    
    var itemIsBoxed: Bool!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ItemFeed: removeAllObservers")
        self.REF_ITEMS.removeAllObservers()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems()

               
      }
    
    override func viewDidLoad() {
     super.viewDidLoad()
   
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Name", "Category"]
        tableView.tableHeaderView = searchController.searchBar

        

        self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/items")
      
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.tableView.emptyDataSetSource = self
       self.tableView.emptyDataSetDelegate = self

        
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
        let _ = EZLoadingActivity.show("Loading Items", disableUI: true)

        print("in Function loadItems")
        
//        DispatchQueue.main.async {
      
        
//        let queue1 = DispatchQueue(label: "com.michael.loadFB", qos: DispatchQoS.userInitiated)

//        queue1.async {
        
        
        self.REF_ITEMS?.observe(.value, with: {(snapshot)  in
            self.items = [] // THIS IS THE NEW LINE
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("ITEM FEED SNAP: \(snap)")
                    if let itemDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Item(itemKey: key, dictionary: itemDict)
                            self.items.append(item)
                    }
                }
            }
            let _ = EZLoadingActivity.hide()
            self.tableView.reloadData()
        })
// }
    }
    
    
    
 
  
    
        func cancelButtonTapped(){
        _ = navigationController?.popViewController(animated: true)
        
        }
    
 
 
    
        func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
            var image: String!
            if searchController.isActive {
                image = ""
            } else {
                image = "package"
            }
            return UIImage(named: image)

    }
    
        func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
            var text: String!
            
            if searchController.isActive {
                text = "No Items Found"

            } else {
                text = "You Have No Items"

            }
            
            let attribs = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
                NSForegroundColorAttributeName: UIColor.darkGray
            ]
    
            return NSAttributedString(string: text, attributes: attribs)
        }
    
   
    
        func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
     
            var text: String!
            
            if searchController.isActive {
                text = "Search by Name or Category to find an item."
                
            } else {
                text = "Add Items By Tapping the + Button"
                
            }
            
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
            
            var text: String!

            if searchController.isActive {
                text = ""
            
                
            } else {
                text = "Add Your First Item"
                
            }
            
                let attribs = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
                NSForegroundColorAttributeName: view.tintColor
            ] as [String : Any]
    
            return NSAttributedString(string: text, attributes: attribs)
        }
    
        
        func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
         self.performSegue(withIdentifier: "newItem_SEGUE", sender: self)
        }

    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredItems.count
        }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell {
        let item: Item
        if searchController.isActive && searchController.searchBar.text != "" {
            item = filteredItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }
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

 
    
    func filterContentForSearchText(_ searchText: String, scope: String = "Name") {
        
        filteredItems = items.filter({( item : Item) -> Bool in
            var searchedItem: String!
            var categoryMatch: Bool!
            switch scope {
            case "Name":
                categoryMatch = (scope == "Name") || (item.itemName == scope)
                searchedItem = item.itemName
            case "Category":
                categoryMatch = (scope == "Category") || (item.itemCategory == scope)
                searchedItem = item.itemCategory
                
            default:
                categoryMatch = (scope == "Name") || (item.itemName == scope)
                searchedItem = item.itemName
                
            }
            
            
            print("Category match is \(categoryMatch)")
            print("SCOPE  is \(scope)")
            
            
            
            let result = categoryMatch && searchedItem.lowercased().contains(searchText.lowercased())
            return result
        })
        tableView.reloadData()
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
            print("Function: scanForBox line 399")
  
    
            self.performSegue(withIdentifier: "toScanQR", sender: nil)
    
        }
    
        func pickForBox(alertAction: UIAlertAction) -> Void {
            print("Function: pickForBox line 406")
            // If ITem is already boxed - warn to remove first 
            
            
            // should it remove first and then segue or  unwind and remove/re-add same time ?
            
            
            
            // prepare for segue passes the selected item to the box list - then boxfeed-unwind passes item back
            self.performSegue(withIdentifier: "showBoxList", sender: nil)
            
    }
 
/*     func showAlertForRow(row: Int) {
          // add item to box by scanning or by picking a number from table view
    
             let dict = items[row]
            let item = dict.itemName
    
            //ActionSheet to ask user to scan or choose
           let alertController = UIAlertController(title: "Add \(item) to Box", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
    
          let qrScanAction = UIAlertAction(title: "Scan Box QR", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
               print("Scan QR button tapped")
//            MARK: can segue right from here or run function
//                self.performSegue(withIdentifier: "toScanQR", sender: nil)
                   self.pickForBox()
    
           })
           alertController.addAction(qrScanAction)
          let showBoxListAction = UIAlertAction(title: "Pick from List of Boxes", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
              print("show List button tapped")
//              self.performSegue(withIdentifier: "showBoxList", sender: nil)
    
           })
          alertController.addAction(showBoxListAction)
    
          let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert :UIAlertAction) in
              print("Cancel button tapped")
         })
         alertController.addAction(cancelAction)
    
           present(alertController, animated: true, completion: nil)
       }
   */
     
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
    
//    MARK: Unwind Box Select
    @IBAction func unwindToItemsFromBoxSel(_ segue:UIStoryboardSegue) {
        if let boxFeedViewController = segue.source as? BoxFeedVC {

            if let selectedBox = boxFeedViewController.boxToPass{
                let boxKey = selectedBox.boxKey
                let boxNumber = selectedBox.boxNumber
            
            if let itemToBox = boxFeedViewController.itemPassed {
                let itemKey = itemToBox.itemKey
                let itemName = itemToBox.itemName
            
                let REF_BOX = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/boxes/\(boxKey!)/items/\(itemKey!)")
                
                let REF_ITEM = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/items/\(itemKey!)/")
                
                let boxSelectedDict: Dictionary<String, AnyObject> =
                    ["itemBoxKey" : boxKey! as AnyObject,
                     "itemIsBoxed" : true as AnyObject,
                    "itemBoxNumber": boxNumber as AnyObject ]
                
                let itemDict: Dictionary<String, String> =
                    ["itemName" : itemName]
                
                print("Adding item to box")

                REF_BOX.setValue(itemDict)
                REF_ITEM.updateChildValues(boxSelectedDict)

                }}}
         }
 
  
    
}//itemFeedVC


extension itemFeedVC: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension itemFeedVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

