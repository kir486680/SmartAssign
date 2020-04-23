//
//  Data.swift
//  Flash Chat iOS13
//
//  Created by Kirill Kalashnikov on 4/22/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation
import UIKit
struct Datas {
    
    static let imageNames:[String] = linkImageName
    
    static let images:[UIImage] = Self.imageNames.compactMap { UIImage(named: $0)! }
    
    static let imageUrls:[URL] = linkImageArray
}
