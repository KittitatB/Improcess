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
    var defectTypeArray: [String] = []
    var type: String?
    var commentText: String?
    var injected: String?
    var removed: String?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var injectedPhrase: UITextField!
    @IBOutlet weak var removedPhrase: UITextField!
    
    let namePicker = UIPickerView()
    let phrasePicker = UIPickerView()
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        comment.delegate = self
        phrasePicker.delegate = self
        phrasePicker.dataSource = self
        namePicker.delegate = self
        namePicker.dataSource = self
        injectedPhrase.inputView = phrasePicker
        removedPhrase.inputView = phrasePicker
        name.inputView = namePicker
        injectedPhrase.allowTouchesOfViewsOutsideBounds = true
        removedPhrase.allowTouchesOfViewsOutsideBounds = true
        name.text = type
        injectedPhrase.text = injected
        removedPhrase.text = removed
        comment.text = commentText
        print(defectTypeArray)
        
    }
    
    @objc func endEditing() {
        view.endEditing(true)
        commentText = comment.text ?? ""
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == namePicker){
            return defectTypeArray.count
        }else{
            return phrasesArray.count
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == namePicker){
            return defectTypeArray[row]
        }else{
            return phrasesArray[row]
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == namePicker){
            self.type = defectTypeArray[row]
            self.name.text = type
            self.name.endEditing(true)
            self.name.resignFirstResponder()
            self.view.endEditing(true)
        }else{
            if(injectedPhrase.isEditing){
                injected = phrasesArray[row]
                injectedPhrase.text = injected
            }else{
                removed = phrasesArray[row]
                removedPhrase.text = removed
            }
            self.injectedPhrase.endEditing(true)
            self.injectedPhrase.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
}

extension DefectModalController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
