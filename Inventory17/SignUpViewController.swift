//
//  SignUpViewController.swift
//  ClientColorKeeper
//
//  Created by Michael King on 11/13/16.
//  Copyright © 2016 Microideas. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    var user: User!
    let usersRef = FIRDatabase.database().reference(withPath: "users")

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    @IBOutlet weak var nickNameField: UITextField!

    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let font = UIFont(name: "HelveticaNeue-Thin", size: 19)!
            let attributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName : font]

            self.firstNameField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes:attributes)

            self.emailField.attributedPlaceholder = NSAttributedString(string:"Email Address", attributes:attributes)

            self.passwordField.attributedPlaceholder = NSAttributedString(string:"Choose Password", attributes:attributes)

            self.passwordField2.attributedPlaceholder = NSAttributedString(string:"Re-Enter Password", attributes:attributes)
            
            self.nickNameField.attributedPlaceholder = NSAttributedString(string:"Inventory nickname  ie: Home", attributes:attributes)
            
            
            // Do any additional setup after loading the view.
        }
        
    
    
        func checkForEmptyFields() {
            
            guard  firstNameField.text != "" else {
                let errMsg = "First name is Required "
                signupErrorAlert(title: "Registration Incomplete", message: errMsg)
                return
            }
            
            guard emailField.text != "" else {
                let errMsg = "Email Address Required"
                signupErrorAlert(title: "Registration Incomplete", message: errMsg)
                return
            }
            
            guard passwordField.text  != "" else {
                let errMsg = "Password is Required"
                signupErrorAlert(title: "Registration Incomplete", message: errMsg)
                return
            }
            
            guard passwordField2.text  == passwordField.text else {
                let errMsg = "Both Passwords must match."
                signupErrorAlert(title: "Registration Incomplete", message: errMsg)
                return
            }
            
            guard nickNameField.text  != "" else {
                let errMsg = "Inventory nickname is required."
                signupErrorAlert(title: "Registration Incomplete", message: errMsg)
                return
            }
   
    }
    
         
    
        
        @IBAction func createAccountTapped(sender: AnyObject) {
            checkForEmptyFields()
            
            FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                if let error = error {
                    self.signupErrorAlert(title: "Oops", message:error.localizedDescription)
                    return
                } else {
                    print("MICHAEL: Successfully authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                }
            })
    }
 

func completeSignIn(id: String, userData: Dictionary<String, String>) {

// 1  Create Salon in Database with PUSH ID

    let inventoryBaseRef = FIRDatabase.database().reference(withPath: "collections")
    let newCollectionRef =   inventoryBaseRef.childByAutoId()
    newCollectionRef.setValue(["inventoryName" : self.nickNameField.text!])

//  2  Create User in Database and Create Tree/Node for User's Salon using Auth ID and Push ID

    let currentUserRef = self.usersRef.child(id)

//                print("I calling the SET VALUE for USERS")

    currentUserRef.setValue(["name" : self.firstNameField.text!,
                             "email" : self.emailField.text!,
                             "collectionAccess":
                                [  "inventoryName": self.nickNameField.text!,
                                   "collectionId" : newCollectionRef.key]])
    
    
    DataService.ds.getInventoryReference()

   performSegue(withIdentifier: "SIGNED_UP", sender: nil)

    }







        @IBAction func cancelCreateAccount(sender: AnyObject) {
            self.dismiss(animated: true, completion: {})
        }
        
        func signupErrorAlert(title: String, message: String) {
            
            // Called upon signup error to let the user know signup didn't work.
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    
        
        
}


// 
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // 1
//        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
//            if user != nil {
//
//                guard let user = user else { return }
//                self.user = User(authData: user, name: self.firstNameField.text!)
//        
//                
//                // 2  Create Salon in Database with PUSH ID
//                
//                let salonBaseRef = FIRDatabase.database().reference(withPath: "salon")
//                let newSalonRef =   salonBaseRef.childByAutoId()
//                newSalonRef.setValue(["salon name" : self.salonNameField.text!])
//                
//                //  3  Create User in Database and Create Tree/Node for User's Salon using Auth ID and Push ID
//                
//                
//                let currentUserRef = self.usersRef.child(self.user.uid)
//                
//                print("I calling the SET VALUE for USERS")
//                
//                currentUserRef.setValue(["name" : self.user.firstName,
//                                         "email" : self.user.email,
//                                         "Salon Access":
//                                            [  "salonName": self.salonNameField.text!,
//                                               "salonId" : newSalonRef.key]])
//                
//            }
//
//                self.performSegue(withIdentifier: "SIGNED_UP", sender: nil)
//            }
//        
//    
//    
//    let font = UIFont(name: "HelveticaNeue-Thin", size: 19)!
//    let attributes = [
//        NSForegroundColorAttributeName: UIColor.white,
//        NSFontAttributeName : font]
//    
//    self.firstNameField.attributedPlaceholder = NSAttributedString(string: "First Name",
//    attributes:attributes)
//    
//    
//    self.emailField.attributedPlaceholder = NSAttributedString(string:"Email Address", attributes:attributes)
//    
//    self.passwordField.attributedPlaceholder = NSAttributedString(string:"Choose Password", attributes:attributes)
//    
//    self.passwordField2.attributedPlaceholder = NSAttributedString(string:"Re-Enter Password", attributes:attributes)
//    
//    self.salonNameField.attributedPlaceholder = NSAttributedString(string:"Pick a nickname for your collection.  Example: Home Inventory", attributes:attributes)
//    
//    // Do any additional setup after loading the view.
//}
//
////    func enterTempText() {
////        firstNameField.text = "Michael"
////         emailField.text = "me@me.com"
////        passwordField.text = "121212"
////       passwordField2.text = "121212"
////       nickNameField.text = "HomeVentory"
////    }
//func checkForEmptyFields() {
//    
//    guard  firstNameField.text != "" else {
//        let errMsg = "First name is Required "
//        signupErrorAlert("Registration Incomplete", message: errMsg)
//        return
//    }
//    
//    guard emailField.text != "" else {
//        let errMsg = "Email Address Required"
//        signupErrorAlert("Registration Incomplete", message: errMsg)
//        return
//    }
//    
//    guard passwordField.text  != "" else {
//        let errMsg = "Password is Required"
//        signupErrorAlert("Registration Incomplete", message: errMsg)
//        return
//    }
//    
//    guard passwordField2.text  == passwordField.text else {
//        let errMsg = "Both Passwords must match."
//        signupErrorAlert("Registration Incomplete", message: errMsg)
//        return
//    }
//    
//    guard salonNameField.text  != "" else {
//        let errMsg = "Nickname is Required but can be changed later"
//        signupErrorAlert("Registration Incomplete", message: errMsg)
//        return
//    }
//    
//    createAccount()
//    
//}
//
//@IBAction func createAccountTapped(_ sender: AnyObject) {
//    checkForEmptyFields()
//    
//}
//
//
//
//    func createAccount() {
//        let firstName = firstNameField.text
//        let emailField = self.emailField.text
//        let passwordField = self.passwordField.text
//        let salonNameField = self.salonNameField.text
//        
//
//        
//    // 2
//    FIRAuth.auth()!.createUser(withEmail: emailField!, password: passwordField!) { user, error in
//        if error != nil {
//            
//            FIRAuth.auth()?.createUser(withEmail: emailField!, password: passwordField!) { (user, error) in
//                
//                if error != nil {
//              
//                    if let errCode = FIRAuthErrorCode(rawValue: error as! Int) {
//                        
//                        switch errCode {
//                        case .errorCodeInvalidEmail:
//                            self.signupErrorAlert("Registration Failed", message: "A Valid Email Address is Required.")
//                        case .errorCodeEmailAlreadyInUse:
//                            self.signupErrorAlert("Registration Failed", message: "That Email Address is already Taken.")
//                        default:
//                            self.signupErrorAlert("Registration Failed", message: "Verify all fields and try again.")
//                        }
//                        
//                    }
//                    
//                    
//                } else {
//                    
//                    // 4  Auth/Signin
//                    print("I calling the  SIGN IN FUNCTION")
//
//                self.signIn(email: emailField!, password: passwordField!)
//
//                }
//            }
//        }
//        }
//    }
//    
//    
//    func signIn(email: String, password: String)  {
//     print("I am in the SIGN IN FUNCTION")
//        
//        FIRAuth.auth()!.signIn(withEmail: email,
//                               password: password)
//    }
//    
//    @IBAction func cancelCreateAccount(_ sender: AnyObject) {
//        self.dismiss(animated: true, completion: {})
//    }
//
//    
//    func signupErrorAlert(_ title: String, message: String) {
//        
//        // Called upon signup error to let the user know signup didn't work.
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
//
//    
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
