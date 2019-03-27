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
//MARK:-        [---------- STORYBOARD SETTINGS [START] ----------]
//
extension Storyboard {
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

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
}

enum VCIdentifier {
    static let mainSignIn = "ASSignInVC"
}
//MARK:
//MARK:        [---------- STORYBOARD SETTINGS [END] ----------]
//MARK:-
enum HttpMethods {
    static let get = "GET"
    static let post = "POST"
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
enum FontSigns: String {
    case kFontAladin = "Aladin-Regular"
    case kFontBerkshireSwash = "BerkshireSwash-Regular"
    case kFontEagleLake = "EagleLake-Regular"
    case kFontGreatVibes = "GreatVibes-Regular"
    case kFontPetitFormalScript = "PetitFormalScript-Regular"
    case kFontSriracha = "Sriracha-Regular"
    
    var name: String {
        return self.rawValue
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
