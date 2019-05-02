//
//  ProjectPageWorker.swift
//  Improcess
//
//  Created by MuMhu on 30/10/2561 BE.
//  Copyright (c) 2561 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProjectPageWorker
{
    let myGroup = DispatchGroup()
    
    
    func getAllTasksProducivility(project: ProjectDetail, tasks: [ProjectTask],completionHandler: @escaping([TaskProducivility]) -> Void)
    {
        let uid = Auth.auth().currentUser?.uid
        var escape = [TaskProducivility]()
        
        
        for task in tasks{
            myGroup.enter()
            Database.database().reference().child(uid!).child("projects").child(project.name!).child("tasks").child(task.name).child("actual").observeSingleEvent(of: .value) { (snapshot) in
                if let tasksDic = snapshot.value as? [String : AnyObject]{
                    let loc = (tasksDic["Actual Line Of Code"] as? String!)!
                    let time = (tasksDic["Actual Time"] as? String!)!
                    let producivility =  TaskProducivility(name: task.name,time: Float(time ?? "1")!,line: Float(loc ?? "1")!, producivility: Float(loc ?? "1")! / (Float(time ?? "1")! / Float(60.0)), timestamp: task.timestamp)
                    escape.append(producivility)
                    self.myGroup.leave()
                }
            }
        }
        myGroup.notify(queue: DispatchQueue.main, execute: {
            completionHandler(escape)
        })
        
    }
    
    func updateTaskChild(project: ProjectDetail, task: String, numberOfTask: Int)
    {
        let uid = Auth.auth().currentUser?.uid
       let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        Database.database().reference().child(uid!).child("projects").child(project.name!).updateChildValues(["taskQuantity": numberOfTask] as [String : Int])
        Database.database().reference().child(uid!).child("projects").child(project.name!).child("tasks").child(task).updateChildValues(["status": "Open"] as [String : String])
        
        Database.database().reference().child(uid!).child("projects").child(project.name!).child("tasks").child(task).updateChildValues(["timestamp": timestamp] as [String : Any])
        Database.database().reference().child(uid!).child("projects").child(project.name!).child("metric").observeSingleEvent(of: .value) { (snapshot) in
            var metrics = [String]()
            guard let metricsList = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for metric in metricsList{
                metrics.append(metric.value as! String)
            }
        
            for metric in metrics{
                let estimateMetric = [
                    "Estimated \(metric)" : "",
                    ] as [String : Any]
                let actualMetric = [
                    "Actual \(metric)" : "",
                    ] as [String : Any]
                Database.database().reference().child(uid!).child("projects").child(project.name!).child("tasks").child(task).child("estimate").updateChildValues(estimateMetric)
                Database.database().reference().child(uid!).child("projects").child(project.name!).child("tasks").child(task).child("actual").updateChildValues(actualMetric)
            }
        }
    }
    
    func requestTaskFormFirebase(project: ProjectDetail,completionHandler: @escaping([ProjectTask]) -> Void)
    {
        let uid = Auth.auth().currentUser?.uid
        var tasks = [ProjectTask]()
        Database.database().reference().child(uid!).child("projects").child(project.name!).child("tasks").observeSingleEvent(of: .value) { (snapshot) in
            if let tasksDic = snapshot.value as? [String : AnyObject]{
                for task in tasksDic{
                    let dict = task.value as! [String: AnyObject]
                    let taskName = task.key
                    let taskStatus = dict["status"] as! String
                    let timeStamp = dict["timestamp"] as! Int
                    let newTask = ProjectTask(myName: taskName, myStatus: taskStatus, myTimestamp: timeStamp)
                    tasks.append(newTask)
                }
                completionHandler(tasks)
            }
        }
    }
    
    func requestPhraseListFormFirebase(project: ProjectDetail,completionHandler: @escaping([PhraseTypeList]) -> Void)
    {
        let uid = Auth.auth().currentUser?.uid
        var phrases = [PhraseTypeList]()
        Database.database().reference().child(uid!).child("projects").child(project.name!).child("step").observeSingleEvent(of: .value) { (snapshot) in
            guard let phraseList = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for phrase in phraseList{
                if let dict = phrase.value as? [String : AnyObject]{
                    let name = dict["stepName"] as! String
                    let detail = dict["stepDesccription"] as! String
                    let newList = PhraseTypeList(name: name, detail: detail)
                    phrases.append(newList)
                }
            }
            completionHandler(phrases)
        }
    }
    
    func requestDefectListFormFirebase(project: ProjectDetail,completionHandler: @escaping([DefectTypeList]) -> Void)
    {
        let uid = Auth.auth().currentUser?.uid
        var defects = [DefectTypeList]()
        Database.database().reference().child(uid!).child("projects").child(project.name!).child("defect").observeSingleEvent(of: .value) { (snapshot) in
            guard let defectList = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for defect in defectList{
                if let dict = defect.value as? [String : AnyObject]{
                    let name = dict["defectName"] as! String
                    let detail = dict["defectDesccription"] as! String
                    let newList = DefectTypeList(name: name, detail: detail)
                    defects.append(newList)
                }
                completionHandler(defects)
            }
        }
    }
}
