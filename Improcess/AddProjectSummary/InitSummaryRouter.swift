//
//  InitSummaryRouter.swift
//  Improcess
//
//  Created by MuMhu on 21/10/2561 BE.
//  Copyright (c) 2561 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol InitSummaryRoutingLogic
{
    func routeToAddProjectDefects(segue: UIStoryboardSegue?)
}

protocol InitSummaryDataPassing
{
    var dataStore: InitSummaryDataStore? { get }
}

class InitSummaryRouter: NSObject, InitSummaryRoutingLogic, InitSummaryDataPassing
{
    weak var viewController: InitSummaryViewController?
    var dataStore: InitSummaryDataStore?
    
    // MARK: Routing
    
    func routeToAddProjectDefects(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! AddProjectDefectsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToAddProjectDefects(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "AddProjectDefects") as! AddProjectDefectsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToAddProjectDefects(source: dataStore!, destination: &destinationDS)
            navigateToAddProjectDefects(source: viewController!, destination: destinationVC)
        }
    }
    
    //   MARK: Navigation
    
    func navigateToAddProjectDefects(source: InitSummaryViewController, destination: AddProjectDefectsViewController)
    {
        source.show(destination, sender: nil)
    }
    
    //   MARK: Passing data
    
    func passDataToAddProjectDefects(source: InitSummaryDataStore, destination: inout AddProjectDefectsDataStore)
    {
        destination.steps = source.steps
        destination.proJectName = source.proJectName
        destination.proJectDetails = source.proJectDetails
    }
}
