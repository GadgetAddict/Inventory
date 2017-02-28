//
//  NewItemVC.swift
//  Inventory17
//
//  Created by Michael King on 1/20/17.
//  Copyright © 2017 Microideas. All rights reserved.
//


import UIKit
import Firebase

enum ItemType {
    case new
    case existing
    case boxItem
}

class ItemDetails: UITableViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var itemType: ItemType = .new
    var passedItem: Item?
    var boxItemKey: String?
    var newItem: Item!
    var REF_ITEMS = DataService.ds.REF_BASE
    var collectionId: String!
    
    @IBOutlet weak var itemNameField: UITextField!

    @IBOutlet weak var itemCategory: UILabel!
    @IBOutlet weak var itemSubCategory: UILabel!
    @IBOutlet weak var itemColor: UILabel!
    @IBOutlet weak var itemQty: UITextField!
    @IBOutlet weak var fragileButton: UIButton!
    var fragileStatus: Bool = false
    
    @IBAction func fragileTapped(_ sender: UIButton) {
        
        fragileStatus = !fragileStatus
        let fragilBoolAsString = String(fragileStatus).uppercased()

        
         fragileButton.setTitle("\(fragilBoolAsString)",for: .normal)

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
    
    
    @IBAction func pickImage(_ sender: UITapGestureRecognizer) {
        
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
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        myImageView.contentMode = .scaleAspectFill //3
        myImageView.image = chosenImage //4
        blurredImage.image = chosenImage //4
        
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "CollectionIdRef") != nil) {
            
            if let collectionId = defaults.string(forKey: "CollectionIdRef") {
                print("Item Details VC Getting CollectionIdRef \(collectionId)")
                self.collectionId = collectionId
             
                
            }
        }
        
        
        switch itemType {
        
        case .boxItem:
            self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(self.collectionId!)/inventory/items/\(boxItemKey!)")
                  
            loadBoxItem()
            print("loadBoxItem \(self.REF_ITEMS)")
            
        case .existing:
            if let key = self.passedItem?.itemKey{
                 self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(self.collectionId!)/inventory/items/\(key)")
            }
          
           
            loadPassedItem()
            print("loadPassedItem \(self.REF_ITEMS)")

        case .new:
            self.title = "New Item"
               self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(self.collectionId!)/inventory/items/")
            print("NEW")
        }
     
        
        picker.delegate = self
    
        // Do any additional setup after loading the view.
        myImageView.layer.borderWidth = 3.0
        myImageView.layer.borderColor = UIColor.white.cgColor
        myImageView.layer.cornerRadius = myImageView.frame.height / 2.0
        myImageView.clipsToBounds = true
        
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        

        blurredImage.addSubview(blurEffectView)
        blurredImage.clipsToBounds = true
       
       
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


    func loadImage(item: Item){
//        if let img = itemFeedVC.imageCache.object(forKey: item.itemImgUrl as NSString) {

      
                let ref = FIRStorage.storage().reference(forURL: item.itemImgUrl)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("MK: Unable to download image from Firebase storage")
                    } else {
                        print("MK: Image downloaded from Firebase storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.myImageView.image = img
//                                itemFeedVC.imageCache.setObject(img, forKey: item.itemImgUrl as NSString)
                            }
                        }
                    }
                })
            }
    
   
    func loadPassedItem() {
        print("LOADING ITEM")
        if let item = passedItem {
            
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
                fragileButton.setTitle("TRUE", for: UIControlState.normal)
            } else {
                fragileButton.setTitle("FALSE", for: UIControlState.normal)
            }


        }
    }
    
    
    
    @IBAction func saveItemTapped(_ sender: UIBarButtonItem) {
        checkForEmptyFields()
        
    }
    
    func checkForEmptyFields() {
        
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
                    print("JESS: Unable to upload image to Firebasee storage")
                    
                    if self.itemType == .new {
                    self.postToFirebase(imgUrl: "gs://inventory-694e9.appspot.com/placeholder.png")
                    
                    } else {
                    self.updateFirebaseData(imgUrl: "gs://inventory-694e9.appspot.com/placeholder.png")
                    }


                } else {
                    
                  

                    print("JESS: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        
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
    }
    
    
    
    func postToFirebase(imgUrl: String) {
        print("I'm in postToFirebase")

        let newItem = Item(itemName: (itemNameField.text?.capitalized)!, itemCat: (itemCategory.text?.capitalized)!, itemSubcat: (itemSubCategory.text?.capitalized)!, itemColor: itemColor.text?.capitalized)
        
        
        print("NEW ITEM is \(newItem.itemName)")

        
        
        let itemDict: Dictionary<String, AnyObject> = [
            "itemName" :  newItem.itemName as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "itemCategory" : newItem.itemCategory as AnyObject,
            "itemSubcategory" : newItem.itemSubcategory as AnyObject,
            "itemQty" : itemQty.text! as AnyObject ,
            "itemFragile" : fragileStatus as AnyObject,
            "itemColor": newItem.itemColor as AnyObject
        ]
        
                self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(self.collectionId!)/inventory/items").childByAutoId()
        print("REF is \(self.REF_ITEMS)")

                self.REF_ITEMS.setValue(itemDict)

        //                self.dismiss(animated: true, completion: {})
                 _ = navigationController?.popViewController(animated: true)
        
            }
    
 
    func updateFirebaseData(imgUrl: String) {
//     self.REF_ITEMS = DataService.ds.REF_BASE.child("/collections/\(collectionId!)/inventory/items/\(self.passedItem!.itemKey!)")
        
        
        print("MK: QTY Changed to :\(itemQty)")

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
        
        _ = navigationController?.popViewController(animated: true)

    }
    
    
    
    
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
               print("Unwound with category \(category.category)")
                print("Unwound with subcategory \(category.subcategory)")
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
    
    
}
