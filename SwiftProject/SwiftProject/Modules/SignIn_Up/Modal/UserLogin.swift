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
            ASDataModal.shared.requestGetDataApi(with: API.login.strUrl(), parameters: parameters) { (user: Person?, _) in
                print(user.debugDescription)
                completion(true)
            }
        }
    }
    
    static func pollUserUpdates(with parameters: Dictionary<String, Any>, controller: UIViewController? = nil, completion: @escaping (_ isSuccess: Bool) -> Void) {
        
    }
}
