//
//  MetricCell.swift
//  Improcess
//
//  Created by MuMhu on 19/12/2561 BE.
//  Copyright © 2561 Kittitat Boonkarn. All rights reserved.
//

import UIKit
import Firebase

protocol UpdateMetric: class {
    func reloadMetric()
}


class MetricCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var field: UITextField!
    weak var reloader: UpdateMetric?
    var project: ProjectDetail?
    var task: String?
    var product: Float?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func setMetric(_ sender: Any) {
        guard let field = field.text else {
            return
        }
        let uid = Auth.auth().currentUser?.uid
        let update = [
            name.text! : field
            ] as [String : Any]
        Database.database().reference().child(uid!).child("projects").child(project!.name!).child("tasks").child(task!).child("estimate").updateChildValues(update)
        
        if field != "" && name.text! == "Estimated Line Of Code(Line)" && product != 1{
            let update2 = [
                "Estimated Time(Minutes)" : String(Int(Float(field)! / product!))
                ] as [String : Any]
            Database.database().reference().child(uid!).child("projects").child(project!.name!).child("tasks").child(task!).child("estimate").updateChildValues(update2)
        }
        reloader?.reloadMetric()
    }
    

}

class SummaryCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var field: UITextField!
    weak var reloader: UpdateMetric?
    
    var project: ProjectDetail?
    var task: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func setActual(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        let update = [
            name.text! : field.text!
            ] as [String : Any]
        Database.database().reference().child(uid!).child("projects").child(project!.name!).child("tasks").child(task!).child("actual").updateChildValues(update)
        reloader?.reloadMetric()
    }
    
}
