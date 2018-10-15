//
//  SignupPagePresenter.swift
//  Improcess
//
//  Created by MuMhu on 15/10/2561 BE.
//  Copyright (c) 2561 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SignupPagePresentationLogic
{
    func presentSignupResult(response: SignupPage.SignupData.Response)
}

class SignupPagePresenter: SignupPagePresentationLogic
{
    weak var viewController: SignupPageDisplayLogic?
    
    func presentSignupResult(response: SignupPage.SignupData.Response)
    {
        let viewModel = SignupPage.SignupData.ViewModel(isError: response.isError, errorMessage: response.errorMessage)
        viewController?.displaySignupResult(viewModel: viewModel)
    }
}
