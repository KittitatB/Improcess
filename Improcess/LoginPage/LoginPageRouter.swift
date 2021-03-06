//
//  LoginPageRouter.swift
//  Improcess
//
//  Created by MuMhu on 10/10/2561 BE.
//  Copyright (c) 2561 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol LoginPageRoutingLogic
{
    func routeToLandingPage(segue: UIStoryboardSegue?)
}

protocol LoginPageDataPassing
{
    var dataStore: LoginPageDataStore? { get }
}

class LoginPageRouter: NSObject, LoginPageRoutingLogic, LoginPageDataPassing
{
    weak var viewController: LoginPageViewController?
    var dataStore: LoginPageDataStore?
    
    // MARK: Routing
    
    func routeToLandingPage(segue: UIStoryboardSegue?)
    {
      if let segue = segue {
        let destinationVC = segue.destination as! LoginPageViewController
      } else {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "LandingPageViewController") as! LandingPageViewController
        _ = destinationVC.router!.dataStore!
      }
    }
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: LoginPageViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
}
