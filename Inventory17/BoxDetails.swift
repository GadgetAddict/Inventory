//
//  BoxDetails.swift
//  Inventory17
//
//  Created by Michael King on 2/12/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit

class BoxDetails: UITableViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    var boxLocation: Location?
 
    

    var REF_BOXES = DataService.ds.REF_BASE
    var collectionId: String!
    var box: Box!
    var boxIsNew: Bool = true
    var boxNumber: Int?
    var boxQRNumber:  String?
    
    @IBOutlet weak var boxTitle: UINavigationItem!
    @IBOutlet weak var boxNameLabel: UITextField!
    @IBOutlet weak var boxCategoryLabel: UILabel!
    @IBOutlet weak var boxStatusLabel: UILabel!
    @IBOutlet weak var boxLocationLabel: UILabel!
    @IBOutlet weak var boxLocationAreaLabel: UILabel!
    @IBOutlet weak var boxLocationDetailLabel: UILabel!
 
    @IBOutlet weak var fragileImage: UIImageView!
 
    
    var boxCategory:String! {
        didSet {
            boxCategoryLabel.text? = boxCategory.capitalized
            }
        }
        
        
    var boxStatus:String = "Not Set" {
        didSet {
            boxStatusLabel.text? = boxStatus.capitalized
 
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
//        fragileImage.image = #imageLiteral(resourceName: "fragileCirStamp")
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "CollectionIdRef") != nil) {
            self.collectionId = defaults.string(forKey: "CollectionIdRef")
        }
        
        if boxIsNew == false {
            print("LOAD PASSED BOX: \(box.boxCategory)")
            
            loadBoxData()
        } else {
            print("BOX IS NEW")

        }
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
 
         checkForEmptyFields()
        
    }
    
    func loadBoxData(){
        if let boxTitle = box.boxName {
            self.title = boxTitle.capitalized
            boxNameLabel.text = boxTitle.capitalized
        } else {
            self.title = "Box \(box.boxNumber)"

        }
        
        
        
        if let category = box.boxCategory {
//            boxCategoryLabel.text = category.capitalized
            self.boxCategory = category
        }
        
        if let status = box.boxStatus{
//            boxStatusLabel.text = status.capitalized
            self.boxStatus = status
        }
        
        boxLocationLabel.text = box.boxLocationName.capitalized
        
        if let area = box.boxLocationArea {
            boxLocationAreaLabel.text = area.capitalized
        }
        
        if let detail = box.boxLocationDetail {
            boxLocationDetailLabel.text = detail.capitalized
        }
        
    }
    
    func checkForEmptyFields() {
        
        guard  boxCategoryLabel.text != "Set Category" else {
            let errMsg = "Category is Required "
            newBoxErrorAlert("Ut oh...", message: errMsg)
            return
        }
        
        guard  boxStatusLabel.text != "Set Status" else {
            let errMsg = "Status is Required "
            newBoxErrorAlert("Ut oh...", message: errMsg)
            return
        }
        
             createBoxDictionary()
    }
    
    
    
    
    func createBoxDictionary() {
//        print("I'm in postToFirebase")
//        
                let boxDict: Dictionary<String, AnyObject> = [
                    "name" : boxNameLabel.text as AnyObject,
                    "fragile": false as AnyObject,
                    "stackable" : true as AnyObject,
                    "boxCategory" : boxCategory as AnyObject,
                    "boxNum" : boxQRNumber as AnyObject,
                    "location" : boxLocationLabel.text as AnyObject ,
                    "location_area" : boxLocationAreaLabel.text  as AnyObject,
                    "location_detail" : boxLocationDetailLabel.text as AnyObject,
                    "status": boxStatusLabel.text as AnyObject
                ]

        if self.boxIsNew == true {
           saveNewBoxToFirebaseData(boxDictionary: boxDict)
        } else {
            updateFirebaseData(boxDictionary: boxDict)

        }
 
    }
    
    func saveNewBoxToFirebaseData(boxDictionary: Dictionary<String, AnyObject>) {
        self.REF_BOXES = DataService.ds.REF_BASE.child("/collections/\(self.collectionId!)/inventory/boxes").childByAutoId()
        
        self.REF_BOXES.setValue(boxDictionary)
        _ = navigationController?.popViewController(animated: true)

    }
    
    func updateFirebaseData(boxDictionary: Dictionary<String, AnyObject>) {
        self.REF_BOXES = DataService.ds.REF_BASE.child("/collections/\(collectionId!)/inventory/boxes/\(self.box.boxKey!)")
        self.REF_BOXES.updateChildValues(boxDictionary)
        
        _ = navigationController?.popViewController(animated: true)
        
    }
//
//    
    
    
    
    
    func newBoxErrorAlert(_ title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
//
//    MARK:  UNWIND AND NAVIGATIOn
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func unwindToBoxDetailsCancel(_ segue:UIStoryboardSegue) {
        }
    

    @IBAction func unwindToBoxDetailsWithCategory(_ segue:UIStoryboardSegue) {
        if let categoryPicker = segue.source as? CategoryPicker {
            self.boxCategory = categoryPicker.selectedCategory.category
            print("Selection that came back is \(self.boxCategory)")
        }
    }
    
    @IBAction func unwindToBoxDetailsWithLocation(_ segue:UIStoryboardSegue) {
        if let locationDetails = segue.source as? LocationDetailsVC {
            self.boxLocation = locationDetails.selectedBoxLocation
            
            
        }
    }
    
    
    @IBAction func unwindToBoxDetailsWithStatus(_ segue:UIStoryboardSegue) {
        if let statusVC = segue.source as? BoxStatusTableVC {
            self.boxStatus = (statusVC.selecteStatus?.statusName)!
            print("STATUS that came back is \(self.boxStatus)")
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "BoxCategorySegue" {
            print("BoxCategorySegue")
           if let boxCategoryVC = segue.destination as? CategoryPicker {
                 boxCategoryVC.categorySelection = .box
               boxCategoryVC.categoryType = .category
        }
        } else {
            if let boxItemsVC = segue.destination as?  BoxItemsVC{
                       print("destination as? boxItemsVC")
                if let boxKey = self.box.boxKey{
                    boxItemsVC.boxKey = boxKey
                }
            }
        }
    }
//
//        if let locationPickerViewController = segue.destination as? LocationPickerVC {
//            print("destination as? LocationPickerVC")
//            
//            if segue.identifier == "PickDetail" {
//                locationPickerViewController.locationType = LocationType.detail
//                print("I picked Location Type \(locationPickerViewController.locationType.rawValue) aka DETAIL")
//                
//            }
//            if segue.identifier == "PickArea" {
//                locationPickerViewController.locationType = LocationType.area
//                print("I picked Location Type \(locationPickerViewController.locationType.rawValue)aka AREA")
//            }
//            if segue.identifier == "PickName" {
//                locationPickerViewController.locationType = LocationType.name
//                print("I picked Location Type \(locationPickerViewController.locationType.rawValue)aka NAME")
//            }
//            
//        }
//    }
//    
    
}
