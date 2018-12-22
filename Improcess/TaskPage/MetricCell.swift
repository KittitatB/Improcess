//
//  MetricCell.swift
//  Improcess
//
//  Created by MuMhu on 19/12/2561 BE.
//  Copyright © 2561 Kittitat Boonkarn. All rights reserved.
//

import UIKit
import iOSDropDown

class MetricCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dropDown: DropDown!
    override func awakeFromNib() {
        super.awakeFromNib()
        dropDown.optionArray = ["Option 1", "Option 2", "Option 3"]
        // Its Id Values and its optional
        dropDown.optionIds = [1,23,54,22] 
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class SummaryCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
