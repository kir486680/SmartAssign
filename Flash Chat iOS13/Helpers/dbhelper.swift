//
//  dbhelper.swift
//  Flash Chat iOS13
//
//  Created by Kirill Kalashnikov on 4/6/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation
import UIKit

func appendToTheUser (email: String, field: String, data: String)
{
    
    db.collection("user").document(email).getDocument { (document, error) in
    if let document = document, document.exists {
        var receivedTimes = document.data()![field] as! [String]

        receivedTimes.append(data)
        print(receivedTimes)
        db.collection("user").document(email).updateData([field : receivedTimes])
        print("Updated")
    } else {
        print("Document does not exist")
    }
    }
    
}



