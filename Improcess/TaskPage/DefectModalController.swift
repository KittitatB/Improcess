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
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var injectedPhrase: DropDown!
    @IBOutlet weak var removedPhrase: DropDown!
    @IBOutlet weak var comment: UITextField!
   
    override func viewDidLoad() {
        injectedPhrase.optionArray = phrasesArray
        removedPhrase.optionArray = phrasesArray
        injectedPhrase.allowTouchesOfViewsOutsideBounds = true
        removedPhrase.allowTouchesOfViewsOutsideBounds = true
    }
}
