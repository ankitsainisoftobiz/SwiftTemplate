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
/// This enum represent All the APi urls used in the app
enum API: String {
    static let baseURL = "http://www.example.org"
    
    case login = "/workflow/running/"
    case polling = ""
}

//MARK:- Storyboard
/// USAGE :
/// let storyboard = Storyboard.main.instance
/// let objVC = Storyboard.main.instance.instantiateViewController(withIdentifier: ViewController.storyboardID)
/// let objVC1 = Storyboard.main.viewController(viewControllerClass: ViewController.self)
enum Storyboard: String {
    case main = "Main"
}

//MARK:- Device Constraints
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

//MARK:- Background Queues
///QUEUES
enum BackgroundQueue {
    static let loginQueue = DispatchQueue(label: "com.app.queue_SignIn", attributes: .concurrent)
    static let polingQueue = DispatchQueue(label: "com.app.queue_poling", qos: .background)
}

//MARK:- [  FONTS   ]
enum Font: CGFloat {
    case navTitle = 14.0
    case formButtons = 16.0
    
    var weight: UIFont.Weight {
        switch self {
        case .navTitle:
            return .regular
        case .formButtons:
            return .semibold
        }
    }
}
