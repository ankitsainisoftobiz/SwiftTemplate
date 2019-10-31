//
//  AppDelegate.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import UIKit
import Reachability
import IQKeyboardManagerSwift

/// This is the first class after main which will be used to initialize project setups.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// Default UIWindow instance.
    var window: UIWindow?

    /// Reachability instance to check network Reachability.
    let reachability = try? Reachability()
    
    
    /// This will be called whenever application is newly launched.
    ///
    /// - Parameters:
    ///   - application: UIApplication instance.
    ///   - launchOptions: [UIApplication.LaunchOptionsKey: Any]
    /// - Returns: Returns true or false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //---------------------------------------------------------
        //Enable Keyboard Manager
        //
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //---------------------------------------------------------
        
        ///
        ///Internet Monitoring
        ///
        internetMonitoring()
        /// --------------------------
        
        return true
    }
    
    /// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    /// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    ///
    /// - Parameter application: UIApplication instance
    func applicationWillResignActive(_ application: UIApplication) {}

    /// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    /// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    ///
    /// - Parameter application: UIApplication instance
    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    /// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    ///
    /// - Parameter application: UIApplication instance
    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    /// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    ///
    /// - Parameter application: UIApplication instance
    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    /// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    ///
    /// - Parameter application: UIApplication insance
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}

