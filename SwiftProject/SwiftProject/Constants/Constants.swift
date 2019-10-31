//
//  Constants.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

/// AppDelegate shared instance.
// swiftlint:disable:next force_cast
let kAppDelegate = (UIApplication.shared.delegate as! AppDelegate)

/// Main Queue thread.
let kMainQueue = DispatchQueue.main

//MARK:- API
/// Extented further in EnumUtil.swift class
///  This enum represent All the APi urls used in the app
enum API: String {
    
    /// Main Server Url
    static let serverURL = "https://www.example.com"
    
    /// Base URL for the Api's
    static let baseURL = "\(API.serverURL)/v1/"
    
    /// Login end-point
    case login
    
}

/// This enum will represent all the credentials keys for various logins used in the apps.
enum Credentials {
    
}

//MARK:- Storyboard
/// USAGE :
/// let storyboard = Storyboard.main.instance
/// let objVC = Storyboard.main.instance.instantiateViewController(withIdentifier: ViewController.storyboardID)
/// let objVC1 = Storyboard.main.viewController(viewControllerClass: ViewController.self)
/// Extented further in EnumUtil.swift class
enum Storyboard: String {
    /// SignIn Storyboard
    case signIn = "SignIn"
    /// Main Storyboard
    case main = "Main"
    /// Chat Storyboard
    case chat = "Chat"
    /// Group Storyboard
    case group = "Group"
}

//MARK:- Background Queues
///QUEUES
enum BackgroundQueue {
    
    /// Queue for login
    static let loginQueue = DispatchQueue(label: "com.app.queue_signin", attributes: .concurrent)
    
    /// Queue for aws keys
    static let commonQueue = DispatchQueue(label: "com.app.queue_common", qos: .background)
}

//MARK:- Device Constraints
///Extented further in EnumUtil.swift class
enum Screen {}

//MARK:- Default Center
///Abbr...
enum DefaultCenter {
    
    /// NotificationCenter
    static let notification = NotificationCenter.default
    
    /// FileManager
    static let fileManager = FileManager.default
    
    /// UserDefaults
    static let userDefaults = UserDefaults.standard
}

/// Common Keys used in Application
enum Keys {
    
    /// Logged In User info
    static let userData = "userData"
}

//MARK:- HTTP METHODS & CONTENT TYPE
///Extented further in EnumUtil.swift class
enum HttpMethods {}

/// Extented further in EnumUtil.swift class
enum ContentType {}

