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


func getImages(){
    for i in 0...imageNumber{
        imageName.append("image+\(userNumebrID)+\(passedName)+\(i).png")
    }
}

class WatchViewController: UIViewController {

    
    @IBOutlet weak var assignmentName: UILabel!
    @IBOutlet weak var AssignmentTeacher: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
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
    
    
    
    func get_img(){
        

        let docRef = db.collection("homeworks").document(selectedIndex)
        print(docRef)
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                //print("Document data: \(dataDescription)")
                
                //print(yourArray.count)
                
                let imageName = document.data()!["ImageName"] as! [String]
                print("Name" ,imageName)
                downloadFromServer(url: imageName)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

                    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                    loadingIndicator.hidesWhenStopped = true
                    loadingIndicator.style = UIActivityIndicatorView.Style.gray
                    loadingIndicator.startAnimating();

                    alert.view.addSubview(loadingIndicator)
                    self.present(alert, animated: true, completion: nil)

                }
                //let gsReference = storage.reference(forURL: "gs://homeworkapp-21143.appspot.com/uploads/\(imageName)")

//                for i in imageName{
//                    let url = URL(string: i)
//                    let resource = ImageResource(downloadURL: url!)
//
//                    imageArrayWatch.append(resource)
//                    print("Que")
//                    var someImageView : UIImageView
//                    someImageView  = UIImageView(frame:CGRect(x:0, y: 250, width: 480, height: 320));
//                    DispatchQueue.main.async {
//                    someImageView.kf.setImage(with: resource, completionHandler: { (result) in
//                        switch result {
//                        case .success(_):
//                            print("Done")
//                        case .failure(let err):
//                            print(err.localizedDescription)
//                        }
//                    })
//                        self.view.addSubview(someImageView)
//                    self.imageView.kf.setImage(with: resource, completionHandler: { (result) in
//                        switch result {
//                        case .success(_):
//                            print("Done")
//                        case .failure(let err):
//                            print(err.localizedDescription)
//                        }
//                    })
//                    }
//                }
                
                

            } else {
                print(error?.localizedDescription)
                print("eroro")
                
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



