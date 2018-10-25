//
//  StepCell.swift
//  Improcess
//
//  Created by MuMhu on 24/10/2561 BE.
//  Copyright © 2561 Kittitat Boonkarn. All rights reserved.
//

import UIKit

class StepCell: UITableViewCell {
    
    @IBOutlet weak var stepName: UITextField!
    @IBOutlet weak var stepDescription: UITextField!
    
    weak var cellInteractor: CellLogic?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func handleCancel(_ sender: Any) {
        cellInteractor?.deleteStep(index: getIndexPath()!.row)
    }
    
    
    @IBAction func handleDetailEditing(_ sender: Any) {
        if stepDescription.text != "" {
            cellInteractor?.updateStepDetail(index: getIndexPath()!.row, newDescription: stepDescription!.text ?? "")
        }
    }
}
