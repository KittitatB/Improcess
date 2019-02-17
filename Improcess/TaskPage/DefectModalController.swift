//
//  DefectModalController.swift
//  Improcess
//
//  Created by MuMhu on 29/1/2562 BE.
//  Copyright © 2562 Kittitat Boonkarn. All rights reserved.
//

import UIKit
import iOSDropDown

class DefectModalController: UIViewController {
    var phrasesArray: [String] = []
    var type: String?
    var commentText: String?
    var injected: String?
    var removed: String?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var injectedPhrase: DropDown!
    @IBOutlet weak var removedPhrase: DropDown!
    @IBOutlet weak var comment: UITextField!
   
    override func viewDidLoad() {
        comment.delegate = self
        injectedPhrase.optionArray = phrasesArray
        removedPhrase.optionArray = phrasesArray
        injectedPhrase.allowTouchesOfViewsOutsideBounds = true
        removedPhrase.allowTouchesOfViewsOutsideBounds = true
        name.text = type
        injectedPhrase.text = injected
        removedPhrase.text = removed
        comment.text = commentText
    }
    
    @objc func endEditing() {
        view.endEditing(true)
        commentText = comment.text ?? ""
    }
    
}

extension DefectModalController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
