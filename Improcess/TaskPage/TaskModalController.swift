//
//  TaskModalController.swift
//  Improcess
//
//  Created by MuMhu on 19/12/2561 BE.
//  Copyright © 2561 Kittitat Boonkarn. All rights reserved.
//

import UIKit

class TaskModalController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!

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
}

extension TaskModalController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
