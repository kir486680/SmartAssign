//
//  profileViewController.swift
//  Flash Chat iOS13
//
//  Created by Kirill Kalashnikov on 4/7/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit



class profileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    
    var assignments: [Assignments] = []
    var indexOfField: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyAssignments(email: userEmail)
        let nib = UINib(nibName: "MessageCellTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CellDemo")
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
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
        //selectedIndex = self.indexOfField[indexPath.row]
        selectedIndex = assignments[indexPath.row].selfName
        passedName = assignments[indexPath.row].assignmentName
        passedTeacher = assignments[indexPath.row].teacherName
        performSegue(withIdentifier: "goWatchSelf", sender: self)
    }
    func getMyAssignments(email: String){
        
        
        
        db.collection("user").document(email).getDocument { (document, error) in
        if let document = document, document.exists {
            let receivedTimes = document.data()!["uploadedHw"] as! [String]
            for i in receivedTimes{
                db.collection("homework").document(i).getDocument { (document, error) in
                if let document = document, document.exists {
                    let assign = Assignments(selfName: document.data()!["selfName"] as! String, teacherName: document.data()!["teacherName"] as! String, assignmentName: document.data()!["homeworkName"] as! String, assignmenDate: document.data()!["time"] as! String)
                    self.assignments.append(assign)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    }
                }
            }
        } else {
            print("Document does not exist")
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
