//
//  LoginPageInteractor.swift
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

protocol LoginPageBusinessLogic
{
    func login(request: LoginPage.Auth.Request)
}

protocol LoginPageDataStore
{
    //var name: String { get set }
}

class LoginPageInteractor: LoginPageBusinessLogic, LoginPageDataStore
{
    
    var presenter: LoginPagePresentationLogic?
    var worker: LoginPageWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func login(request: LoginPage.Auth.Request)
    {
        if request.username == "" || request.password == "" {
            let response = LoginPage.Auth.Response(isError: true, errorMessage: "Fields may not be empty!")
            self.presenter?.presentAuthStatus(response: response)
        }
        
        worker = LoginPageWorker()
        worker?.authentication(username: request.username, password: request.password, completionHandler: { (isError, errorMessage) in
            let response = LoginPage.Auth.Response(isError: isError, errorMessage: errorMessage)
            self.presenter?.presentAuthStatus(response: response)
        })
    }
}
