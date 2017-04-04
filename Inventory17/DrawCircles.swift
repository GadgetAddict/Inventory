//
//  DrawCircles.swift
//  Inventory17
//
//  Created by Michael King on 3/23/17.
//  Copyright © 2017 Microideas. All rights reserved.
//

import Foundation
import UIKit
import ExpandingMenu

class DrawCircle: UIViewController {
    
    override func viewDidLoad() {
    
    let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        
    let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "chooser-button-tab")!, centerHighlightedImage: UIImage(named: "chooser-button-tab-highlighted")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 72.0)
        // Bottom dim view
        menuButton.bottomViewColor = UIColor.red
        menuButton.bottomViewAlpha = 0.2
        
        // Whether the tapped action fires when title are tapped
        menuButton.titleTappedActionEnabled = false
        
        // Menu item direction
        menuButton.expandingDirection = .bottom
        menuButton.menuTitleDirection = .right
        
        // The action when the menu appears/disappears
        menuButton.willPresentMenuItems = { (menu) -> Void in
            print("MenuItems will present.")
        }
        
        menuButton.didPresentMenuItems = { (menu) -> Void in
            print("MenuItems will present.")
        }
        
        menuButton.willDismissMenuItems = { (menu) -> Void in
            print("MenuItems dismissed.")
        }
        
        menuButton.didDismissMenuItems = { (menu) -> Void in
            print("MenuItems will present.")
        }
        
        // Expanding Animation
        menuButton.enabledExpandingAnimations = [] // No animation
        
        menuButton.enabledExpandingAnimations = AnimationOptions.All.symmetricDifference(.MenuItemRotation)
        
        // Folding Animation
        menuButton.enabledFoldingAnimations = .All
        
        menuButton.enabledFoldingAnimations = [.MenuItemMoving, .MenuItemFade, .MenuButtonRotation]
        view.addSubview(menuButton)
    
    let item1 = ExpandingMenuItem(size: menuButtonSize, title: "Music", image: UIImage(named: "chooser-moment-icon-music")!, highlightedImage: UIImage(named: "chooser-moment-icon-music-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
        // Do some action
    }
    
    
    
    let item5 = ExpandingMenuItem(size: menuButtonSize, title: "Sleep", image: UIImage(named: "chooser-moment-icon-sleep")!, highlightedImage: UIImage(named: "chooser-moment-icon-sleep-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
        // Do some action
    }
    
    menuButton.addMenuItems([item1, item5])
    
    }
    
  //  let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
   // let img = renderer.image { ctx in
     //   let paragraphStyle = NSMutableParagraphStyle()
       // paragraphStyle.alignment = .center
        
    //    let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSParagraphStyleAttributeName: paragraphStyle]
        
      //  let string = "How much wood would a woodchuck\nchuck if a woodchuck would chuck wood?"
 //       string.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
   //i  }
//
//    @IBOutlet weak var blueView: UIView!
//    
//    
//    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var imageHolder: UIImageView!
//    
//    
//    @IBOutlet weak var addToBoxButton: UIButton!
//    
//    @IBOutlet weak var editQrButton: UIButton!
//    
//    @IBOutlet weak var editPhotoButton: UIButton!
//    
//    @IBOutlet weak var showMenuButtons_Button: UIButton!
//    
//    @IBAction func moveButtonAction(_ sender: UIButton) {
//        // 1
//        let newConstraint = NSLayoutConstraint(item: blueView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: self.view.frame.width)
//        
//        // 2
//        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut , animations: {
//            self.view.removeConstraint(self.leadingConstraint)
//            self.view.addConstraint(newConstraint)
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//        
//        // 3
//        leadingConstraint = newConstraint
//    
//    }
//    
//    
//    
//    @IBOutlet weak var camera_bottomConstraint: NSLayoutConstraint!  //66
//    @IBOutlet weak var camera_centerXConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var addToBoxLeading: NSLayoutConstraint!
//    @IBOutlet weak var addToBoxBottom: NSLayoutConstraint!
//    
//    
//    
//    func moveButtonsConstraints()  {
//        let New_addToBoxLeading = NSLayoutConstraint(item: addToBoxButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: self.addToBoxLeading.constant)
//        let New_addToBoxBottom = NSLayoutConstraint(item: addToBoxButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: self.addToBoxBottom.constant)
//
//        let New_cameraLeading = NSLayoutConstraint(item: editPhotoButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: self.camera_centerXConstraint.constant)
//
//        let NEW_cameraBottom = NSLayoutConstraint(item: editPhotoButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: self.camera_bottomConstraint.constant)
//
//        // 2
//        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut , animations: {
////             remove constraints
//            self.view.removeConstraint(self.leadingConstraint)
//
////            add constraints
//            self.view.addConstraint(New_addToBoxLeading)
//            self.view.addConstraint(New_addToBoxBottom)
//            self.view.addConstraint(New_cameraLeading)
//            self.view.addConstraint(NEW_cameraBottom)
//            
//            
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//        self.addToBoxButton.alpha = 1
//        self.editPhotoButton.alpha = 1
//        self.editQrButton.alpha = 1
//        // 3
////        leadingConstraint = newConstraint
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("Can you print a constraint- \(camera_bottomConstraint.constant)")
//        
//        self.addToBoxButton.alpha = 0
//        self.editPhotoButton.alpha = 0
//        self.editQrButton.alpha = 0
//        
////        editQrButtonCenter = editQrButton.center
////        editPhotoButtonCenter = editPhotoButton.center
////        addtoBoxButtonCenter = addToBoxButton.center
////        
////        self.addToBoxButton.center = self.showMenuButtons_Button.center
////        self.editPhotoButton.center = self.showMenuButtons_Button.center
////        self.editQrButton.center = self.showMenuButtons_Button.center
//        
//        
//}
//    
//    
//    
//    
//    
//        @IBAction func menuClicked(_ sender: UIButton) {
//            if showMenuButtons_Button.currentImage == #imageLiteral(resourceName: "menu") {
//                print(" MENU CLICKED: I WAS OFF Image")
//moveButtonsConstraints()
////                UIView.animate(withDuration: 0.3, animations: {
////                    // animation here
////                    self.addToBoxButton.alpha = 1
////                    self.editPhotoButton.alpha = 1
////                    self.editQrButton.alpha = 1
////                    
////                    self.addToBoxButton.center = self.addtoBoxButtonCenter
////                    self.editPhotoButton.center = self.editPhotoButtonCenter
////                    self.editQrButton.center = self.editQrButtonCenter
////                    
////                    
////                })
////            } else {
////                print(" MENU CLICKED: I WAS On - opposite Image")
////
////                UIView.animate(withDuration: 0.3, animations: {
////                    self.addToBoxButton.alpha = 0
////                    self.editPhotoButton.alpha = 0
////                    self.editQrButton.alpha = 0
////                    
////                    self.addToBoxButton.center = self.showMenuButtons_Button.center
////                    self.editPhotoButton.center = self.showMenuButtons_Button.center
////                    self.editQrButton.center = self.showMenuButtons_Button.center
////                    
////                    
////                })
//            }
//   
//            
//            
//            toggleMenuButton(button: sender, onImage: #imageLiteral(resourceName: "menu"), offImage: #imageLiteral(resourceName: "menu_opposite"))
//            print(" RUN TOGGLE")
//        }
//        
//        func toggleMenuButton(button: UIButton, onImage: UIImage, offImage: UIImage)  {
//            print(" IN THE  TOGGLE")
//
//            if button.currentImage == offImage {
//                print(" I WAS OFF Image (opposite color)")
//
//                button.setImage(onImage, for: .normal)
//            } else {
//                print(" I WAS ON Image")
//
//                button.setImage(offImage, for: .normal)
//            }
//        }
//        
//        
//        
    
        
   
    
//        imageHolder.image = {
//            var qrCode = QRCode("http://github.com/aschuch/QRCode")!
//            qrCode.size = self.imageHolder.bounds.size
//            qrCode.errorCorrection = .High
//            return qrCode.image
//        }()
//    
    
    
//    }
        
//        let image = generateQRCode(from: "Hacking with Swift is the best iOS coding tutorial I've ever read!")
//        imageHolder.image  = image
//        
//    }
//    
//    func generateQRCode(from string: String) -> UIImage? {
//        let data = string.data(using: String.Encoding.ascii)
//        
//        if let filter = CIFilter(name: "CIQRCodeGenerator") {
//            filter.setValue(data, forKey: "inputMessage")
////            filter.color = CIColor(rgba: "16a085")
//            
//            
//
//            let transform = CGAffineTransform(scaleX: 3, y: 3)
//            
//            if let output = filter.outputImage?.applying(transform) {
//                return UIImage(ciImage: output)
//            }
//        }
//        
//        return nil
//    }

 
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let size:CGFloat = 35.0 // 35.0 chosen arbitrarily
//        
//        let countLabel = UILabel()
//        countLabel.text = "5"
//        countLabel.textColor = .green
//        countLabel.textAlignment = .center
////        countLabel.font.withSize(14) // UIFont.labelFontSize = 14 //UIFont.systemFontSize(14)
////        countLabel.bounds = CGRect(x:0.0, y:0.0, width: size, height:size)
//        countLabel.layer.cornerRadius = size / 2
//        countLabel.layer.borderWidth = 3.0
//        countLabel.layer.backgroundColor = UIColor.clear.cgColor
//        countLabel.layer.borderColor = UIColor.green.cgColor
//        
////        countLabel.center = CGPoint(x: 200.0, y: 200.0)
//        
//        self.view.addSubview(countLabel)
//    }
    
}
