//
//  user.swift
//  Flash Chat iOS13
//
//  Created by Kirill Kalashnikov on 4/6/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation


struct userNew{
    var email: String
    var loginTimes: [String]
    let uploadedHw: [String]
    var dictionary: [String: Any]{
        return ["email":email,
                "loginTimes": loginTimes,
                "uploadedHw": uploadedHw
        ]
    }
    mutating func appendCurrentDate(){
        //If successful go to the main page
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let myString = formatter.string(from: Date())
        loginTimes.append(myString)
    }
}
