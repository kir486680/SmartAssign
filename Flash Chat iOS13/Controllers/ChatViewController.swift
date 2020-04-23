//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseCore
import OpalImagePicker
import Photos


var classNameView: [String] = []
var asignmentName: [String] = []
var teacherNameView: [String] = []
var indexOfField: [String] = []
var userNumebrID: String =  "s"
var imageNumber: Int = 1


//struct MyKeys {
//    static let imagesFolder = "uploads"
//    static let imagesCollection = "imagesCollection"
//    static let uid = "uid"
//    static let imageUrl = "imageUrl"
//
//}

class ChatViewController: UIViewController, OpalImagePickerControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextfield: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    var assignments: [Assignments] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Homework Name"

        navigationItem.hidesBackButton = true
        let nib = UINib(nibName: "MessageCellTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CellDemo")
        tableView.delegate = self
        tableView.dataSource = self
        getDictionaryForTableView()
        
        //print("registered")

    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "createNote", sender: self)
    }
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    func getDictionaryForTableView() {
        db.collection("homework").addSnapshotListener(){ (QuerySnapshot, error) in
            if let er = error{
                print(er.localizedDescription)
            }else{
                if let documents = QuerySnapshot?.documents{
                    self.assignments.removeAll()
                    print(documents.count, "Number of docs")
                    if documents.count != 0{
                        for document in documents{
                            
                            print(document, "Printed Document",document.data()["homeworkName"])
                            let assign = Assignments(selfName:document.data()["selfName"] as! String , teacherName: document.data()["teacherName"] as! String, assignmentName: document.data()["homeworkName"] as! String)
                            
                            self.assignments.append(assign)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            
                            
                        }
                    }

                    
                }
            }
            
        }

    }
    


}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("using")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDemo", for: indexPath) as! MessageCellTableViewCell
        //print(cell)
        cell.teacherName.text = assignments[indexPath.row].teacherName
        cell.assignmentName.text = assignments[indexPath.row].assignmentName
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = assignments[indexPath.row].selfName
        passedName = assignments[indexPath.row].assignmentName
        passedTeacher = assignments[indexPath.row].teacherName
        performSegue(withIdentifier: "goWatch", sender: self)
    }
    
    
}





func getAssetThumbnail(assets: [PHAsset]) -> [UIImage] {
    var arrayOfImages = [UIImage]()
    for asset in assets {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 1920, height: 1080), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            arrayOfImages.append(result!)
        })
    }

    return arrayOfImages
}


