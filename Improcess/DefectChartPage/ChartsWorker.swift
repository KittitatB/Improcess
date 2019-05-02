//
//  ChartsWorker.swift
//  Improcess
//
//  Created by MuMhu on 14/3/2562 BE.
//  Copyright (c) 2562 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Firebase

class ChartsWorker
{
    let myGroup = DispatchGroup()
    let taskGroup = DispatchGroup()
    
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
                    let producivility =  TaskProducivility(name: task.name,time: Float(time ?? "1")!,line: Float(loc ?? "1")!, producivility: Float(loc ?? "1")! / (Float(time ?? "1")! / Float(60.0)))
                    escape.append(producivility)
                    self.myGroup.leave()
                }
            }
        }
        myGroup.notify(queue: DispatchQueue.main, execute: {
            completionHandler(escape)
        })
        
    }
    
    func getChartData(project: ProjectDetail, tasks: [ProjectTask],completionHandler: @escaping([PredictionChartsData]) -> Void)
    {
        let uid = Auth.auth().currentUser?.uid
        var escape = [PredictionChartsData]()
        
        for task in tasks{
            myGroup.enter()
            let ref = Database.database().reference().child(uid!).child("projects").child(project.name!).child("tasks").child(task.name)
            ref.child("actual").observeSingleEvent(of: .value) { (snapshot) in
                if let tasksDic = snapshot.value as? [String : AnyObject]{
                    let actual = (tasksDic["Actual Time"] as? String!)!
                    ref.child("estimate").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let tasksDic = snapshot.value as? [String : AnyObject]{
                            let estimate = (tasksDic["Estimated Time"] as? String!)!
                            let temp = PredictionChartsData(name: task.name, prediction: Float(abs((actual! as NSString).floatValue - (estimate! as NSString).floatValue))/(estimate! as NSString).floatValue*100.00)
                            escape.append(temp)
                            self.myGroup.leave()
                        }
                    })
                }
            }
        }
        myGroup.notify(queue: DispatchQueue.main, execute: {
            completionHandler(escape)
        })
        
    }
    
    func getDefectData(project: ProjectDetail, tasks: [ProjectTask],completionHandler: @escaping([DefectChartData]) -> Void)
    {
        let uid = Auth.auth().currentUser?.uid
        var escape = [DefectChartData]()
        var numberOfDefect = 0
        
        for task in tasks{
            taskGroup.enter()
            let ref = Database.database().reference().child(uid!).child("projects").child(project.name!).child("tasks").child(task.name)
            ref.child("defect").observeSingleEvent(of: .value) { (snapshot) in
                if let tasksDic = snapshot.value as? [String : AnyObject]{
                    for task in tasksDic{
                        print(task)
                        numberOfDefect += 1
                    }
                    let temp = DefectChartData(name: task.name, numberOfDefects: numberOfDefect)
                    escape.append(temp)
                    self.taskGroup.leave()
                }
            }
        }
        taskGroup.notify(queue: DispatchQueue.main, execute: {
            completionHandler(escape)
        })
        
    }
}
