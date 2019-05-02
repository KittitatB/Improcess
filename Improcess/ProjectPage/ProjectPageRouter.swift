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
    func routeToProducivilityPage(segue: UIStoryboardSegue?)
    func routeToChartsPage(segue: UIStoryboardSegue?)
    func routeToDashboardPage(segue: UIStoryboardSegue?)
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
        destination.product = source.product
    }
    
    func routeToProducivilityPage(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ProducivilityPageViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToProducivilityPage(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ProducivilityPageController") as! ProducivilityPageViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToProducivilityPage(source: dataStore!, destination: &destinationDS)
            navigateToProducivilityPage(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToProducivilityPage(source: ProjectPageViewController, destination: ProducivilityPageViewController)
    {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToProducivilityPage(source: ProjectPageDataStore, destination: inout ProducivilityPageDataStore)
    {
        destination.projectDetail = source.project
        destination.tasks = source.tasks
    }
    
    func routeToChartsPage(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ChartsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToChartsPage(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ChartsPageController") as! ChartsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToChartsPage(source: dataStore!, destination: &destinationDS)
            navigateToChartsPage(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToChartsPage(source: ProjectPageViewController, destination: ChartsViewController)
    {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToChartsPage(source: ProjectPageDataStore, destination: inout ChartsDataStore)
    {
        destination.projectDetail = source.project
        destination.tasks = source.tasks
    }
    
    func routeToDashboardPage(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! DashboardViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToDashboardPage(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "DashboardPageController") as! DashboardViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToDashboardPage(source: dataStore!, destination: &destinationDS)
            navigateToDashboardPage(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToDashboardPage(source: ProjectPageViewController, destination: DashboardViewController)
    {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToDashboardPage(source: ProjectPageDataStore, destination: inout DashboardDataStore)
    {
        destination.project = source.project
        destination.phraseList = source.phraseList
        destination.defectList = source.defectList
    }
}
