//
//  ProjectPagePresenter.swift
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

protocol ProjectPagePresentationLogic
{
    func presentProject(response: ProjectPage.Project.Response)
    func presentTask(response: ProjectPage.Task.Response)
    func presentPhraseList(list: [PhraseTypeList])
    func presentDefectList(list: [DefectTypeList])
    func presentProducivility(response: ProducivilityPage.Producivility.Response)
}

class ProjectPagePresenter: ProjectPagePresentationLogic
{
    weak var viewController: ProjectPageDisplayLogic?
    
    // MARK: Do something
    
    func presentProject(response: ProjectPage.Project.Response)
    {
        let viewModel = ProjectPage.Project.ViewModel(project: response.project)
        viewController?.displayProject(viewModel: viewModel)
    }
    
    func presentTask(response: ProjectPage.Task.Response)
    {
        let viewModel = ProjectPage.Task.ViewModel(task: response.task)
        viewController?.displayTask(viewModel: viewModel)
    }
    
    func presentPhraseList(list: [PhraseTypeList]){
        viewController?.passingPhraseList(list: list)
    }
    
    func presentDefectList(list: [DefectTypeList]){
        viewController?.passingDefectList(list: list)
    }
    
    func presentProducivility(response: ProducivilityPage.Producivility.Response)
    {
        let viewModel = ProducivilityPage.Producivility.ViewModel(tasksProducivility: response.tasksProducivility)
        viewController?.displayProducivility(viewModel: viewModel)
        
    }
    
}
