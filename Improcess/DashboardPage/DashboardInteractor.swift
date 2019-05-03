//
//  DashboardInteractor.swift
//  Improcess
//
//  Created by MuMhu on 9/4/2562 BE.
//  Copyright (c) 2562 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DashboardBusinessLogic
{
    var project: ProjectDetail? {get}
    var phraseList: [PhraseTypeList] {get set}
    var defectList: [DefectTypeList] {get set}
    
    func doSomething(request: Dashboard.Something.Request)
    func deleteProject(name: String)
}

protocol DashboardDataStore
{
    var project: ProjectDetail? {get set}
    var phraseList: [PhraseTypeList] {get set}
    var defectList: [DefectTypeList] {get set}
}

class DashboardInteractor: DashboardBusinessLogic, DashboardDataStore
{
    var phraseList: [PhraseTypeList] = []
    var defectList: [DefectTypeList] = []
    var project: ProjectDetail?
    
    var presenter: DashboardPresentationLogic?
    var worker: DashboardWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: Dashboard.Something.Request)
    {
        worker = DashboardWorker()
        
        let response = Dashboard.Something.Response()
        presenter?.presentSomething(response: response)
    }
    
    func deleteProject(name: String){
        worker = DashboardWorker()
        worker?.deleteProject(name: name)
       
    }
}
