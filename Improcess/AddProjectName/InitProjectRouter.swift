//
//  InitProjectRouter.swift
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

@objc protocol InitProjectRoutingLogic
{
  func routeToNextPage(segue: UIStoryboardSegue?)
}

protocol InitProjectDataPassing
{
  var dataStore: InitProjectDataStore? { get }
}

class InitProjectRouter: NSObject, InitProjectRoutingLogic, InitProjectDataPassing
{
  weak var viewController: InitProjectViewController?
  var dataStore: InitProjectDataStore?
  
  // MARK: Routing

  func routeToNextPage(segue: UIStoryboardSegue?)
  {
    if let segue = segue {
      let destinationVC = segue.destination as! InitSummaryViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToNextPage(source: dataStore!, destination: &destinationDS)
    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let destinationVC = storyboard.instantiateViewController(withIdentifier: "InitSummaryViewController") as! InitSummaryViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToNextPage(source: dataStore!, destination: &destinationDS)
      navigateToNextPage(source: viewController!, destination: destinationVC)
    }
  }

//   MARK: Navigation

  func navigateToNextPage(source: InitProjectViewController, destination: InitSummaryViewController)
  {
    source.show(destination, sender: nil)
  }

//   MARK: Passing data

  func passDataToNextPage(source: InitProjectDataStore, destination: inout InitSummaryDataStore)
  {
    destination.proJectName = source.proJectName
  }
}
