//
//  BoxDetails.swift
//  Inventory17
//
//  Created by Michael King on 2/12/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit
import Firebase

enum SegueType {
    case new
    case existing
    case qr
}


class BoxDetails: UITableViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

  
    

    var REF_BOXES = DataService.ds.REF_BASE
    var box: Box!
    var boxSegueType: SegueType = .new
    var boxNumber: Int?
    var boxQR:  String?
    
    @IBOutlet weak var detailHeader: UILabel!
    @IBOutlet weak var areaHeader: UILabel!
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
            areaHeader.isHidden = false
            boxLocationAreaLabel.isHidden = false
            boxLocationAreaLabel.text? = boxLocationArea!
            print("boxLocationArea was set to  \(boxLocationArea!)")

        }
    }
    
    var boxLocationDetail:String? = nil {
        didSet {
            detailHeader.isHidden = false
            boxLocationDetailLabel.isHidden = false
            boxLocationDetailLabel.text? = boxLocationDetail!
            print("boxLocationLabel was set to  \(boxLocationDetail!)")

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        hideLocationLabels()
        self.REF_BOXES = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/boxes")
        
        
        switch boxSegueType {
        case .new:
             boxContentsCellActive(boxIsNew: true)
        default:
            boxContentsCellActive(boxIsNew: false)
            
            loadBoxData()

            }
        
   
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    
        }
    
    func hideLocationLabels() {
        areaHeader.isHidden = true
        detailHeader.isHidden = true
        boxLocationDetailLabel.isHidden = true
        boxLocationAreaLabel.isHidden = true


    }

    func boxContentsCellActive(boxIsNew: Bool){
//        Set box contents table to be un-touchable if box is new
        BoxContentsCell.isUserInteractionEnabled = !boxIsNew
        BoxContentsCell.isHidden = boxIsNew
        
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
        print("checkForEmptyFields")

        
        
        guard  boxStatusLabel.text != "Set Status" else {
            let errMsg = "Status is Required "
            newBoxErrorAlert("Ut oh...", message: errMsg)
            return
        }
        
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
        
             getBoxNumbers()
        }
    
    
    
    
    func createBoxDictionary() {
 
        print("createBoxDictionary")

   

        EZLoadingActivity.show("Saving", disableUI: true)
 
       
        
                let boxDict: Dictionary<String, AnyObject> = [
                    "name" : boxNameLabel.text?.capitalized as AnyObject,
                    "fragile": false as AnyObject,
                    "stackable" : true as AnyObject,
                    "boxCategory" : boxCategory as AnyObject,
//                    "boxQR" : boxQrString as AnyObject,
                    "boxNum" : self.boxNumber as AnyObject,
                    "location" : boxLocation as AnyObject ,
                    "location_area" : boxLocationArea  as AnyObject,
                    "location_detail" : boxLocationDetail as AnyObject,
                    "status": boxStatus as AnyObject,
                    "color": boxColor as AnyObject

                ]

        if boxSegueType == .new {
           saveNewBoxToFirebaseData(boxDictionary: boxDict)
        } else {
            updateFirebaseData(boxDictionary: boxDict)

        }
 
    }
    
    func saveNewBoxToFirebaseData(boxDictionary: Dictionary<String, AnyObject>) {
        self.REF_BOXES = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/boxes").childByAutoId()
        
        self.REF_BOXES.setValue(boxDictionary)
        EZLoadingActivity.hide(success: true, animated: true)

        popViewController()
    }
    
    func updateFirebaseData(boxDictionary: Dictionary<String, AnyObject>) {
        self.REF_BOXES = DataService.ds.REF_BASE.child("/collections/\(COLLECTION_ID!)/inventory/boxes/\(self.box.boxKey!)")
        self.REF_BOXES.updateChildValues(boxDictionary)
        EZLoadingActivity.hide(success: true, animated: true)

        
        popViewController()
        
    }
    
    
    
    
    func popViewController()  {
        
        switch boxSegueType {
        case .qr:
            _ = navigationController?.popToRootViewController(animated: true)
        default:
            _ = navigationController?.popViewController(animated: true)

        }
    }
    
//    let questionsRef = Firebase(url:"https://baseurl/questions")
//    questionsRef.queryOrderedByChild("categories/Oceania").queryEqualToValue(true)
//    .observeEventType(.ChildAdded, withBlock: { snapshot in
//    print(snapshot)
//    })
//    
 
 
    func getBoxNumbers(){
        print("getBoxNumbers")
        
        self.REF_BOXES.observeSingleEvent(of: .value, with: { (boxExistsSnapshot) in
               if boxExistsSnapshot.exists() {
                print("boxExistsSnapshot exists ")

                self.REF_BOXES.queryOrdered(byChild: "boxNum").queryLimited(toLast: 1).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                       
                        if let boxSnapshot = snapshot.value as? Dictionary<String, AnyObject> {
                             if let boxNum = boxSnapshot["boxNum"] as? Int   {
                                 self.boxNumber = (boxNum + 1)
                                 self.createBoxDictionary()
                                
                            } else {
                                print("boxNum does NOT equal boxSnapshot[boxNum] as? Int")
                                
                            }
                        } else {
                            print("boxSnapshot is NOT  snapshot.value as dict")
                            
                        }
                        
                    
                }) { (error) in
                    print("query has error \(error)")
                    
                }
           
                
               } else {
                self.boxNumber = 1
                print("self.boxNumber = 1, now createBoxDict")
                
                self.createBoxDictionary()

            }
            
        }) { (noBoxError) in
            print("There was no box: \(noBoxError)")
        }
    }
    

    
    
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
        
 
        popViewController()
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
    
//    @IBAction func unwindToBoxDetailswithQRBOX(_ segue:UIStoryboardSegue) {
//        print("Back to box from QR ")
//        if let QrVC = segue.source as? qrScannerVC {
//             if let selectedBox = QrVC.scannedBox  { //passed from QRVC
//             self.box = selectedBox
////                boxesREF = (self.REF_BOXES.child(query.child).queryEqual(toValue: query.value))
////                self.query = (child: "boxNum", value: selectedBox)
//
//                self.boxIsNew = false
//             }
//         }
//    }
    
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
            if self.boxSegueType == .existing {
              if let boxLocations = segue.destination as?  LocationDetailsVC {
                let boxLocationToPass = Box(location: box.boxLocationName, area: box.boxLocationArea, detail: box.boxLocationDetail)
                boxLocations.passedALocation = true
                boxLocations.passedBoxLocation = boxLocationToPass
                }
            }
        }
        
    }

    
}
