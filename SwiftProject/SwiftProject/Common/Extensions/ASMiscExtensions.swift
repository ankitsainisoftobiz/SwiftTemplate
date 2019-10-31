//
//  ASMiscExtensions.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

//MARK:- NSObject
//MARK:

// MARK: - GLOBAL FUNCTIONS
extension NSObject {
    
    /// This will be used to present an UIAlertController
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - strMessage: Message of the alert
    ///   - options: Buttons array of string
    ///   - didSelect: selected index of option
    func openAlert(title: String?,
                   message strMessage: String?,
                   with options: [String],
                   didSelect:@escaping(_ index: Int?) -> Void) {
        let alert = UIAlertController(title: title, message: strMessage, preferredStyle: .alert)
        for (i,option) in options.enumerated() {
            let action = UIAlertAction(title: option, style: .default, handler: { (_) in
                didSelect(i)
            })
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: L10n.cancel.string, style: .cancel) { (_) in
        }
        alert.addAction(cancel)
        guard let topController = UIApplication.topViewController() else {
            kAppDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        topController.present(alert, animated: true, completion: nil)
    }
    
    /// This will be used to present an Actiuon sheet
    ///
    /// - Parameters:
    ///   - title: Title of the sheet
    ///   - strMessage: Message of the sheet
    ///   - options: array of options
    ///   - didSelect: Selected index of the option
    func openActionSheet(title: String?,
                         message strMessage: String?,
                         with options: [String],
                         didSelect:@escaping(_ index: Int?) -> Void) {
        let alert = UIAlertController(title: title, message: strMessage, preferredStyle: .actionSheet)
        for (i,option) in options.enumerated() {
            let action = UIAlertAction(title: option, style: .default, handler: { (_) in
                didSelect(i)
            })
            //action.setValue(#imageLiteral(resourceName: "doc_pdf"), forKey: "image")
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: L10n.cancel.string, style: .cancel) { (_) in
        }
        alert.addAction(cancel)
        
        guard let topController = UIApplication.topViewController() else {
            alert.popoverPresentationController?.sourceView = kAppDelegate.window?.rootViewController?.view
            alert.popoverPresentationController?.permittedArrowDirections = []
            alert.popoverPresentationController?.sourceRect = CGRect.init(x: Screen.centerW, y: Screen.centerH, width: 0, height: 0)
            kAppDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        if Screen.isIPAD == true {
            alert.popoverPresentationController?.sourceView = topController.view
            alert.popoverPresentationController?.permittedArrowDirections = []
            alert.popoverPresentationController?.sourceRect = CGRect.init(x: Screen.centerW, y: Screen.centerH, width: 0, height: 0)
        }
        topController.present(alert, animated: true, completion: nil)
    }
    
    /// This will animate the view when show or hide them
    ///
    /// - Parameters:
    ///   - view: UIView instance on which animation will be applied
    ///   - show: Show => True, Hide => False
    func viewShowHideAnimationWith(view: UIView, show: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = !show
        }, completion: nil)
    }
    
    /// Get the safe area values of auto layout.
    ///
    /// - Returns: top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat
    func safeAreaHeight() -> (top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.keyWindow else {return (0, 0, 0, 0)}
            
            let topPadding = window.safeAreaInsets.top
            let bottomPadding = window.safeAreaInsets.bottom
            let leftPadding = window.safeAreaInsets.left
            let rightPadding = window.safeAreaInsets.right
            
            return (topPadding, bottomPadding, leftPadding, rightPadding)
        }
        return (0, 0, 0, 0)
    }
    
    /// Returns the status bar heiht of the screen
    ///
    /// - Returns: CGFloat
    func statusBarHeight() -> CGFloat {
        let height = UIApplication.shared.statusBarFrame.height
        //print(height)
        return height
    }
    
    
    /// This function will remove all the coockies associated with URLCache
    func clearCacheCookies() {
        //
        //Cookies
        //
        //let cookie = HTTPCookie.self
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            print("cookieName:"+cookie.name+"="+cookie.value)
            cookieJar.deleteCookie(cookie)
        }
        //
        //cache
        //
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    /// Convert seconds to Hours Minutes Seconds
    ///
    /// - Parameter seconds: Int
    /// - Returns: h: Int, m: Int, s: Int
    func secondsToHoursMinutesSeconds (seconds: Int) -> (h: Int, m: Int, s: Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
//
//MARK:- UIButton
//MARK:
///UIButton
extension UIButton {
    
    /// Add a border to the right of the UIButton.
    ///
    /// - Parameters:
    ///   - borderColor: UIColor
    ///   - borderWidth: CGFloat
    ///   - yCo: CGFloat
    func addRightBorder(borderColor: UIColor, borderWidth: CGFloat, yCo: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        border.frame = CGRect(x: self.frame.size.width - borderWidth,y: yCo, width: borderWidth, height: self.frame.size.height-(yCo*2))
        self.layer.addSublayer(border)
    }
    
    /// Add border to left of the UIButton
    ///
    /// - Parameters:
    ///   - color: UIColor
    ///   - width: CGFloat
    func addLeftBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    /// Center the image and title of UIButton
    ///
    /// - Parameter padding: CGFloat
    func centerVerticallyWithPadding(padding: CGFloat) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        
        let totalHeight = (imageSize.height + titleSize.height + padding)
        
        self.imageEdgeInsets = UIEdgeInsets.init(top: -(totalHeight - imageSize.height), left: 0.0, bottom: 0.0, right: -titleSize.width)
        
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: -imageSize.width, bottom: -(totalHeight - titleSize.height), right: 0.0)
        
    }
    
    /// Center the image and title of UIButton
    func centerVertically() {
        centerVerticallyWithPadding(padding: 6.0)
    }
    
}
//
//MARK:- StackView
//MARK:
extension UIStackView {
    
    /// Add a border to the top of the UIStackView.
    ///
    /// - Parameters:
    ///   - color: UIColor
    ///   - width: CGFloat
    func addTopBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
        self.layer.addSublayer(border)
    }
}

//MARK:-
//MARK: TextField
//MARK:
extension UITextField {
    
    /// Set left padding of the field.
    ///
    /// - Parameter amount: CGFloat
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    /// Set right padding of the field.
    ///
    /// - Parameter amount: CGFloat
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    /// Mask a textfield according to a paatern like (XXX) XXX-XXXX
    ///
    /// - Parameter maskFormat: (XXX) XXX-XXXX
    /// - Returns: String
    func getMaskPhoneNumber(maskFormat: String = "(XXX) XXX-XXXX") -> String {
        let resultString = self.text ?? ""
        
        let cleanPhoneNumber = resultString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let mask = maskFormat
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    /// Get Unmask phone number from a string
    /// - Parameter literals: [String] = [" ", "(", ")", "-"]
    func getUnMaskPhone(literals: [String] = [" ", "(", ")", "-"]) -> String {
        var phone = self.text ?? ""
        for item in literals {
            phone = phone.replacingOccurrences(of: item, with: "")
        }
        return phone
    }
    
}

//MARK:- Dictionary
extension Dictionary {
    
    /// Convert dictionary to string
    ///
    /// - Returns: String
    func toString() -> String {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: []) {
            let theJSONText = String(data: theJSONData, encoding: .ascii)
            
            if theJSONText != nil {
                return theJSONText!
            }
            return ""
        }
        return ""
    }
    
    /// Conver the dictionary to Data()
    ///
    /// - Returns: Data
    func toData() -> Data {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            return jsonData
        } catch {
            print(error.localizedDescription)
            return Data()
        }
    }
    
    /// get a string value from the dictionary
    ///
    /// - Parameter name: Key name
    /// - Returns: value String
    func getStringVal(name: String) -> String {
        
        guard let dict = self as? Dictionary<String, Any> else { return "" }
        
        if let obj = dict[name] as? String {
            return obj
        } else if let obj = dict[name] as? Int {
            return "\(obj)"
        } else {
            return ""
        }
    }
}

// MARK:-
// MARK: UIViewController
// MARK:
extension UIViewController {
    
    /// Disable swipe back of navigationController
    ///
    /// - Parameter choice: true or false
    func disableSwipeBack(choice: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = !choice
    }

    /// String representation of UIViewController name
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? ""
    }
}
//MARK:- UIApplication
extension UIApplication {
    
    /// Fetch the topViewController
    ///
    /// - Parameter controller: rootViewController
    /// - Returns: UIViewController
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

//MARK:- Bundle
extension Bundle {
    
    /// Bundle displayName
    var displayName: String? {
        let name = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return name ?? object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
    }
    
    /// Bundle releaseVersionNumber String
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// Bundle buildVersionNumber String
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
}
//MARK:- Int
extension Int {
    
    /// Represent the value in Thousand
    ///
    /// - Returns: String
    func inThousand() -> String {
        return self/1000 > 0 ? "\(Int(self/1000))K" : "\(self)"
    }
}

// MARK: - CGFloat
extension CGFloat {
    
    /// Represent the value in Thousand
    ///
    /// - Returns: String
    func inThousand() -> String {
        return self/1000 >= 1 ? "\(Int(self/1000))K" : "\(self)"
    }
}

// MARK: - URL
extension URL {
    
    /// Parse Query Url
    ///
    /// - Parameter queryParamaterName: name of the key
    /// - Returns: String value for the key
    func valueOf(_ queryParamaterName: String) -> String {
        guard let url = URLComponents(string: self.absoluteString) else { return "" }
        let dict = url.queryItems?.first(where: { $0.name == queryParamaterName })
        guard let val = dict?.value else { return "" }
        return val
    }
}
