//
//  DefectModalController.swift
//  Improcess
//
//  Created by MuMhu on 29/1/2562 BE.
//  Copyright © 2562 Kittitat Boonkarn. All rights reserved.
//

import UIKit

class DefectModalController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var phrasesArray: [String] = []
    var type: String?
    var commentText: String?
    var injected: String?
    var removed: String?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var injectedPhrase: UITextField!
    @IBOutlet weak var removedPhrase: UITextField!
    
    let phrasePicker = UIPickerView()
    let defectPicker = UIPickerView()
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        comment.delegate = self
        phrasePicker.delegate = self
        phrasePicker.dataSource = self
        injectedPhrase.inputView = phrasePicker
        removedPhrase.inputView = phrasePicker
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return phrasesArray.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return phrasesArray[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(injectedPhrase.isEditing){
            injectedPhrase.text = phrasesArray[row]
        }else{
            removedPhrase.text = phrasesArray[row]
        }
        self.injectedPhrase.endEditing(true)
        self.injectedPhrase.resignFirstResponder()
        self.view.endEditing(true)
    }
    
}

extension DefectModalController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
