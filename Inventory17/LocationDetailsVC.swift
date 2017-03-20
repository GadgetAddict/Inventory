//
//  LocationDetailsVC.swift
//  Inventory17
//
//  Created by Michael King on 2/13/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit

enum LocationSelection:String {
    case box
    case settings
}



class LocationDetailsVC: UITableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var locNameLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    
    @IBOutlet weak var areaTableCell: UITableViewCell!
    @IBOutlet weak var detailTableCell: UITableViewCell!
    
     var passedBoxLocation: Box?
    var passedALocation: Bool = false
    
    var location:Location!
    var selectedBoxLocation: Location!
    var categorySelectionOption: CategorySelection = .item

    var locationSelection: LocationSelection = .box
    var locName:String! {
        didSet {
            locNameLabel.text? = locName
            
            self.location = Location(name: locName, detail: nil, area: nil)

            
            hideDoneButton(isHidden:false)
          
            areaTableCell.isUserInteractionEnabled = true
            areaLabel.isHidden = false
            areaLabel.attributedText = changeDetailText(string: "Select", font: "HelveticaNeue-Bold")
         }
    }
    
    var locArea:String = "Area" {
        didSet {
            areaLabel.text? = locArea
            self.location = Location(name: locName, detail: nil, area: locArea)
 
            detailTableCell.isUserInteractionEnabled = true
            detailLabel.isHidden = false
            detailLabel.attributedText = changeDetailText(string: "Select", font: "HelveticaNeue-Bold")
  

        }
    }
    
    var locDetail:String! {
        didSet {
            detailLabel.text? = locDetail
            self.location = Location(name: locName, detail: locDetail, area: locArea)
         }
    }
    
    func changeDetailText(string: String, font: String) -> NSAttributedString {
   
        let font  = UIFont(name: font, size: 17)
        
        let attributes :Dictionary = [NSFontAttributeName : font]
        
        let locationAttrString = NSAttributedString(string: string, attributes:attributes)

        return locationAttrString

    }
    
 
    
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        print("CANCEL BUTTON PRESSEd")
        
        performSegue(withIdentifier: "unwindCancelToSettings", sender: nil)
        
        
    }
    
    func hideDoneButton(isHidden: Bool)  {
        if isHidden == true {
            doneButton?.isEnabled      = false
            doneButton?.tintColor    = UIColor.clear
        }else{
            doneButton?.isEnabled      = true
            doneButton?.tintColor    = nil
        }
        
    }
    
        override func viewDidLoad() {
            
            hideDoneButton(isHidden:true)
            
            detailTableCell.isUserInteractionEnabled = false
            areaTableCell.isUserInteractionEnabled = false
            areaLabel.isHidden = true
            detailLabel.isHidden = true
            
            if locationSelection == .settings {
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
                self.navigationItem.leftBarButtonItem?.isEnabled = false

            }
            
            let boldLabelFont = UIFont(name: "HelveticaNeue-Bold", size: 17)
   
            let attributes :Dictionary = [NSFontAttributeName : boldLabelFont]

            let locationAttrString = NSAttributedString(string: "Select", attributes:attributes)

            locNameLabel.attributedText = locationAttrString
           
            if passedALocation == true {
                loadPassedLocations()
            }
       
    }
    
    func loadPassedLocations() {
        if let passedLocation = passedBoxLocation?.boxLocationName {
             self.locName = passedLocation
        }
        if let passedLocationArea = passedBoxLocation?.boxLocationArea {
            self.locArea = passedLocationArea
        }
        if let passedLocationDetail = passedBoxLocation?.boxLocationDetail {
            self.locDetail = passedLocationDetail
        }
        
    }

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        
                    switch locationSelection {
                    case .box:
                        if locNameLabel.text != "Select" {

                        performSegue(withIdentifier: "unwindToBoxDetailsWithLocation", sender: nil)
                        } else {
                            errorAlert("Whoops", message: "A Location Name is Required")
                        }
                    case .settings:
                        
                        performSegue(withIdentifier: "unwindLocationsToSettings" , sender: nil)
                    }
                }
 



    func errorAlert(_ title: String, message: String) {
        // Called upon login error to let the user know login didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
//    required init?(coder aDecoder: NSCoder) {
//        print("init init LocationDetailsVC")
//        super.init(coder: aDecoder)
//    }
//    
//    deinit {
//        print("deinit LocationDetailsVC")
//    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            nameTextField.becomeFirstResponder()
//        }
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("LocDetails prepare for segue called")

        if segue.identifier == "unwindToBoxDetailsWithLocation" {
            selectedBoxLocation = Location(name: locName, detail: locDetail, area: locArea )
           print("Passing Locations to BoX DETAILS: \(selectedBoxLocation.locationName) LocArea: \(selectedBoxLocation.locationArea) LocDetail: \(selectedBoxLocation.locationDetail)")
        }
     
        
        
        if let locationPickerViewController = segue.destination as? LocationPickerVC {
            print("destination as? LocationPickerVC")
            locationPickerViewController.passedLocation = self.location
            
        
            if let identifier = segue.identifier {
                switch identifier {
                case  "PickName":
                    locationPickerViewController.locationType = LocationType.name
                     print("GotoPicker for Name")
                case "PickArea":
                    locationPickerViewController.locationType = LocationType.area
                    print("GotoPicker for Area")
                case "PickDetail":
                    locationPickerViewController.locationType = LocationType.detail
                    print("GotoPicker for Detail")
                                default:
                    print("default")
                }
            }
        }
    }
 

    
    @IBAction func unwindCancelLocationPicker(_ segue:UIStoryboardSegue) {
    }
    
    
    
    @IBAction func unwindWithSelectedLocation(_ segue:UIStoryboardSegue) {
        if let locationPickerVC = segue.source as? LocationPickerVC {
            if let selectedLocation = locationPickerVC.selectedLocation{
                        print("Selected Location that came back is \(selectedLocation)")
                let locationType = locationPickerVC.locationType

         
            switch locationType {
           
            case .name:
                print("NAME ")
                if let name = selectedLocation.locationName{
                    print("Name returned is : \(name)")
                    self.locName = name
                }
          
//                areaTableCell.isUserInteractionEnabled = true
//                areaLabel.isHidden = false
//                areaLabel.attributedText = changeDetailText(string: "Select", font: "HelveticaNeue-Bold")
            
            case .area :
                print("AREA ")
                if let area = selectedLocation.locationArea{
                    print("Area returned is : \(area)")
                    self.locArea = area
                }

//                detailTableCell.isUserInteractionEnabled = true
//                detailLabel.isHidden = false
//                detailLabel.attributedText = changeDetailText(string: "Select", font: "HelveticaNeue-Bold")
                
                
            case .detail:
                print("DETAIL")
                 if let detail = selectedLocation.locationDetail{
                    print("Detail returned is : \(detail)")
                    self.locDetail = detail
                }
                
                    }
                
                }
            }
        
        }
    
    
    
    


}
