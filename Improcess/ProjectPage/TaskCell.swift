//
//  TaskCell.swift
//  Improcess
//
//  Created by MuMhu on 30/10/2561 BE.
//  Copyright © 2561 Kittitat Boonkarn. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
