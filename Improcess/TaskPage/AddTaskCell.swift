//
//  AddTaskCell.swift
//  Improcess
//
//  Created by MuMhu on 19/12/2561 BE.
//  Copyright © 2561 Kittitat Boonkarn. All rights reserved.
//

import UIKit

protocol TaskLogic: class {
    func addTask()
}

class AddTaskCell: UITableViewCell {
    
    weak var cellInteractor: TaskLogic?
    
    @IBAction func handleAdd(_ sender: Any) {
        cellInteractor?.addTask()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}

class AddDefectCell: UITableViewCell {
    
    weak var cellInteractor: TaskLogic?

    @IBAction func handleAdd(_ sender: Any) {
        cellInteractor?.addTask()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
