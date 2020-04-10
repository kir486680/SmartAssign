//
//  SortingAlgorithms.swift
//  Flash Chat iOS13
//
//  Created by Kirill Kalashnikov on 4/3/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation

func removeDuplicates(array: [String]) -> [String] {
    var encountered = Set<String>()
    var result: [String] = []
    for value in array {
        if encountered.contains(value) {
            // Do not add a duplicate element.
        }
        else {
            // Add value to the set.
            encountered.insert(value)
            // ... Append the value.
            result.append(value)
        }
    }
    return result
}
