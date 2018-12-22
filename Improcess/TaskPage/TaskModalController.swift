//
//  TaskModalController.swift
//  Improcess
//
//  Created by MuMhu on 19/12/2561 BE.
//  Copyright © 2561 Kittitat Boonkarn. All rights reserved.
//

import UIKit
import iOSDropDown

class TaskModalController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var sec: UITextField!
    @IBOutlet weak var min: UITextField!
    @IBOutlet weak var hour: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func endEditing() {
        view.endEditing(true)
    }
    
    @IBAction func timerStart(_ sender: Any) {
    }
    
    @IBAction func PauseTimer(_ sender: Any) {
    }
    
    
    @IBAction func resetTimer(_ sender: Any) {
    }
}

extension TaskModalController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
