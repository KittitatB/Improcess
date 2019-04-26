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
    
    var name: String?
    var time = 0
    var commentText: String?
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var sec: UITextField!
    @IBOutlet weak var min: UITextField!
    @IBOutlet weak var hour: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    var minutes = 60
    var hours = 60*60
    var isTimerRunning = false
    var timer = Timer()
    var resumeTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskName.text = name ?? "Found Nil"
        updateClock()
        commentTextField.text = commentText ?? ""
        commentTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func endEditing() {
        view.endEditing(true)
        commentText = commentTextField.text ?? ""
    }
    
    
    @IBAction func PauseTimer(_ sender: Any) {
        if isTimerRunning == false {
            runTimer()
            isTimerRunning = true
            playButton.setImage(UIImage(named: "pause"), for: .normal)
        }else{
            if self.resumeTapped == false {
                timer.invalidate()
                self.resumeTapped = true
                playButton.setImage(UIImage(named: "play-button"), for: .normal)
            } else {
                runTimer()
                self.resumeTapped = false
                playButton.setImage(UIImage(named: "pause"), for: .normal)
            }
        }
    }
    
    
    @IBAction func resetTimer(_ sender: Any) {
        time = 0
        timer.invalidate()
        self.resumeTapped = true
        playButton.setImage(UIImage(named: "play-button"), for: .normal)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        time += 1
        updateClock()
    }
    
    func updateClock(){
        let timeToSec = (time % hours) % minutes
        let timeToMin = (time % hours)/minutes
        let timeToHour = time / hours
        hour.text = timeToString(time: timeToHour)
        min.text = timeToString(time: timeToMin)
        sec.text = timeToString(time: timeToSec)
        
    }
    
    func timeToString(time: Int) -> (String){
        if time < 10 {
            return "0" + String(time)
        }
        return String(time)
    }
}

extension TaskModalController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
