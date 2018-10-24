//
//  AddingCell.swift
//  Improcess
//
//  Created by MuMhu on 24/10/2561 BE.
//  Copyright © 2561 Kittitat Boonkarn. All rights reserved.
//

import UIKit

class AddingCell: UITableViewCell {

    
    @IBOutlet weak var addStepTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func handlePlus(_ sender: Any) {
    }
    
}
