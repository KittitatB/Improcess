//
//  TemplateCell.swift
//  Improcess
//
//  Created by MuMhu on 7/11/2561 BE.
//  Copyright © 2561 Kittitat Boonkarn. All rights reserved.
//

import UIKit

class TemplateCell: UITableViewCell {
    
    @IBOutlet weak var templateImage: UIImageView!
    @IBOutlet weak var templateName: UILabel!
    @IBOutlet weak var templateDetail: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
