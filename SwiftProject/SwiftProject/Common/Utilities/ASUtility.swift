//
//  ASUtility.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit

class ASUtility: NSObject {
    
    static let shared = ASUtility()
    
    /// This function is used to show an alert popup for confirmation of user.
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - message: Brief message for the alert
    ///   - lblDone: Lable string for the done button
    ///   - lblCancel: lable string for the cancel button
    ///   - controller: controller from where this alert is called
    ///   - completion: return the result.
    func showConfirmAlert(with title: String, message: String, lblDone: String, lblCancel: String, on controller: UIViewController? = nil, completion: @escaping (_ choice: Bool) -> Void) {
        
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
            if controller != nil {
                controller!.present(objAlert, animated: true, completion: nil)
                return
            }
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
    func dissmissAlert(title: String, message: String, lblDone: String, on controller: UIViewController? = nil) {
        let objAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        objAlert.addAction(UIAlertAction(title: lblDone, style: .default, handler: { (_) in
        }))
        
        kMainQueue.async {
            if controller != nil {
                controller!.present(objAlert, animated: true, completion: nil)
                return
            }
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
    
    
    /// This function is used to show a toast alert.
    ///
    /// - Parameters:
    ///   - msg: message to be shown on toast
    ///   - controller: controller from where this alert is called
    func showToast(with msg: String, on controller: UIViewController? = nil, completion: @escaping () -> Void) {
        
        let toast = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        
        let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(2)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            completion()
            toast.dismiss(animated: true, completion: nil)
        }
        kMainQueue.async {
            if controller != nil {
                controller!.present(toast, animated: true, completion: nil)
                return
            }
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
