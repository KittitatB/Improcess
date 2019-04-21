//
//  ProducivilityPageWorker.swift
//  Improcess
//
//  Created by MuMhu on 17/2/2562 BE.
//  Copyright (c) 2562 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProducivilityPageWorker
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
                    let producivility =  TaskProducivility(name: task.name, producivility: Float(loc ?? "1")! / (Float(time ?? "1")! / Float(60.0)))
                    escape.append(producivility)
                    self.myGroup.leave()
                }
            }
        }
        myGroup.notify(queue: DispatchQueue.main, execute: {
            completionHandler(escape)
        })

    }
    
}
