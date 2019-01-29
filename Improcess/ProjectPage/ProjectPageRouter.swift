//
//  ProjectPageRouter.swift
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

@objc protocol ProjectPageRoutingLogic
{
    func routeToTaskPage(segue: UIStoryboardSegue?)
}

protocol ProjectPageDataPassing
{
    var dataStore: ProjectPageDataStore? { get }
}

class ProjectPageRouter: NSObject, ProjectPageRoutingLogic, ProjectPageDataPassing
{
    weak var viewController: ProjectPageViewController?
    var dataStore: ProjectPageDataStore?
    
    // MARK: Routing
    
    func routeToTaskPage(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! TaskPageViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToTaskPage(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "TaskPageViewController") as! TaskPageViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToTaskPage(source: dataStore!, destination: &destinationDS)
            navigateToTaskPage(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToTaskPage(source: ProjectPageViewController, destination: TaskPageViewController)
    {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToTaskPage(source: ProjectPageDataStore, destination: inout TaskPageDataStore)
    {
        destination.defectList = source.defectList
        destination.phraseList = source.phraseList
        destination.selectedTask = source.selectedTask
        destination.projectDetail = source.project
    }
}
