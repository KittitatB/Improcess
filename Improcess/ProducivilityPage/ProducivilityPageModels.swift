//
//  ProducivilityPageModels.swift
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

enum ProducivilityPage
{
    // MARK: Use cases
    
    enum Producivility
    {
        struct Request
        {
        }
        struct Response
        {
            var tasksProducivility: [TaskProducivility]
        }
        struct ViewModel
        {
            var tasksProducivility: [TaskProducivility]
        }
    }
}

struct TaskProducivility{
    var taskName: String?
    var taskProducivility: Float?
    
    init(name: String, producivility: Float) {
        taskName = name
        taskProducivility = producivility
    }
}
