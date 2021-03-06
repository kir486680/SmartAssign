//
//  WatchViewController.swift
//  Flash Chat iOS13
//
//  Created by Kirill Kalashnikov on 3/28/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Kingfisher
import PDFKit

var selectedIndex: String = "d"
var passedName: String = "j"
var passedTeacher: String = "j"
var imageName: [String] = []
var assignmentImages: [UIImage] = []
var imageArrayWatch: [UIImage] = []
var linkImageArray: [URL] = []
var linkImageName: [String] = []

func getImages(){
    for i in 0...imageNumber{
        imageName.append("image+\(userNumebrID)+\(passedName)+\(i).png")
    }
}

class WatchViewController: UIViewController {
    var vSpinner : UIView?
    
    @IBOutlet weak var detailField: UITextView!
    @IBOutlet weak var assignmentName: UILabel!
    @IBOutlet weak var AssignmentTeacher: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    

    
    
    var imageNumber: Int = 0
    
    override func viewDidLoad() {
        //watch_image()
        
        super.viewDidLoad()
        
        //getImages()
        print(selectedIndex , "Selected")
        assignmentName.text = passedName
        AssignmentTeacher.text = passedTeacher
        get_img()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            imageArrayWatch.removeAll()
            linkImageName.removeAll()
            linkImageArray.removeAll()
            print("Removed")
        }
    }
    

    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    func get_img(){
        
        let docRef = db.collection("homework").document(selectedIndex)
        print(docRef)
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                //print("Document data: \(dataDescription)")
                
                //print(yourArray.count)
                self.detailField.text = document.data()!["detailText"] as! String
                self.imageNumber = document.data()!["NumberOfImages"] as! Int
                let imageName = document.data()!["ImageName"] as! [String]
                linkImageName = imageName
                linkImageArray = imageName.compactMap { URL(string:$0) }
                print("Name" ,self.imageNumber)
                
                self.downloadFromServer(url: imageName)
                
                print("Exit")

                
                
            } else {
                print(error?.localizedDescription)
                print("eroro")
                
            }

            
        }
    }
    func download(name: String){

    }
    func downloadFromServer(url: [String]){
        self.showSpinner(onView: self.view)
        let g = DispatchGroup()
        for i in url{
            
            
            
            
            g.enter()
            let url = "uploads/\(i)"
            print(url)
            let storage = Storage.storage()
            let ref = storage.reference().child(url)
            ref.getData(maxSize: 1 * 4000 * 4000) { data, error in
                if let error = error {
                    print("\(error)")
                }

                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    imageArrayWatch.append(image!)
                    g.leave();
                }
            }
            g.notify(queue: .main) {       ////// 5
                print("FINALLY")
                self.removeSpinner()

            }
            
        }

    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIViewController {
         @objc func navigationShouldPopOnBackButton() -> Bool {
         return true
        }
    }

extension UINavigationController: UINavigationBarDelegate {
         public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
              return self.topViewController?.navigationShouldPopOnBackButton() ?? true
        }
    }


