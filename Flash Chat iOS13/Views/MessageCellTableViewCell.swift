//
//  MessageCellTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Kirill Kalashnikov on 3/27/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCellTableViewCell: UITableViewCell {

    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var assignmentName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
