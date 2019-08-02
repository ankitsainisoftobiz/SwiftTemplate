//
//  AppDelegateExt.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import SVProgressHUD

extension AppDelegate {
    
    /// This function is used to show the spinning loader on view and hide the loader from the view.
    ///
    /// - Parameters:
    ///   - title: This will be written under the spinner.
    ///   - isOn: This will disable the user interaction to app if true.
    func showLoader(with title: String = "", interaction isOn: Bool = false) {
        kMainQueue.async {
            if isOn == false {
                if UIApplication.shared.isIgnoringInteractionEvents == false { //If not already ignoring the screen touch's
                    UIApplication.shared.beginIgnoringInteractionEvents()
                }
                
            }
            SVProgressHUD.show(withStatus: title)
        }
    }
    
    /// This will replace the title under the spinning loader.
    ///
    /// - Parameter title: New title to replace with.
    func replaceLoader(title: String = "") {
        kMainQueue.async {
            SVProgressHUD.setStatus(title)
        }
    }
    
    /// Hide the spinning loader
    func hideLoader() {
        kMainQueue.async {
            if UIApplication.shared.isIgnoringInteractionEvents == true {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            SVProgressHUD.dismiss()
        }
    }
}

extension AppDelegate {
    /// Used to check the internet is available or not. Return bool to controll further processings.
    ///
    /// - Parameter toast: weather to show toast if not connected or not.
    /// - Returns: return true if internet is connected else return false.
    func checkInternet(with toast: Bool = true) -> Bool {
        let connection = reachability.connection
        switch connection {
        case .cellular:
            print("internet connected: cellular")
            return true
        case .none:
            if toast == true {
                kMainQueue.async {
                    ASUtility.shared.showToast(with: L10n.noInternet.string) {}
                }
            }
            print("internet not connected: None")
            return false
        case .wifi:
            print("internet connected: wifi")
            return true
        }
    }
    
    
    /// Start monitoring the internet continueusly.
    func internetMonitoring() {
        DefaultCenter.notification.addObserver(self, selector: #selector(checkReachability(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        do {
            try reachability.startNotifier()
        } catch let err {
            print("+++++++++++ ERROR IN INTERNET +++++++++++++++++")
            print(err.localizedDescription)
        }
    }
    
    @objc func checkReachability(notification: NSNotification) {
        
        if checkInternet(with: false) == true {
            print("INTERNET Connected")
        } else {
            print("INTERNET DIS-Connected")
        }
        
    }
}
