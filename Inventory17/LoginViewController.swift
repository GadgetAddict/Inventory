





import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToApp = "SIGNED_IN"
    
    
//    let defaults = UserDefaults.standard
  
//    override func viewDidAppear(_ animated: Bool) {
//        if let alreadySignedIn = FIRAuth.auth()?.currentUser {
//            print("alreadySignedIn \(alreadySignedIn.email) ")
//            
//             self.performSegue(withIdentifier: "SIGNED_IN", sender:nil)
//        } else {
//            // sign in
//        }
//    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       let setDefaultCollectionQueue = DispatchQueue(label: "com.michael.loginSetCollectionID", qos: DispatchQoS.userInteractive)
        
        FIRAuth.auth()!.addStateDidChangeListener() { (auth, user) in
            if let user = user {
                
//                print("41 User is signed in with uid:", user.uid)
                
//                setDefaultCollectionQueue.sync {
//                    print("44 User is signed in with uid:", user.uid)
                    self.setCollection()
//                }
                
             
            } else {
//                print("60 No user is signed in.")
            }
        }
        
        
        
        
        
        
        
// 
//            // 1
//            FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
//                // 2
//                if user != nil {
// 
//                    self.performSegue(withIdentifier: "SIGNED_IN", sender:nil)
// 
//            }
//        }
    
    }
    

    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: AnyObject) {
       
        
        // Sign In with credentials.
        guard let email = textFieldLoginEmail.text, let password = textFieldLoginPassword.text else { return }
        print("92")

        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            print("95")

 
            DataService.ds.REF_USER_CURRENT.observeSingleEvent(of: .value, with: { snapshot in
                print("99")

                     if let collectionRefString = snapshot.value as? String {
                        print("  Collection ID is \(collectionRefString)")
                        COLLECTION_ID = collectionRefString

                        
                        let defaults = UserDefaults.standard
                        defaults.set(collectionRefString, forKey: "CollectionIdRef")
                    }
                
            })
 
            
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
//        self.performSegue(withIdentifier: "SIGNED_IN", sender:nil)

    }
    
    func setCollection(){
 

        DataService.ds.REF_USER_CURRENT.observeSingleEvent(of: .value, with: { snapshot in
 
  
    if let collectionRefString = snapshot.value as? String {
     
    let defaults = UserDefaults.standard
    defaults.set(collectionRefString, forKey: "CollectionIdRef")
        COLLECTION_ID = collectionRefString
               self.performSegue(withIdentifier: "SIGNED_IN", sender:nil)

        }})
            
        
 
      
        
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
    
    
 

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("prepareForSegue ")
//        
//        if segue.identifier == "SIGNED_IN" {
//            if let destination = segue.destination as? itemFeedVC {
//            destination.collectionID = ""
//            }
//        }
//    }
    
    
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
