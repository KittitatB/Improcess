//
//  LandingPageInteractor.swift
//  Improcess
//
//  Created by MuMhu on 16/10/2561 BE.
//  Copyright (c) 2561 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LandingPageBusinessLogic
{
    func getDate()
    func loadProject(request: LandingPage.Project.Request)
}

protocol LandingPageDataStore
{
    //var name: String { get set }
}

class LandingPageInteractor: LandingPageBusinessLogic, LandingPageDataStore
{
    var presenter: LandingPagePresentationLogic?
    var worker: LandingPageWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func getDate()
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        
        let response = LandingPage.Date.Response(date: formatter.string(from: date))
        presenter?.presentDate(response: response)
    }
    
    func loadProject(request: LandingPage.Project.Request) {
        worker = LandingPageWorker()
        worker?.requestProjectFormFirebase(uid: request.uid, completionHandler: { (projects) in
            let response = LandingPage.Project.Response(projectsName: projects)
            self.presenter?.presentProjects(response: response)
        })
    }
}
