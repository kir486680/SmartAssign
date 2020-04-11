//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn


var userEmail = "some"

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
       
        if let email = emailTextfield.text, let password = passwordTextfield.text{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error{
                    print(e)
                }else{
                    userEmail = email
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let myDateString = formatter.string(from: Date())
                    appendToTheUser(email: email, field: "loginTimes", data: myDateString)

                    self?.performSegue(withIdentifier: "LoginToChat", sender: self)
                }
              // ...
            }
        }
    }
    
}

