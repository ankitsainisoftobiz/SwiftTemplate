//
//  UserLogin.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

class UserLogin {
    static func authenticateUser(with parameters: Dictionary<String, Any>, controller: UIViewController? = nil, completion: @escaping (_ isSuccess: Bool) -> Void) {
        if kAppDelegate.checkInternet() == false {
            completion(false)
            return
        }
        
        BackgroundQueue.loginQueue.async {
            let response = ASDataModal.shared.requestGetDataApi(with: API.login.strUrl(), parameters: parameters)
            print(response.validatedData)
            completion(response.isSuccess)
        }
    }
    
    static func pollUserUpdates(with parameters: Dictionary<String, Any>, controller: UIViewController? = nil, completion: @escaping (_ isSuccess: Bool) -> Void) {
        
        let response = ASDataModal.shared.requestGetDataApi(with: API.polling.strUrl(), parameters: parameters)
        print(response.validatedData)
        completion(response.isSuccess)
    }
}
