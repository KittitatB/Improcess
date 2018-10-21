//
//  InitSummaryInteractor.swift
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

protocol InitSummaryBusinessLogic
{
  func doSomething(request: InitSummary.Something.Request)
}

protocol InitSummaryDataStore
{
    var proJectName: String? { get set }
    var proJectDetails: String { get set }
}

class InitSummaryInteractor: InitSummaryBusinessLogic, InitSummaryDataStore
{
    var proJectName: String?
    
    var proJectDetails: String = ""
    
  var presenter: InitSummaryPresentationLogic?
  var worker: InitSummaryWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: InitSummary.Something.Request)
  {
    worker = InitSummaryWorker()
    worker?.doSomeWork()
    print(proJectName!)
    
    let response = InitSummary.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
