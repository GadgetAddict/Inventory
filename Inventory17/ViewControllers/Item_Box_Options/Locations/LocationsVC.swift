//
//  LocationsVC.swift
//  Inventory17
//
//  Created by Michael King on 2/13/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit
import Firebase

class LocationsVC: UITableViewController {

    var fromSettings: Bool = false
    var locations:[Location] = []
    var REF_LOCATION: FIRDatabaseReference!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "CollectionIdRef") != nil) {
            let collectionId = defaults.string(forKey: "CollectionIdRef")
       
          REF_LOCATION = DataService.ds.REF_BASE.child("/collections/\(collectionId!)/inventory/locations/favorites")
      
        }
        loadFavoriteLocations()
        
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
     
        if fromSettings == true {
            print("I came from settings ")
        self.title = "Favorite Locations"
        tableView.allowsSelection = false
            
        }
    }
 
    
    
    func loadFavoriteLocations() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.REF_LOCATION.observe(.value, with: { snapshot in
            
            self.locations = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("LocationrSnap: \(snap)")
                    
                    if let locationDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let location = Location(locationKey: key, dictionary: locationDict)
                        self.locations.append(location)
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

        if locations.count > 0 {
            
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            return locations.count
        } else {
            
            let emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height: 32))
            emptyStateLabel.font = emptyStateLabel.font.withSize(14)
            emptyStateLabel.text = "Click the ' + ' button to Create a Favorite Location"

            emptyStateLabel.textColor = UIColor.lightGray
            emptyStateLabel.textAlignment = .center;
            tableView.backgroundView = emptyStateLabel
            
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
         
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationsCell", for: indexPath)
                as! LocationsCell
            
            let location = locations[indexPath.row] as Location
            cell.location = location
            return cell
    }
    
    
    // Saving Location Object to Favorites
    func writeToFb(passedLocation: Location) {
        print("writeToFb")
 
        print("REF LOCATION IS  :\(REF_LOCATION)")
           self.REF_LOCATION.childByAutoId().setValue(["name" : passedLocation.locationName ,
                                 "area" :   passedLocation.locationArea ,
                                 "detail":  passedLocation.locationDetail
                  ])

        
      
        
        
        //                self.dismiss(animated: true, completion: {})
      
    }
    
    // Mark Unwind Segues
    @IBAction func cancelToLocationsVC(_ segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveLocationDetail(_ segue:UIStoryboardSegue) {
        if let locationDetailsVC = segue.source as? LocationDetailsVC {
          
            
            //add the new location to the  array
            if let location = locationDetailsVC.location {
                locations.append(location)
                
                if fromSettings == true {
                writeToFb(passedLocation: location)
                }
                
                //update the tableView
                let indexPath = IndexPath(row: locations.count-1, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        }
        
    }
    
//    override  func tableView(_ tableView: UITableView, didSelectRowAt
//        indexPath: IndexPath){
//        print("didSelectRowAt")
//         
//        self.performSegue(withIdentifier: "unwindToBoxDetailsWithLocation", sender: self)
//        
//    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for segue called from Locations VC")
        
        
//        if segue.identifier == "unwindToBoxDetailsWithLocation" {
//            print("ChooseLocations")
        
            //            location = Location(name: locName, detail: locDetail, area: locArea )
//        }
        
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
    }
}
