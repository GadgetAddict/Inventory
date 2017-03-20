//
//  CategoryDetailsVC.swift
//  Inventory17
//
//  Created by Michael King on 2/16/17.
//  Copyright © 2017 Microideas. All rights reserved.
//
//
//  CategoryDetailsVC.swift
//  Inventory17
//
//  Created by Michael King on 2/13/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit

enum CategorySelection:String {
    case item
    case settings
    case box
}


class CategoryDetailsVC: UITableViewController {
    
     
    
    @IBOutlet weak var subCatTableCell: UITableViewCell!
    
    var categoryName:String! {
        didSet {
            categoryNameLabel.text? = categoryName
            self.category = Category(category: categoryName, subcategory: nil)
            subCatTableCell.isUserInteractionEnabled = true
            subCcategoryNameLabel.text = "Select"
            subCatTableCell.isUserInteractionEnabled = true
        }
    }
    var subCategoryName:String = "Not Set" {
        didSet {
            subCcategoryNameLabel.text? = subCategoryName
        self.category = Category(category: categoryName, subcategory: subCategoryName)
        
        }
    }
    
    var categorySelectionOption: CategorySelection = .item
    var category:Category?
    
     @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var subCcategoryNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subCatTableCell.isUserInteractionEnabled = false
        
        if categorySelectionOption == .settings {
            categoryNameLabel.text = "View"
            subCcategoryNameLabel.text = ""

            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            subCatTableCell.isUserInteractionEnabled = false
        }
    }
    
 
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        print("CANCEL BUTTON PRESSEd")

        if categorySelectionOption == .settings {
        performSegue(withIdentifier: "unwindCancelToSettings", sender: nil)

        } else {
            performSegue(withIdentifier: "unwind_CancelToItemDetails", sender: nil)
  
        }
    }

    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
     
        if categorySelectionOption == .item {
            
                if categoryNameLabel.text != "Detail" {

                performSegue(withIdentifier: "unwind_saveCategoryToItemDetails", sender: nil)
            
                } else {
            errorAlert("Whoops", message: "A Category is Required")
            }
        } else {
  
             performSegue(withIdentifier: "unwindCancelToSettings", sender: nil)

    
    }
    }
    
    func errorAlert(_ title: String, message: String) {
        // Called upon login error to let the user know login didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Category Details VC prepare for segue called")
 
        if let categoryPickerViewController = segue.destination as? CategoryPicker {
            print("destination as? CategoryPickerVC")
            
            if segue.identifier == "showCatList" {
                categoryPickerViewController.categoryType = CategoryType.category
                print("I picked Category Type \(categoryPickerViewController.categoryType.rawValue) aka category")
                
            }
            if segue.identifier == "showSubcatList" {
                categoryPickerViewController.categoryType = CategoryType.subcategory
                print("I picked Category Type \(categoryPickerViewController.categoryType.rawValue) aka subcategory")
                
                if let cat = category?.category{
                    categoryPickerViewController.passedCategory = cat

                }
                if categorySelectionOption == .settings {
                    categoryPickerViewController.categorySelection = .settings
                }
            }
            
            if segue.identifier == "unwind_saveCategoryToItemDetails" {
                category = Category(category: categoryName, subcategory: subCategoryName)

            }
            
        }
    }
 
    //    //Unwind segue
    
    @IBAction func unwindCancelCategoryPicker(_ segue:UIStoryboardSegue) {
    }
            
    @IBAction func unwindWithSelectedCategory(_ segue:UIStoryboardSegue) {
        if let categoryPickerVC = segue.source as? CategoryPicker {
            let selectedCategory = categoryPickerVC.selectedCategory
            print("Selection that came back is \(selectedCategory)")
            
            let categoryType = categoryPickerVC.categoryType
            
            switch categoryType {
                
            case .category:
                print("category")
                self.categoryName = (selectedCategory?.category)!
                
                
            case .subcategory :
                print("subcategory ")
                self.subCategoryName = (selectedCategory?.subcategory)!
                
                
             
                
            }
        }
        
    }
    
    
    
    
    
    
}
