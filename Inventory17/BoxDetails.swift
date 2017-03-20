//
//  BoxDetails.swift
//  Inventory17
//
//  Created by Michael King on 2/12/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit
import Firebase

class BoxDetails: UITableViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

  
    

    var REF_BOXES = DataService.ds.REF_BASE
    var collectionId: String!
    var box: Box!
    var boxIsNew: Bool = true
    var boxNumber: Int?
    var boxQR:  String?
    
    @IBOutlet weak var boxTitle: UINavigationItem!
    @IBOutlet weak var boxNameLabel: UITextField!
    @IBOutlet weak var boxCategoryLabel: UILabel!
    @IBOutlet weak var boxStatusLabel: UILabel!
    @IBOutlet weak var boxColorLabel: UILabel!

    @IBOutlet weak var boxLocationLabel: UILabel!
    @IBOutlet weak var boxLocationAreaLabel: UILabel!
    @IBOutlet weak var boxLocationDetailLabel: UILabel!
 
    @IBOutlet weak var BoxContentsCell: UITableViewCell!
    var query = (child: "boxNum", value: "")

    
    var boxCategory:String! {
        didSet {
            boxCategoryLabel.text? = boxCategory.capitalized
            }
        }
        
        
    var boxStatus:String? = nil {
        didSet {
            boxStatusLabel.text? = boxStatus!
 
            } 
        }
    
    var boxColor:String? = nil {
        didSet {
            boxColorLabel.text? = boxColor!
            
        }
    }
    
    var boxLocation:String? = nil {
        didSet {
            boxLocationLabel.text? = boxLocation!
            print("boxLocation was set to  \(boxLocation!)")

        }
    }
    
    var boxLocationArea:String? = nil {
        didSet {
            boxLocationAreaLabel.text? = boxLocationArea!
            print("boxLocationArea was set to  \(boxLocationArea!)")

        }
    }
    
    var boxLocationDetail:String? = nil {
        didSet {
            boxLocationDetailLabel.text? = boxLocationDetail!
            print("boxLocationLabel was set to  \(boxLocationDetail!)")

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        
        
        
//        Set box contents table to be un-touchable if box is new
        boxContentsCellActive(boxIsNew: boxIsNew)
        
        
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "CollectionIdRef") != nil) {
            self.collectionId = defaults.string(forKey: "CollectionIdRef")
            print("self.collectionId: \(self.collectionId)")
            self.REF_BOXES = DataService.ds.REF_BASE.child("/collections/\(collectionId!)/inventory/boxes")
 
        }
        
        if boxIsNew == false {
            print("LOAD PASSED BOX: \(box.boxCategory)")
//            boxContentsCellActive(boxIsNew: false)

            loadBoxData()
        } else {
//            boxContentsCellActive(boxIsNew: true)
           
            print("BOX IS NEW/ Generate Box Number")
          
        }
     }

    func boxContentsCellActive(boxIsNew: Bool){
        BoxContentsCell.isUserInteractionEnabled = !boxIsNew
        BoxContentsCell.isHidden = boxIsNew
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        EZLoadingActivity.show("Saving", disableUI: true)
         checkForEmptyFields()
        
    }
    
    func loadBoxData(){

        if let boxTitle = box.boxName {
            self.title = boxTitle.capitalized
            boxNameLabel.text = boxTitle.capitalized
        } else {
            self.title = "Box \(box.boxNumber)"

        }
        
        
        if let color = box.boxColor {
             self.boxColor = color
        }
        
        if let category = box.boxCategory {
//            boxCategoryLabel.text = category.capitalized
            self.boxCategory = category
        }
        
        if let status = box.boxStatus{
//            boxStatusLabel.text = status.capitalized
            self.boxStatus = status
        }
        
        if let location = box.boxLocationName {
        boxLocation = location.capitalized
        } else {
            boxLocationLabel.text = "Set Location"
        }
        
        if let area = box.boxLocationArea {
            self.boxLocationArea = area.capitalized
        }
        
        if let detail = box.boxLocationDetail {
            self.boxLocationDetail = detail.capitalized
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
       // Need to generate a box number  boxNum
//        getBoxNumbers()

    getBoxNumbers()

        let boxQrString = boxCategory! + "\(self.boxNumber)"
        
        
        
        
        
        
        
                let boxDict: Dictionary<String, AnyObject> = [
                    "name" : boxNameLabel.text?.capitalized as AnyObject,
                    "fragile": false as AnyObject,
                    "stackable" : true as AnyObject,
                    "boxCategory" : boxCategory as AnyObject,
                    "boxQR" : boxQrString as AnyObject,
                    "boxNum" : self.boxNumber as AnyObject,
                    "location" : boxLocation as AnyObject ,
                    "location_area" : boxLocationArea  as AnyObject,
                    "location_detail" : boxLocationDetail as AnyObject,
                    "status": boxStatus as AnyObject,
                    "color": boxColor as AnyObject

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
        EZLoadingActivity.hide(success: true, animated: true)

        _ = navigationController?.popViewController(animated: true)

    }
    
    func updateFirebaseData(boxDictionary: Dictionary<String, AnyObject>) {
        self.REF_BOXES = DataService.ds.REF_BASE.child("/collections/\(collectionId!)/inventory/boxes/\(self.box.boxKey!)")
        self.REF_BOXES.updateChildValues(boxDictionary)
        EZLoadingActivity.hide(success: true, animated: true)

        _ = navigationController?.popViewController(animated: true)
        
    }
//
//    
    
//    
//    let questionsRef = Firebase(url:"https://baseurl/questions")
//    questionsRef.queryOrderedByChild("categories/Oceania").queryEqualToValue(true)
//    .observeEventType(.ChildAdded, withBlock: { snapshot in
//    print(snapshot)
//    })
//    
//    
    func getBoxNumbers()    {
        
          let setDefaultCollectionQueue2 = DispatchQueue(label: "com.michael.getBox", qos: DispatchQoS.userInteractive)
        

 print("getBoxNumbers Function")
        
        var lastBoxNumber: Int!
        
 
        setDefaultCollectionQueue2.sync {

         self.REF_BOXES.queryOrdered(byChild: "boxNum").queryLimited(toLast: 1).observeSingleEvent(of: .childAdded, with: { data in

          
            if let snapshotData = data.value as? Dictionary<String, AnyObject> {
                            print("GetBoxNumb-SNAPSHOT: \(snapshotData)")
                
                
                           if let boxNum = snapshotData["boxNum"]    {
                            print("snapshotData - lastBoxNumber is \(boxNum)")

                            lastBoxNumber = boxNum as! Int
                 }
            }
        })
        
        }
        
        setDefaultCollectionQueue2.async {

        if let _ = lastBoxNumber {
            print("lastBoxNumber is \(lastBoxNumber)")

           
        } else {
            print("lastBoxNumber is NIL")
            lastBoxNumber = 0
        }
        
        self.boxNumber = lastBoxNumber + 1
        print("self.boxNumber is \(self.boxNumber)")
        

                   }
    }

    
            
            
            //    func getBoxNumbers() -> Int   {
    //        var boxNumberReturned: Int!
    //        let BOXQUERY_REF = self.REF_BOXES.queryOrdered(byChild: "boxNum").queryLimited(toLast: 1)
    //
    //         BOXQUERY_REF.observe(.childAdded) { (data: FIRDataSnapshot) in
    //         let snapshotData = data.value as! Dictionary<String, AnyObject>
    //
    //             if let boxNum = snapshotData["boxNum"] {
    //                        print("boxNum: \(boxNum)")
    //                boxNumberReturned = boxNum as! Int
    //            }
    //        }
    //        return boxNumberReturned
    //    }

    
    
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
            print("Unwind Category that came back is \(self.boxCategory)")
        }
    }
    
    
    
    
    @IBAction func unwindToBoxDetailsWithLocation(_ segue:UIStoryboardSegue) {
        print("Unwind Locations that came back is .....")

        
        if let locationDetails = segue.source as? LocationDetailsVC {
            if let location = locationDetails.selectedBoxLocation {
//                print(" Locations name... \(location.locationName!)")

                if let boxLoc = location.locationName {
                    boxLocation = boxLoc
                }
                if let boxArea = location.locationArea {
                    boxLocationArea = boxArea
                }
                if let boxDet = location.locationDetail {
                    boxLocationDetail = boxDet
                }
              }
            
            
        }
    }
    
    
    @IBAction func unwindToBoxDetailsWithStatus(_ segue:UIStoryboardSegue) {
        if let statusVC = segue.source as? BoxStatusTableVC {
            self.boxStatus = (statusVC.selecteStatus?.statusName)!
            print("STATUS that came back is \(self.boxStatus)")
        }
    }
    
    @IBAction func unwindToBoxDetailsWithColor(_ segue:UIStoryboardSegue) {
        if let colorVC = segue.source as? ColorTableVC {
            self.boxColor = (colorVC.selectedColor?.colorName)!
            print("Color that came back is \(self.boxColor)")
        }
    }
    
    @IBAction func unwindFromQR(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.source as? qrScannerVC {
//            if let selectedBox = sourceViewController.qrData  { //passed from PickBox VC
            
//                boxesREF = (self.REF_BOXES.child(query.child).queryEqual(toValue: query.value))
//                self.query = (child: "boxNum", value: selectedBox)

                self.boxIsNew = false
//             }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    
        if segue.identifier == "BoxCategorySegue" {
            print("BoxCategorySegue")
           if let boxCategoryVC = segue.destination as? CategoryPicker {
                 boxCategoryVC.categorySelection = .box
               boxCategoryVC.categoryType = .category
        }
        } else if let boxItemsVC = segue.destination as?  BoxItemsVC{
                    print("destination as? boxItemsVC")
                    boxItemsVC.box = self.box
                 
        } else {
            if self.boxIsNew == false {
              if let boxLocations = segue.destination as?  LocationDetailsVC {
                let boxLocationToPass = Box(location: box.boxLocationName, area: box.boxLocationArea, detail: box.boxLocationDetail)
                boxLocations.passedALocation = true
                boxLocations.passedBoxLocation = boxLocationToPass
                }
            }
        }
        
    }

    
}
