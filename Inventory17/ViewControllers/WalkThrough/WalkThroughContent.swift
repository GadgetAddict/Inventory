//
//  WalkThroughContent.swift
//  Inventory17
//
//  Created by Michael King on 4/3/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import UIKit

class WalkThroughContentViewController: UIViewController {
    
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet weak var forwardButton: UIButton!
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.currentPage = index
        headingLabel.text = heading
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
        
        switch index {
        case 0...1: forwardButton.setTitle("NEXT", for: .normal)
        case 2: forwardButton.setTitle("DONE", for: .normal)
        default: break
        }
        
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        
        switch index {
        case 0...1:
            let pageViewController = parent as! WalkThroughPageController
            pageViewController.forward(index: index)
            
        case 2:
           UserDefaults.standard.set(true, forKey: "hasViewedWalkThrough")
            dismiss(animated: true, completion: nil)
      
            
        default: break
            
        }
    }
}
