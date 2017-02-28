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
    case favorites
}

class LocationDetailsVC: UITableViewController {

    @IBOutlet weak var locNameLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    
    @IBOutlet weak var areaTableCell: UITableViewCell!
    @IBOutlet weak var detailTableCell: UITableViewCell!
    
    var location:Location?
    var selectedBoxLocation: Location!
    var locationSelection: LocationSelection = .box
    var locName:String! {
        didSet {
            locNameLabel.text? = locName
            
            self.location = Location(name: locName, detail: nil, area: nil)

        }
    }
    
    var locArea:String = "Area" {
        didSet {
            areaLabel.text? = locArea
            self.location = Location(name: locName, detail: locDetail, area: nil)
        
        }
    }
    
    var locDetail:String! {
        didSet {
            detailLabel.text? = locDetail
            self.location = Location(name: locName, detail: locArea, area: locArea)

        }
    }
    
    func changeDetailText(string: String, font: String) -> NSAttributedString {
   
        let font  = UIFont(name: font, size: 17)
        
        let attributes :Dictionary = [NSFontAttributeName : font]
        
        let locationAttrString = NSAttributedString(string: string, attributes:attributes)

        return locationAttrString

    }
    

        override func viewDidLoad() {
        
            
            let boldLabelFont = UIFont(name: "HelveticaNeue-Bold", size: 17)
   
            let attributes :Dictionary = [NSFontAttributeName : boldLabelFont]

            let locationAttrString = NSAttributedString(string: "Select", attributes:attributes)

            locNameLabel.attributedText = locationAttrString
           
        
        detailTableCell.isUserInteractionEnabled = false
        areaTableCell.isUserInteractionEnabled = false

    }
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        if locNameLabel.text != "Detail" {
            
                            switch locationSelection {
                            case .box:
                                performSegue(withIdentifier: "unwindToBoxDetailsWithLocation", sender: nil)
            
                            case .favorites:
                                performSegue(withIdentifier: "saveLocationDetail", sender: nil)
            
                            }
            
                        } else {
            errorAlert("Whoops", message: "A Location Name is Required")
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
            print("SaveLocations")

            location = Location(name: locName, detail: locDetail, area: locArea )
        }
        
        if let locationPickerViewController = segue.destination as? LocationPickerVC {
            print("destination as? LocationPickerVC")
            
        if segue.identifier == "PickDetail" {
                locationPickerViewController.locationType = LocationType.detail
            if let locName = self.location?.locationName {

                if let locArea = self.location?.locationArea {
                    
                locationPickerViewController.passedLoc = "\(locName)/\(locArea)"

//                print("I picked Location Type \(locationPickerViewController.locationType.rawValue) aka DETAIL")
                    }
                }
            }
        if segue.identifier == "PickArea" {
            locationPickerViewController.locationType = LocationType.area
            
            if let locName = self.location?.locationName {
                locationPickerViewController.passedLoc = locName

            }
//            print("I picked Location Type \(locationPickerViewController.locationType.rawValue)aka AREA")
            
            
        }
        if segue.identifier == "PickName" {
            locationPickerViewController.locationType = LocationType.name
            print("I picked Location Type \(locationPickerViewController.locationType.rawValue)aka NAME")
                 }
            
        }
    }
//
//    //Unwind segue
    
    @IBAction func unwindCancelLocationPicker(_ segue:UIStoryboardSegue) {
    }
    
    
    
    @IBAction func unwindWithSelectedLocation(_ segue:UIStoryboardSegue) {
        if let locationPickerVC = segue.source as? LocationPickerVC {
            if let selectedLocation = locationPickerVC.selectedLocation{
                        print("Selected Location that came back is \(selectedLocation)")
                let locationType = locationPickerVC.locationType

         
            switch locationType {
           
            case .name:
                print("NAME")
                self.locName = (selectedLocation.locationName)!
                areaTableCell.isUserInteractionEnabled = true
                areaLabel.attributedText = changeDetailText(string: "Select", font: "HelveticaNeue-Bold")
            
            case .area :
                print("AREA ")
                self.locArea = (selectedLocation.locationArea)!
                detailTableCell.isUserInteractionEnabled = true
                detailLabel.attributedText = changeDetailText(string: "Select", font: "HelveticaNeue-Bold")
                
                
            case .detail:
                print("DETAIL")
                self.locDetail = (selectedLocation.locationDetail)!

                
                }
                
            }
        }
        
}
    
    
    
    


}
