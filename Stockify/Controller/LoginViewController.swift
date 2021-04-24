//
//  LoginViewController.swift
//  Stockify
//
//  Created by Ege Cavusoglu on 12/03/20.
//  Copyright © 2020 Group24. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController, GIDSignInDelegate{

    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var sublabel: UILabel!
    
    
    //    Global singleton instance of the user
    var theUser = User.shared //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        let status = UserDefaults.standard.bool(forKey: "loggedIn")
        
        if (status){
            signInButton.isHidden = true
            let name = UserDefaults.standard.string(forKey: "firstName")!
            sublabel.text = "Welcome, \(name)."
        }
        else {
            signOutButton.isHidden = true
            sublabel.text = "Sign in to continue."
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print ("ERROR SIGNING IN \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        
        // Log in with firebase using Google credentials.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print ("FIREBASE ERROR: \(error)")
                return
            }
            let uid = authResult!.user.uid
            let firstName = user.profile.givenName
            UserDefaults.standard.set(true, forKey: "loggedIn")
            UserDefaults.standard.set(firstName, forKey: "firstName")
            UserDefaults.standard.set(uid, forKey: "userId")
            self.dismissSigninModal()
            
        }
    }
    
    func dismissSigninModal (){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func signOutClicked(_ sender: Any) {
        print("SIGNING OUT")
        GIDSignIn.sharedInstance()?.signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
            print("COULD NOT SIGN OUT")
            return
        }
        UserDefaults.standard.set(false, forKey: "loggedIn")
        dismissSigninModal()
    }
}
