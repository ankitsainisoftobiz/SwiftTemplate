//
//  Constants.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable:next force_cast
let kAppDelegate = (UIApplication.shared.delegate as! AppDelegate)
let kMainQueue = DispatchQueue.main

//MARK:- API
///Extented further in EnumUtil.swift class
/// This enum represent All the APi urls used in the app
enum API: String {
    static let baseURL = "http://www.example.org"
    
    case login = "/login"
    case polling = ""
}

//MARK:- Storyboard
/// USAGE :
/// let storyboard = Storyboard.main.instance
/// let objVC = Storyboard.main.instance.instantiateViewController(withIdentifier: ViewController.storyboardID)
/// let objVC1 = Storyboard.main.viewController(viewControllerClass: ViewController.self)
///Extented further in EnumUtil.swift class
enum Storyboard: String {
    case main = "Main"
    case chat = "Chat"
    case group = "Group"
}

//MARK:- Background Queues
///QUEUES
enum BackgroundQueue {
    static let loginQueue = DispatchQueue(label: "com.app.queue_SignIn", attributes: .concurrent)
    static let polingQueue = DispatchQueue(label: "com.app.queue_poling", qos: .background)
    static let awsDetail = DispatchQueue(label: "com.app.queue_awsdetail", qos: .background)
}

//MARK:- [  FONTS   ]
///Extented further in EnumUtil.swift class
enum Font {
    case navTitle
    case navButton
    case textField
    case formButtons
    
    var info: (size: CGFloat, weight: UIFont.Weight) {
        switch self {
        case .navTitle:
            return (14.0, .regular)
        case .navButton:
            return (14.0, .regular)
        case .textField:
            return (14.0, .regular)
        case .formButtons:
            return (16.0, .semibold)
        }
    }
}

//MARK:- Device Constraints
///Extented further in EnumUtil.swift class
enum Screen {}

//MARK:- Default Center
///Abbr...
enum DefaultCenter {
    static let notification = NotificationCenter.default
    static let fileManager = FileManager.default
    static let userDefaults = UserDefaults.standard
}

enum Keys {
    static let userData = "userData"
}

//MARK:- HTTP METHODS
///Extented further in EnumUtil.swift class
enum HttpMethods {}

/// Extented further in EnumUtil.swift class
enum ContentType {}
