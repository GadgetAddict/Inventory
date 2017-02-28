





import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToApp = "SIGNED_IN"
    
    
    let defaults = UserDefaults.standard
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                print("USER UID is \(user?.uid)")
                self.completeSignIn(id: (user?.uid)!)
            }
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        
        
        // Sign In with credentials.
        guard let email = textFieldLoginEmail.text, let password = textFieldLoginPassword.text else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if (error != nil) {
                // an error occurred while attempting login
                if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        self.loginErrorAlert("Sign In Failed", message: "Enter a Valid Email Address.")
                    case .errorCodeWrongPassword:
                        self.loginErrorAlert("Sign In Failed", message: "User Name and Passwords Do Not Match.")
                    default:
                        self.loginErrorAlert("Sign In Failed", message: "Please Check Your Information and Try Again.")
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func unwindLogOut(sender: UIStoryboardSegue) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
             self.dismiss(animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
        self.textFieldLoginPassword.text = ""
    }
    
    
    func loginErrorAlert(_ title: String, message: String) {
        // Called upon login error to let the user know login didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func completeSignIn(id: String) {
   print("Complete Sign in Function")
        DataService.ds.getInventoryReference()

         self.performSegue(withIdentifier: self.loginToApp, sender: nil)
        
    }
    
    
}

    


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
}



//
//
//
//
//
//import UIKit
//import Firebase
//
//class LoginViewController: UIViewController {
//    
//    // MARK: Constants
//    let loginToApp = "SIGNED_IN"
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // 1
//        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
//            // 2
//            if user != nil {
//                print("USER UID is \(user?.uid)")
//                 self.completeSignIn(id: (user?.uid)!)
//                }
//        }
//    }
//    
//    // MARK: Outlets
//    @IBOutlet weak var textFieldLoginEmail: UITextField!
//    @IBOutlet weak var textFieldLoginPassword: UITextField!
//    
//    // MARK: Actions
//    @IBAction func loginDidTouch(_ sender: AnyObject) {
// 
//    
//        // Sign In with credentials.
//        guard let email = textFieldLoginEmail.text, let password = textFieldLoginPassword.text else { return }
//        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
//            if (error != nil) {
//                // an error occurred while attempting login
//                if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
//                    switch errCode {
//                     case .errorCodeInvalidEmail:
//                        self.loginErrorAlert("Sign In Failed", message: "Enter a Valid Email Address.")
//                     case .errorCodeWrongPassword:
//                        self.loginErrorAlert("Sign In Failed", message: "User Name and Passwords Do Not Match.")
//                    default:
//                        self.loginErrorAlert("Sign In Failed", message: "Please Check Your Information and Try Again.")
//                    }
//                }
//            }
//        }
//    }
//    
//    
// 
//    @IBAction func unwindLogOut(sender: UIStoryboardSegue) {
//        
//        let firebaseAuth = FIRAuth.auth()
//        do {
//            try firebaseAuth?.signOut()
//            self.dismiss(animated: true, completion: nil)
//            
//        } catch let signOutError as NSError {
//            print ("Error signing out: \(signOutError.localizedDescription)")
//        }
//        self.textFieldLoginPassword.text = ""
//    }
// 
//
//      func loginErrorAlert(_ title: String, message: String) {
//    // Called upon login error to let the user know login didn't work.
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
//    
//    
//    func completeSignIn(id: String) {
//DataService.ds.getSalonReference()
////        let defaults = UserDefaults.standard
////        defaults.set(SalonIdString, forKey: "SalonId")
//        
//        self.performSegue(withIdentifier: self.loginToApp, sender: nil)
//
//    }
//    
//}
//
//
//extension LoginViewController: UITextFieldDelegate {
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == textFieldLoginEmail {
//            textFieldLoginPassword.becomeFirstResponder()
//        }
//        if textField == textFieldLoginPassword {
//            textField.resignFirstResponder()
//        }
//        return true
//    }
//    
//}
