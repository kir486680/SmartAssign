//
//  CreateViewController.swift
//  Flash Chat iOS13
//
//  Created by Kirill Kalashnikov on 3/26/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseCore
import OpalImagePicker
import Photos



let userID = Auth.auth().currentUser!.uid
var globalAssets: [PHAsset] = []
var pickerTeacherData: [String] = []
var pickerClassData: [String]  = []
let db = Firestore.firestore()
var textView: String = "Parker"
var textView1: String = "Str"
var imageTakenArray: [UIImage] = []
var imageNameArray: [String] = []
var teacherClassDict = [String: NSArray]()
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}
class CreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    
    
    var showingData: [String] = teacherClassDict["Parker"] as! [String]
   
    
    @IBOutlet weak var detailField: UITextView!
    
    @IBOutlet weak var homeworkName: UITextField!

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var pickerView1: UIPickerView!
    
    var pickedImage = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerClassData = removeDuplicates(array: pickerClassData)
        pickerTeacherData = removeDuplicates(array: pickerTeacherData)
        //getSomeData(field: "teacherName")
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView1.delegate = self
        pickerView1.dataSource = self
        self.hideKeyboardWhenTappedAround()
        print("Teacher class dict", teacherClassDict[textView])
        print("Class", pickerClassData)
        print("Teacher", pickerTeacherData)

        //print(pickerClassData)
        //print("Teachers " , pickerTeacherData)
        //let pickerClassData = getSomeData(field: "ClassName")
        // Do any additional setup after loading the view.
        // Dclare an alert

        


    }
    

 
    
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerTeacherData.count
     }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1{

            return showingData[row]
            
            
        }
        
        return pickerTeacherData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1{
            textView1 = showingData[row]
            print("Text", textView1)
            
        }else{
            print("Selected row View 1", pickerTeacherData[row])
            textView = pickerTeacherData[row]
            //print("Now", )
            //pickerView.reloadAllComponents()
            showingData = teacherClassDict[pickerTeacherData[row]] as! [String]
            pickerView1.reloadAllComponents()
        }
    }

    @IBAction func addNewHomework(_ sender: UIBarButtonItem) {
        
        if let homeworkName = homeworkName.text, let _ = Auth.auth().currentUser?.email{
            let imageArray: [UIImage] =  imageTakenArray
            print("received array", imageArray)

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myDateString = formatter.string(from: Date())
            let generated_name = "\(myDateString)\(userEmail)"
            var appendDict = ["senderID" : userID,
                              "selfName" : generated_name,
            "homeworkName" : homeworkName,
            "teacherName" : textView,
            "ClassName" : textView1,
            "NumberOfImages" : imageArray.count,
            "ImageName": imageNameArray,
            "time": myDateString,
            "detailText": self.detailField.text] as [String : Any]
            print("Array got of image URLS", imageNameArray)
//                db.collection("homeworks").addDocument(data: ["senderID" : userID,
//                "homeworkName" : homeworkName,
//                "teacherName" : textView,
//                "ClassName" : textView1,
//                "NumberOfImages" : imageArray.count,
//                "ImageName": imageNameArray,
//                "time": myDateString
//                ])

            uploadImages(userId: userID, imagesArray: imageTakenArray, assignmentName: homeworkName, passedDict: appendDict, generated_name: generated_name)



             appendToTheUser(email: userEmail, field: "uploadedHw", data: generated_name)
 
            

            print("uploaded")

            
        }
        
        navigationController?.popViewController(animated: true)

        
    }
    func triggerCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            
        }
    }
    @IBAction func takePictures(_ sender: UIButton) {
        triggerCamera()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        print("Appending to the array")
        imageTakenArray.append(image)
        print(imageTakenArray)
        self.dismiss(animated: true, completion: nil)
        let refreshAlert = UIAlertController(title: "Refresh", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.triggerCamera()
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    @IBAction func imageSelector(_ sender: UIButton) {
        print(pickerTeacherData)
        let imagePicker = OpalImagePickerController()

        //Present Image Picker
        presentOpalImagePickerController(imagePicker, animated: true, select: { (assets) in
            //Save Images, update UI
            //Dismiss Controller
            globalAssets = assets
            
            let UIImages =  getAssetThumbnail(assets: assets)
            imageTakenArray.append(contentsOf: UIImages)
            
                
            imagePicker.dismiss(animated: true, completion: nil)
        }, cancel: {
            //Cancel action?
        })
    }
    func uploadImages(userId: String, imagesArray : [UIImage], assignmentName : String, passedDict: [String:Any], generated_name: String){
        let g = DispatchGroup()
        imageNameArray.removeAll()
        var imageCount = 1;
        for image in imagesArray{
            g.enter()
            if let data = image.pngData() { // convert your UIImage into Data object using png representation
                  FirebaseStorageManager().uploadImageData(data: data, serverFileName: "image+\(userID)+\(assignmentName)+\(imageCount).png") { (isSuccess, url) in
                         //print("uploadImageData: \(isSuccess), \(url)")
                    
                    
                    imageNameArray.append("image+\(userID)+\(assignmentName)+\(imageCount).png")
                    print("image+\(userID)+\(assignmentName)+\(imageCount).png")
                    imageCount += 1
                         //imageNameArray.append("image+\(userID)+\(assignmentName)+\(imageCount).png")
                    g.leave();
                   }
            }
            
        }
        g.notify(queue: .main) {       ////// 5
            var passedDictArray = passedDict
            passedDictArray["ImageName"] = imageNameArray
            db.collection("homework").document(generated_name).setData(passedDictArray) { err in
                if let err = err {
                    print("Error creating new dictionary")
                } else {
                    print("Appended New Assignment")
                }
            }

        }
    
    }

}

func getSomeDataName(field: String) {
    db.collection("homeworks").getDocuments(){ (QuerySnapshot, error) in
        if let er = error{
           print(er.localizedDescription)
        }else{
            if let documents = QuerySnapshot?.documents{
                for document in documents{
                    if(document.data()[field] != nil) {
                        //print(document.data()[field] as! String)
                        //print("appended")
                        //print(document.data()[field] as! String)
                        pickerTeacherData.append(document.data()["teacherName"] as! String)
                    }
                    
                    
                }
                
            }
        }
        
    }

}

func teacherQuery(teacherName: String){
    let docRef = db.collection("helperData").document("teachers")
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let receivedData = document.data()!
            var teacherData = receivedData as NSDictionary
            
            for i in teacherData.allKeys{
                pickerTeacherData.append(i as! String)
            }
                
            teacherClassDict = receivedData as! [String: NSArray]
        } else {
            print("Document does not exist")
        }
    }
}


func getSomeDataCourse(field: String) {
    db.collection("homeworks").getDocuments(){ (QuerySnapshot, error) in
        if let er = error{
            print(er.localizedDescription)
        }else{
            if let documents = QuerySnapshot?.documents{
                for document in documents{
                    if(document.data()[field] != nil) {
                        //print(document.data()[field] as! String)
                        //print("appended")
                        //print(document.data()[field] as! String)
                        pickerClassData.append(document.data()["ClassName"] as! String)
                    }
                    
                    
                }
                
            }
        }
        
    }

}
func generateImageName(userId: String, assignmentName : String) -> [String] {
    
    var names: [String] = []
    for i in 1...imageTakenArray.count{
        names.append("image+\(userID)+\(assignmentName)+\(i).png")
    }
    return names
    
}

func waitSomeTime(after seconds: Int, completion: @escaping () -> Void){
    let deadline = DispatchTime.now() + .seconds(seconds)
    DispatchQueue.main.asyncAfter(deadline: deadline){
        completion()
    }
}



