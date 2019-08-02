//
//  EnumUtils.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

//
//MARK:-        [---------- API Extends ----------]
//
extension API {
    
    /// String value of url
    var val: String {
        return self.rawValue
    }
    
    /// URL with base url
    ///
    /// - Parameter mainURL: base url string
    /// - Returns: URL created using base url passed.
    func url(with mainURL: String = API.baseURL) -> URL? {
        let url = "\(mainURL)\(self.val)"
        return URL.init(string: url)
    }
    
    /// String value with base url
    ///
    /// - Parameter mainURL: base url
    /// - Returns: base url + url into string form.
    func strUrl(with mainURL: String = API.baseURL) -> String {
        return "\(mainURL)\(self.val)"
    }
}

//MARK:- Device Constraints
extension Screen {
    static let main = UIScreen.main
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let centerW = Screen.width/2
    static let centerH = Screen.height/2
    static let deviceIdiom = main.traitCollection.userInterfaceIdiom
    static let isIPAD: Bool = deviceIdiom == UIUserInterfaceIdiom.pad ? true : false
}

//
//MARK:-        [---------- STORYBOARD SETTINGS [START] ----------]
//
extension Storyboard {
    
    /// UIStoryboard instance
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    /// This function takes class name as argument and returns it’s instance. Using this, one can instantiate a ViewController as Storyboard.main.viewController(viewControllerClass: ViewController.self)
    ///
    /// - Parameter viewControllerClass: ViewController
    /// - Returns: Storyboard instance for viewControllerClass
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T? {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as? T
    }
}
//MARK:- UIViewController
extension UIViewController {
    
    /// String identifier of storyboard
    class var storyboardID: String {
        return "\(self)"
    }
}

/// ViewController Identifier
enum VCIdentifier {
    static let mainSignIn = "TDLoginVC"
    static let welcomeVC = "TDWelcomeVC"
}
//MARK:
//MARK:        [---------- STORYBOARD SETTINGS [END] ----------]
//MARK:-
extension HttpMethods {
    static let get = "GET"
    static let post = "POST"
}

// MARK: - ContentType
extension ContentType {
    static let applicationXWWFormUrlencoded = "application/x-www-form-urlencoded"
    static let applicationJson = "application/json"
    static let multipartFormData = "multipart/form-data"
}

///
// MARK:- Notification Name
///

/// This Enum is used to get the notification name.
enum Notifications: String {
    
    case splashRemove
    case logout
    
    var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue )
    }
}

//MARK:- [  FONTS   ]
extension Font {
    var val: UIFont {
        return UIFont.systemFont(ofSize: self.info.size, weight: self.info.weight)
    }
    
    func val(of weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: self.info.size, weight: weight)
    }
}


//
//MARK:- Media Extensions
//
enum MediaExtension: String {
    case png = "png"
    case jpg = "jpg"
    case jpeg = "jpeg"
    case mp4 = "mp4"
    case doc = "doc"
    case docX = "docx"
    case pdf = "pdf"
    case xls = "xls"
    
    var dotName: String {
        return ".\(self.rawValue)"
    }
    
    var name: String {
        return self.rawValue
    }
}
