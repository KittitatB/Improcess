//
//  ProjectPageModels.swift
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

enum ProjectPage
{
    enum Project
    {
        struct Request
        {
        }
        struct Response
        {
            var project: ProjectDetail
        }
        struct ViewModel
        {
            var project: ProjectDetail
        }
    }
    
    enum Task
    {
        struct Request
        {
        }
        struct Response
        {
            var task: [ProjectTask]
        }
        struct ViewModel
        {
            var task: [ProjectTask]
        }
    }
    
    enum phraseList
    {
        struct Request
        {
        }
        struct Response
        {
            var list: [phraseList]
        }
        struct ViewModel
        {
            var list: [phraseList]
        }
    }
    
    enum defectList
    {
        struct Request
        {
        }
        struct Response
        {
            var list: [defectList]
        }
        struct ViewModel
        {
            var list: [defectList]
        }
    }
}

struct ProjectTask {
    var name: String
    var status: String
    var timestamp: Int

    init(myName: String, myStatus: String, myTimestamp: Int) {
        name = myName
        status = myStatus
        timestamp = myTimestamp
    }
}

struct DefectTypeList {
    var name: String?
    var detail: String?
}

struct PhraseTypeList {
    var name: String?
    var detail: String?
}

