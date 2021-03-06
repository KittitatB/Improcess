//
//  LoginPageModels.swift
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

enum LoginPage
{
    // MARK: Use cases
    
    enum Auth
    {
        struct Request
        {
            var username: String?
            var password: String
        }
        struct Response
        {
            var isError: Bool?
            var errorMessage: String?
        }
        struct ViewModel
        {
            var isError: Bool?
            var errorMessage: String?
        }
    }
}
