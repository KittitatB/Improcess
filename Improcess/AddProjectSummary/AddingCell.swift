//
//  AddingCell.swift
//  Improcess
//
//  Created by MuMhu on 24/10/2561 BE.
//  Copyright © 2561 Kittitat Boonkarn. All rights reserved.
//

import UIKit

protocol CellLogic: class {
    func addStep(name: String)
    func showDoneButton()
    func hideDoneButton()
    func deleteStep(index: Int)
    func updateStepDetail(index: Int, newDescription: String)
}

class AddingCell: UITableViewCell {

    @IBOutlet weak var addStepTextField: UITextField!
    weak var cellInteractor: CellLogic?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func handleEditing(_ sender: Any) {
        addStepTextField.text = ""
        cellInteractor?.showDoneButton()
    }
    
    
    @IBAction func handlePlus(_ sender: Any) {
        addStepTextField.becomeFirstResponder()
    }
    
    @IBAction func handleEndEditing(_ sender: Any) {
        if addStepTextField.text != "" {
            cellInteractor?.addStep(name: addStepTextField.text!)
        }
        addStepTextField.text = "Add Step"
        cellInteractor?.hideDoneButton()
    }
}
