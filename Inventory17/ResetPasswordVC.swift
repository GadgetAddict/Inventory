//
//  ResetPasswordVC.swift
//  Inventory
//
//  Created by Michael King on 8/3/16.
//  Copyright © 2016 Michael King. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordVC: UIViewController {

    var passedEmailAddress: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let emailAddy = self.passedEmailAddress {
            emailTextField.text = emailAddy
        }
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"Email Address", attributes:[NSForegroundColorAttributeName: UIColor.white])
        // Do any additional setup after loading the view.
    }

    
   
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func cancelBtnTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func submitBtnTapped(_ sender: AnyObject) {
        guard let emailAddress = emailTextField.text , !emailAddress.isEmpty else {
            let errMsg = "Email adress cannot be blank"
            self.pwSentAlert("Request Failed", message: errMsg)
           
            return
        }
        submitRequest(emailAddress: emailAddress)
    }
    
    
    
    func submitRequest(emailAddress: String) {
    
             FIRAuth.auth()?.sendPasswordReset(withEmail: emailAddress) { (error) in
                if error != nil {
       
               print("There was an error processing the request")
                let errMsg = "If an account matches this email address, a link will be sent to that email adress"
                self.pwSentAlert("Reset Password Request Sent", message: errMsg)
                
            } else {
                print("Password reset sent successfully")
                let errMsg = "A link will be sent to that email adress"
                self.pwSentAlert("Reset Password Request Sent", message: errMsg)

            }
                    return
                }
        }
        
     
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    func pwSentAlert(_ title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: {
            action in
        self.dismiss(animated: true, completion: nil);
            
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    

    
    
    
}
