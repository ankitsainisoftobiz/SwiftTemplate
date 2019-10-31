//
//  ASUtility.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

/// This class will represent some common functions which will be used in the project.
class ASUtility: NSObject {
    
    /// Shared instance
    static let shared = ASUtility()
    
    /// Print all available fonts in console
    func logAllAvailableFonts() {
        let familyNames = UIFont.familyNames

        for family in familyNames {
            print("Family name " + family)
            let fontNames = UIFont.fontNames(forFamilyName: family)
            
            for font in fontNames {
                print("    Font name: " + font)
            }
        }
    }
    /// This function is used to show an alert popup for confirmation of user.
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - message: Brief message for the alert
    ///   - lblDone: Lable string for the done button
    ///   - lblCancel: lable string for the cancel button
    ///   - controller: controller from where this alert is called
    ///   - completion: return the result.
    func showConfirmAlert(with title: String, message: String, lblDone: String, lblCancel: String, completion: @escaping (_ choice: Bool) -> Void) {
        
        let objAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        objAlert.addAction(UIAlertAction(title: lblDone, style: .default, handler: { (_) in
            completion(true)
            return
        }))
        
        objAlert.addAction(UIAlertAction(title: lblCancel, style: .cancel, handler: { (_) in
            completion(false)
            return
        }))
        
        kMainQueue.async {
            guard let topController = UIApplication.topViewController() else {
                kAppDelegate.window?.rootViewController?.present(objAlert, animated: true, completion: nil)
                return
            }
            if topController.isKind(of: UIAlertController.self) {
                print("Not showing alert as another UIAlertController is present already.")
                return
            }
            topController.present(objAlert, animated: true, completion: nil)
        }
    }
    
    /// This function is used to show a dismiss alert popup for user.
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - message: Brief message for the alert
    ///   - lblDone: Lable string for the done button
    ///   - controller: controller from where this alert is called
    ///   - onPrevAlert: if true then the alert will be shown on previous alert itself if present. else only present alert if there is no alert controller already showing.
    ///   - completion: completion handler once user pressed the button.
    func dissmissAlert(title: String, message: String, lblDone: String, onPrevAlert: Bool = false, completion: ((_ choice: Bool) -> Void)? = nil) {
    
        let objAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        objAlert.addAction(UIAlertAction(title: lblDone, style: .default, handler: { (_) in
            completion?(true)
            return
        }))
        
        kMainQueue.async {
            guard let topController = UIApplication.topViewController() else {
                kAppDelegate.window?.rootViewController?.present(objAlert, animated: true, completion: nil)
                return
            }
            if topController.isKind(of: UIAlertController.self) && onPrevAlert == false {
                print("Not showing alert as another UIAlertController is present already.")
                return
            }
            topController.present(objAlert, animated: true, completion: nil)
        }
    }
    
    
    /// This function is used to show a toast alert.
    ///
    /// - Parameters:
    ///   - msg: message to be shown on toast
    ///   - controller: controller from where this alert is called
    func showToast(with msg: String, completion: @escaping () -> Void) {
        
        let toast = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        
        let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(2)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            toast.dismiss(animated: true, completion: nil)
            completion()
            return
        }
        kMainQueue.async {
            guard let topController = UIApplication.topViewController() else {
                kAppDelegate.window?.rootViewController?.present(toast, animated: true, completion: nil)
                return
            }
            if topController.isKind(of: UIAlertController.self) {
                print("Not showing alert as another UIAlertController is present already.")
                return
            }
            topController.present(toast, animated: true, completion: nil)
        }
    }
    
    //MARK:- ------ Get device Info ------
    
    /// This function is used to get the device related information i.e device type, os version, device id.
    ///
    /// - Returns: returns device type, os version, device id.
    func getDeviceInfo() -> [String: String] {
        
        let strModel = UIDevice.current.model //// e.g. @"iPhone", @"iPod touch"
        let strVersion = UIDevice.current.systemVersion // e.g. @"4.0"
        let strDevID = UIDevice.current.identifierForVendor?.uuidString
        
        let tempDict: [String: String] = [
            "device_type": strModel,
            "os_version": strVersion,
            "device_id": strDevID ?? ""
            ]
        return tempDict
    }
}
