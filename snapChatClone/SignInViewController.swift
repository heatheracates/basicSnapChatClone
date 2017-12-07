//
//  SignInViewController.swift
//  snapChatClone
//
//  Created by Heather Cates on 12/5/17.
//  Copyright © 2017 Heather Cates. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("we tried to sign in")
            if (error != nil){
                print("error in sign in: \(error!)")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("we tried to create a user")
                    
                    if (error != nil){
                        print("error in creating user: \(error!)")
                    }
                    else{
                     print("user created successfully")
                    //add them to the DB
                    Database.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                        self.performSegue(withIdentifier: "signInSegue", sender: nil)                    }
            })
        }
        else{
            print("signed in successfully")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)

        }
    }
}
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


}

