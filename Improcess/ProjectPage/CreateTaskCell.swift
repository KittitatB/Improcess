//
//  CreateTaskCell.swift
//  Improcess
//
//  Created by MuMhu on 27/4/2562 BE.
//  Copyright © 2562 Kittitat Boonkarn. All rights reserved.
//

import UIKit

protocol CreateTaskLogic: class {
    func createTask()
}

class CreateTaskCell: UITableViewCell {
    
    weak var cellInteractor: CreateTaskLogic?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func handleAddTask(_ sender: Any) {
        self.cellInteractor?.createTask()
    }
}
