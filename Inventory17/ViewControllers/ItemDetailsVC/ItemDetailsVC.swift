//
//  NewItemVC.swift
//  Inventory17
//
//  Created by Michael King on 1/20/17.
//  Copyright © 2017 Microideas. All rights reserved.
//


import UIKit
import Firebase
import ExpandingMenu

enum ItemType {
    case new
    case existing
    case boxItem
}

class ItemDetailsVC: UITableViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate {
    
    var itemType: ItemType = .new
    var passedItem: Item?
    var boxItemKey: String?
    var boxSelectedForItem: Box?
    var newItem: Item!
    var REF_ITEMS = DataService.ds.REF_BASE
    var collectionId: String!
    var imageChanged: Bool! = false
    var fragileStatus: Bool = false

    @IBOutlet weak var boxDetailsTableCell: UITableViewCell!
    @IBOutlet weak var fragileSwitch: SevenSwitch!
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var itemCategory: UILabel!
    @IBOutlet weak var itemSubCategory: UILabel!
    @IBOutlet weak var itemColor: UILabel!
    @IBOutlet weak var itemQty: UITextField!
    @IBOutlet weak var boxNumberHeaderLabel: UILabel!
    @IBOutlet weak var boxDetails: UILabel!
   
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        configureExpandingMenuButton()
    
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        createNumPadToolbar()
      
        let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)

        switch itemType {
 
        case .boxItem:
            print("itemType is boxItem")
            
            boxDetailsTableCell.isHidden = false
            boxDetailsTableCell.isUserInteractionEnabled = true

            self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/items/\(boxItemKey!)")
                  
            loadBoxItem()
            
        case .existing:
            print("itemType is existing")
           

            if let key = self.passedItem?.itemKey{
                 self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/items/\(key)")
            }
          
            concurrentQueue.async {

            self.loadPassedItem()
            self.downloadImageUserFromFirebase(item:self.passedItem!)

            
            }

            concurrentQueue.async {
                
             }
            
            
            print("loadPassedItem \(self.REF_ITEMS)")

        case .new:
            print("itemType is new")
            boxDetailsTableCell.isHidden = true
            boxDetailsTableCell.isUserInteractionEnabled = false
            
            self.title = "New Item"
               self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/items/")
         }
     
        
    
        // Image Picker Setup 
        picker.delegate = self
        myImageView.layer.borderWidth = 2.0
        myImageView.layer.borderColor = UIColor.white.cgColor
        myImageView.layer.cornerRadius = myImageView.frame.height / 2.0
        myImageView.clipsToBounds = true
        
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        

        blurredImage.addSubview(blurEffectView)
        blurredImage.clipsToBounds = true
       
       
    }   // END VIEW DID LOAD
    
 
 
    
//    MARK: Fragile
    
    @IBAction func fragileSwitchTapped(_ sender: SevenSwitch) {
        if fragileSwitch.isOn()  {
            fragileStatus = true
        } else {
            fragileStatus = false
        }
    
    }
 
    
    
    
//    MARK:  Qty
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func qty_textField_action(_ sender: AnyObject) {
        self.resignFirstResponder()
    }
    
    @IBAction func stepperAction(_ sender: AnyObject) {
        qtyValue = (Int(stepper.value))
        itemQty.text = "\(qtyValue!)"
    }
    
    var qtyValue:Int? {
        didSet {
            if qtyValue != nil {
                self.stepper.value = Double(qtyValue!)
            }
        }
    }
    
    @IBAction func textEditingEnded(_ sender: AnyObject) {
        self.qtyValue = Int(itemQty.text!)
    }
    
    
    
//    MARK: Image/Camera
    
   func pickImage() {
        
        //ActionSheet to ask user to scan or choose
        let alertController = UIAlertController(title: "Choose Image for item", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let camera = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
            print("Open the camera ")
            self.shootPhoto()
        })
        
        
        alertController.addAction(camera)
        
        let photoAlbum = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction) in
            print("pick from photos")
            self.photoFromLibrary()
        })
        
        alertController.addAction(photoAlbum)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert :UIAlertAction) in
            print("Cancel button tapped")
        })
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    let picker = UIImagePickerController()
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var blurredImage: UIImageView!
    
    func photoFromLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        //        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    func shootPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    //MARK: - Image  Delegates
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        myImageView.contentMode = .scaleAspectFill //3
        myImageView.image = chosenImage //4
        blurredImage.image = chosenImage //4
        imageChanged = true
        dismiss(animated:true, completion: nil) //5
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //    MARK: Keyboard Text Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func createNumPadToolbar(){
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ItemDetailsVC.doneButtonAction))
        
        //array of BarButtonItems
        var arr = [UIBarButtonItem]()
        arr.append(flexSpace)
        arr.append(doneBtn)
        toolbar.setItems(arr, animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.itemQty.inputAccessoryView = toolbar
     }
    
    func doneButtonAction(){
        self.view.endEditing(true)
    
    }
    
    func loadBoxItem(){
 
            self.REF_ITEMS.observeSingleEvent(of: .value, with: { (snapshot) in
       
            if let itemDict = snapshot.value as? NSDictionary {
               let key = snapshot.key

                self.passedItem = Item(itemKey: key, dictionary: itemDict as! Dictionary<String, AnyObject>)
                
                self.title = self.passedItem?.itemName
               print("item: \(self.passedItem?.itemKey)")
                    }
                        self.loadPassedItem()
            }) { (error) in
                print(error.localizedDescription)
        }
 
    }

 
        
        //here we are initializing it as a property of the class
    
        func xxxdownloadImageUserFromFirebase(item: Item) {
            
            if let itemImageURL = item.itemImgUrl {
            
            let ref = FIRStorage.storage().reference(forURL: itemImageURL)

//            let reference: FIRStorageReference = storage.reference(forURL: itemImageURL)
            ref.downloadURL { (url, error) in
                //using a guard statement to unwrap the url and check for error
                guard let imageURL = url, error == nil  else {
                    //handle error here if returned url is bad or there is error
                    return
                }
                guard let data = NSData(contentsOf: imageURL) else {
                    //same thing here, handle failed data download
                    return
                }
                let image = UIImage(data: data as Data)
                self.myImageView.image = image
                self.blurredImage.image = image
                }
            }
        }
        
    

    func downloadImageUserFromFirebase(item: Item){
//        if let img = itemFeedVC.imageCache.object(forKey: item.itemImgUrl as NSString) {

        if let itemImageURL = item.itemImgUrl {
            
        
                let ref = FIRStorage.storage().reference(forURL: itemImageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("MK: Unable to download image from Firebase storage")
                    } else {
                        print("MK: Image downloaded from Firebase storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.myImageView.image = img
                                self.blurredImage.image = img
//                                itemFeedVC.imageCache.setObject(img, forKey: item.itemImgUrl as NSString)
                            }
                        }
                    }
                })
            }
    }
    
   
    func loadPassedItem() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        print("LOADING ITEM")
        if let item = passedItem {
//            DispatchQueue.main.async {
            boxDetailsTableCell.isHidden = !item.itemIsBoxed
            boxDetailsTableCell.isUserInteractionEnabled = item.itemIsBoxed
            
//            self.downloadImageUserFromFirebase(item: item)
//            loadImage(item: item)
//            }
            self.title = item.itemName

            itemNameField.text = item.itemName

            itemCategory.text = item.itemCategory
            itemSubCategory.text = item.itemSubcategory
            itemColor.text = item.itemColor
            
            if let qty = item.itemQty {
                itemQty.text = "\(qty)"
            } else {
                itemQty.text = "?"
            }
            
             fragileStatus = item.itemFragile
                if fragileStatus == true {
                fragileSwitch.setOn(true, animated: true)
                
                 } else {
                    fragileSwitch.setOn(false, animated: true)
                }
            
            if let itemsBoxKey = item.itemBoxKey {
                print("Item is Boxed")
                let boxKey = String(itemsBoxKey)
                boxNumberHeaderLabel.text = "BOX NUMBER \(item.itemBoxNum!)"
                getBoxDetails(boxKey: boxKey!)

            } else {
                print("Item is NOTTT Boxed")
                boxNumberHeaderLabel.text = "Not in Box"
                
            
            }
         UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.configureExpandingMenuButton()

        }
    }
    
        func getBoxDetails(boxKey:String)  {
    // get box location 10982207658
    }
    
    
        func addItemToBox(itemKey:String)  {
            
//            If item already boxex, remove it
            
            
            
            
//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: yourArray.count-1, section: 0)], with: .automatic)
//        tableView.endUpdates()
//    
//            or
//        or 
//        refreshControl.endRefreshing()
//        testArray.add("Test \(self.testArray.count + 1)")
//        
//        let indexPath:IndexPath = IndexPath(row:(self.testArray.count - 1), section:0)
//        self.tableView.insertRows(at:[indexPath], with: .left)
//        NSLog("Added a new cell to the bottom!")
//        
//        var IndexPathOfLastRow = NSIndexPath(forRow: self.array.count - 1, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([IndexPathOfLastRow], withRowAnimation: UITableViewRowAnimation.Left)

        }

    

    @IBAction func saveItemTapped(_ sender: UIBarButtonItem) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        checkForEmptyFields()
        
    }
    
    func checkForEmptyFields() {
        let _ = EZLoadingActivity.show("Saving", disableUI: true)

        guard  itemNameField.text != "" else {
            let errMsg = "Item name is Required "
            newItemErrorAlert("Ut oh...", message: errMsg)
            return
        }
        
    
        self.checkForImage()
        
    }
    
    
    
    func checkForImage() {
        print("MK:checkForImage")

        if let imgData = UIImageJPEGRepresentation(myImageView.image!, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            
            
            DataService.ds.REF_ITEM_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("MK: Unable to upload image to Firebasee storage")
  
                } else {
                    
                    var url: String!
                    
                    switch self.imageChanged {
                    case true:
                          url = metadata?.downloadURL()?.absoluteString

                    case false:
                          url = nil
                    default:
                        print(" Shizzle")
                    }
                    
                     
//                    let url = metadata?.downloadURL()?.absoluteString
//                    if let url = downloadURL {
                        
                        if self.itemType == .new {
                            print("MK: Goto self.posttoFB")

                        self.postToFirebase(imgUrl: url)
                        
                         } else {
                            print("MK: Goto self.udpateFB")

                        self.updateFirebaseData(imgUrl: url)
                           
                    }
                }
            }
        }
    }
    
    
    
    func postToFirebase(imgUrl: String?) {
        print("I'm in postToFirebase")

        var qtyStr: String
        
        if let qty = qtyValue {
            qtyStr = "\(qty)"
        } else {
            qtyStr = "1"
        }
        
        let newItem = Item(itemName: (itemNameField.text?.capitalized)!, itemCat: (itemCategory.text?.capitalized)!, itemSubcat: (itemSubCategory.text?.capitalized)!, itemColor: itemColor.text?.capitalized)
        
        
        print("NEW ITEM is \(newItem.itemName)")

        
        
        let itemDict: Dictionary<String, AnyObject> = [
            "itemName" :  newItem.itemName as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "itemCategory" : newItem.itemCategory as AnyObject,
            "itemSubcategory" : newItem.itemSubcategory as AnyObject,
            "itemQty" : qtyStr as AnyObject ,
            "itemFragile" : fragileStatus as AnyObject,
            "itemColor": newItem.itemColor as AnyObject,
            "itemIsBoxed" : false as AnyObject
        ]
        
                self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/items").childByAutoId()

                self.REF_ITEMS.setValue(itemDict)

        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let _ = EZLoadingActivity.hide(success: true, animated: true)
        popViewController()
    
    }
    
 
    func updateFirebaseData(imgUrl: String?) {
 
        
        if let boxDetailsToSave = self.boxSelectedForItem{
//            saveBoxDetails()
        }

        let existingItem = Item(itemName: (itemNameField.text?.capitalized)!, itemCat: (itemCategory.text?.capitalized)!, itemSubcat: (itemSubCategory.text?.capitalized)!, itemColor: itemColor.text?.capitalized)
      
        print("MK: updateChild Values")

        self.REF_ITEMS.updateChildValues([
             "itemName" :  existingItem.itemName as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "itemCategory" : existingItem.itemCategory as AnyObject,
            "itemSubcategory" : existingItem.itemSubcategory as AnyObject,
            "itemQty" : itemQty.text! as AnyObject ,
            "itemFragile" : fragileStatus as AnyObject,
            "itemColor": existingItem.itemColor as AnyObject
            ])
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let _ = EZLoadingActivity.hide(success: true, animated: true)
        popViewController()

    }
    
    func popViewController(){
        _ = navigationController?.popViewController(animated: true)

    }
    
    /*
    func saveBoxDetails() {
//        Item was added to box - save details to Item and Box in Firebase
        
        let REF_BOX = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/boxes/\(self.selectedBox.boxKey!)/items/\(self.passedItem.itemKey!)")

            let REF_ITEM = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/items/\(self.passedItem.itemKey!)/")

            let boxNumDict: Dictionary<String, String> =
                ["itemBoxKey" : selectedBox! ]

            let itemDict: Dictionary<String, String> =
                ["itemName" : itemName]

            print("Adding item to box")

            REF_BOX.setValue(itemDict)
            REF_ITEM.updateChildValues(boxNumDict)
        
        
        
    }
    */
 
    
    
    
    func newItemErrorAlert(_ title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
  }
    
    
    // MARK: - UNWIND Navigation
 
    @IBAction func unwind_CancelToItemDetails(_ segue:UIStoryboardSegue) {

    }
    
    @IBAction func unwind_saveCategoryToItemDetails(_ segue:UIStoryboardSegue) {
        if let categoryDetails = segue.source as? CategoryDetailsVC {
            
            
            if let category = categoryDetails.category {
                self.itemCategory.text = category.category
                if let subcat = category.subcategory {
                    self.itemSubCategory.text = subcat
                } else {
                    self.itemSubCategory.text = ""
                }
             }
        }
    }
    
    
    @IBAction func unwind_saveColorToItemDetails(_ segue:UIStoryboardSegue) {
        if let colorVC = segue.source as? ColorTableVC {

             if let color = colorVC.selectedColor {
                self.itemColor.text = color.colorName?.capitalized
                 
            }
        }
    }
    
 
    fileprivate func configureExpandingMenuButton() {
        var boxSymbol: String!
        if passedItem?.itemIsBoxed == true {
             boxSymbol = "boxRemoveBlue"
        } else {
            boxSymbol = "boxAddBlue"

        }
        
        DispatchQueue.main.async {
            print("main thread dispatch")
        
         let menuButtonSize: CGSize = CGSize(width: 32.0, height: 32.0)

        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "menuBlue")!, centerHighlightedImage: UIImage(named: "menuBlue")!)
        menuButton.center = CGPoint(x: 30.0, y:  180.0)
        self.view.addSubview(menuButton)
        
        func showAlert(_ title: String) {
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: nil, image: UIImage(named: "qrBlue")!, highlightedImage: UIImage(named: "qrBlue")!, backgroundImage: UIImage(named: "qrBlue"), backgroundHighlightedImage: UIImage(named: "qrBlue")) { () -> Void in
            
            }
        
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: nil, image: UIImage(named: "cameraBlue")!, highlightedImage: UIImage(named: "cameraBlue")!, backgroundImage: UIImage(named: "cameraBlue"), backgroundHighlightedImage: UIImage(named: "cameraBlue")) { () -> Void in
//            showAlert("image")
                self.pickImage()

        }
        
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: nil, image: UIImage(named: boxSymbol)!, highlightedImage: UIImage(named: boxSymbol)!, backgroundImage: UIImage(named: boxSymbol), backgroundHighlightedImage: UIImage(named: boxSymbol)) { () -> Void in
//            showAlert("box")
        }
        
//        let item4 = ExpandingMenuItem(size: menuButtonSize, title: "Thought", image: UIImage(named: "chooser-moment-icon-thought")!, highlightedImage: UIImage(named: "chooser-moment-icon-thought-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
//            showAlert("Thought")
//        }
//        
//        let item5 = ExpandingMenuItem(size: menuButtonSize, title: "Sleep", image: UIImage(named: "chooser-moment-icon-sleep")!, highlightedImage: UIImage(named: "chooser-moment-icon-sleep-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
//            showAlert("Sleep")
//        }
        
        menuButton.addMenuItems([item1, item2, item3]) //
        
                 menuButton.willPresentMenuItems = { (menu) -> Void in
                    }
      
        
        
        menuButton.didDismissMenuItems = { (menu) -> Void in
            }
        }
    }
    //    MARK: Unwind Box Select
    @IBAction func unwindToItemsFromBoxSel(_ segue:UIStoryboardSegue) {
        if let boxFeedViewController = segue.source as? BoxFeedVC {
            
            if let selectedBox = boxFeedViewController.boxToPass {
//             itemToBox = boxFeedViewController.itemPassed {
                
                self.boxSelectedForItem = selectedBox
            }
        }
    }
    
//                let itemKey = itemToBox.itemKey
//                let itemName = itemToBox.itemName
//                
//                let REF_BOX = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/boxes/\(selectedBox!)/items/\(itemKey!)")
//                
//                let REF_ITEM = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/items/\(itemKey!)/")
//                
//                let boxNumDict: Dictionary<String, String> =
//                    ["itemBoxKey" : selectedBox! ]
//                
//                let itemDict: Dictionary<String, String> =
//                    ["itemName" : itemName]
//                
//                print("Adding item to box")
//                
//                REF_BOX.setValue(itemDict)
//                REF_ITEM.updateChildValues(boxNumDict)
//                
//            }}
//        print("Finished in Unwind back to iTemFeed")
        
    //    MARK: Change Root View Controller -app delegate
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("prepareForSegue ")
        
        if let colorVC = segue.destination as? ColorTableVC {
            colorVC.colorLoadsFrom = .item
        }
      
        
        if segue.identifier == "showBoxList" {
            print("identifier ==  showBoxList ")
            
            if itemType != .new {
                if let destination = segue.destination as? BoxFeedVC {
                    destination.boxLoadType = .category
                    destination.itemPassed = self.passedItem
                    
                    }
            } else {
                newItemErrorAlert("Item Not Saved", message: "Save new item before adding to Box.")

            }
            
            }
        }
    
    

}

