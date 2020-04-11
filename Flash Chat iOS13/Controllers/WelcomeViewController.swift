//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel
import Firebase
import GoogleSignIn


class WelcomeViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        let gSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 48))
        gSignIn.center = view.center
        view.addSubview(gSignIn)
        titleLabel.text = "⚡️SmartAssign"
        //getSomeDataName(field: "teacherName")
        //getSomeDataCourse(field: "ClassName")
        teacherQuery(teacherName: "Parker")
        //getDictionaryForTableView()
        

    }

    @IBAction func googleSignInPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
        print(error.localizedDescription)
        return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
        if let error = error {
        print(error.localizedDescription)
        } else {
            let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
            userEmail = user.profile.email
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myDateString = formatter.string(from: Date())
            appendToTheUser(email: user.profile.email, field: "loginTimes", data: myDateString)
            
            var someUser = userNew(email: user.profile.email, loginTimes: [], uploadedHw: [])
            someUser.appendCurrentDate()
            let docRef = db.collection("user").whereField("email", isEqualTo: user.profile.email).limit(to: 1)
            docRef.getDocuments { (querysnapshot, error) in
                if error != nil {
                    db.collection("user").document(user.profile.email).setData(someUser.dictionary) { err in
                        if let err = err {
                            print("Error creating user")
                        } else {
                            print("User created")
                        }
                    }
                } else {
                    if let doc = querysnapshot?.documents, !doc.isEmpty {
                        print("Document is present.")
                    }
                }
            }
            
            self.performSegue(withIdentifier: "googleLogIn", sender: self)
            // Add a new document with a generated ID

        //This is where you should add the functionality of successful login
        //i.e. dismissing this view or push the home view controller etc
        }
    }

}
}
