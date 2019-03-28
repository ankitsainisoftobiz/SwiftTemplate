//
//  ASMiscExtensions.swift
//  LowRateInsuranceAgency
//
//  Created by softobiz on 12/7/17.
//  Copyright © 2017 Ankit_Saini. All rights reserved.
//

import Foundation
import UIKit

//MARK:- NSObject
//MARK:
extension NSObject {
    
    func openAlert(title: String?,
                   message strMessage: String?,
                   with options: [String],
                   controller: UIViewController? = nil,
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
        if controller != nil {
            controller!.present(alert, animated: true, completion: nil)
            return
        }
        kAppDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func openActionSheet(title: String?,
                         message strMessage: String?,
                         with options: [String],
                         controller: UIViewController? = nil,
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
        
        if Screen.isIPAD == true {
            if controller != nil {
                alert.popoverPresentationController?.sourceView = controller?.view
            } else {
                alert.popoverPresentationController?.sourceView = kAppDelegate.window?.rootViewController?.view
            }
            alert.popoverPresentationController?.permittedArrowDirections = []
            alert.popoverPresentationController?.sourceRect = CGRect.init(x: Screen.centerW, y: Screen.centerH, width: 0, height: 0)
        }
        if controller != nil {
            controller!.present(alert, animated: true, completion: nil)
            return
        }
        kAppDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func viewShowHideAnimationWith(view: UIView, show: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = show
        }, completion: nil)
    }
    
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
    
    func statusBarHeight() -> CGFloat {
        let height = UIApplication.shared.statusBarFrame.height
        //print(height)
        return height
    }
}
//
//MARK:- UIButton
//MARK:
extension UIButton {
    
    func addRightBorder(borderColor: UIColor, borderWidth: CGFloat, yCo: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        border.frame = CGRect(x: self.frame.size.width - borderWidth,y: yCo, width: borderWidth, height: self.frame.size.height-(yCo*2))
        self.layer.addSublayer(border)
    }
    
    func addLeftBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func centerVerticallyWithPadding(padding: CGFloat) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        
        let totalHeight = (imageSize.height + titleSize.height + padding)
        
        self.imageEdgeInsets = UIEdgeInsets.init(top: -(totalHeight - imageSize.height), left: 0.0, bottom: 0.0, right: -titleSize.width)
        
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: -imageSize.width, bottom: -(totalHeight - titleSize.height), right: 0.0)
        
    }
    
    func centerVertically() {
        centerVerticallyWithPadding(padding: 6.0)
    }
    
}
//
//MARK:- UIScrollView
//MARK:
extension UIScrollView {
    func scrollToY(yCo: CGFloat) {
        let offset = CGPoint.init(x: 0, y: yCo)
        self.setContentOffset(offset, animated: true)
    }
}

//
//MARK:- StackView
//MARK:
extension UIStackView {
    func addTopBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
        self.layer.addSublayer(border)
    }
}


//
//MARK:- UIView
//MARK:
import QuartzCore
extension UIView {
    func addDashedBorder(color: UIColor = .black) {
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = color.cgColor
        yourViewBorder.lineDashPattern = [4, 4]
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(yourViewBorder)
    }
}

//
//MARK:- String
//MARK:
extension String {
    
    func attributtedString(appendString: String, color1: UIColor, color2: UIColor, font1: UIFont, font2: UIFont, lineSpacing: CGFloat = 0, align: Int = 0) -> NSAttributedString {
        let strSubTitle = appendString
        let fullString = "\(self)\(strSubTitle)"
        
        let attString = NSMutableAttributedString.init(string: fullString)
        
        //Font
        attString.addAttribute(NSAttributedString.Key.font, value: font1, range: NSRange(location: 0, length: self.count))
        attString.addAttribute(NSAttributedString.Key.font, value: font2, range: NSRange(location: fullString.count - strSubTitle.count, length: strSubTitle.count))
        
        //Color
        attString.addAttribute(NSAttributedString.Key.foregroundColor, value: color1, range: NSRange(location: 0, length: attString.length))
        attString.addAttribute(NSAttributedString.Key.foregroundColor, value: color2, range: NSRange(location: attString.length - strSubTitle.count, length: strSubTitle.count))
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        if lineSpacing > 0 {
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = lineSpacing // Whatever line spacing you want in points
            
        }
        if align > 0 {
            paragraphStyle.alignment = align == 1 ? .left : align == 2 ? .center : .right
        }
        
        if lineSpacing > 0 || align > 0 {
            attString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attString.length))
        }
        
        return attString
    }
    
    func isValidEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    func initials() -> (String, String) {
        if self.isEmpty == false {
            var fChar: Character?
            if let first = self.first {
                fChar = first
            }
            
            let arrName = self.components(separatedBy: " ")
            if arrName.count > 1 {
                let lastname = arrName[1]
                if let lName = lastname.first {
                    if fChar != nil {
                        return ("\(fChar!)", "\(lName)")
                    }
                    return ("", "\(lName)")
                }
                if fChar != nil {
                    return ("\(fChar!)", "")
                }
            }
            return (first != nil ? "\(first!)" : "", "")
        }
        return ("", "")
    }
    
    static func randomString(len: Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = Array(charSet)
        var s: String = ""
        for _ in 1...len {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
    
    func with(ext: MediaExtension) -> String {
        return "\(self)\(ext.dotName)"
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        if let data = self.data(using: .utf8) {
            do {
                if let serverResponse = try JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: Any] {
                    return serverResponse
                }
            } catch {
                print(error.localizedDescription)
                return [:]
            }
        }
        return [:]
    }
    
    func intVal() -> Int {
        if self.isEmpty == true {
            return 0
        }
        return (self as NSString).integerValue
    }
    
    func floatVal() -> CGFloat {
        let fl: CGFloat = CGFloat((self as NSString).doubleValue)
        return fl
    }
    
    func encoding() -> String {
        let str = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if str != nil { return str! }
        return self
    }
    
    func decoding() -> String {
        let str = self.removingPercentEncoding
        if str != nil { return str! }
        return self
    }
}

// MARK:-
// MARK: UIViewController
// MARK:


extension UIViewController {
    func disableSwipeBack(choice: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = !choice
    }
}

//
//MARK:- UIcollectionView
//MARK:
extension UICollectionView {
    
    func scrollToLast(animated: Bool) {
        if self.numberOfItems(inSection: 0) > 0 {
            let index = IndexPath(item: self.numberOfItems(inSection: 0)-1, section: 0)
            self.scrollToItem(at: index, at: .right, animated: animated)
        }
    }
    
    func scrollToFirst(animated: Bool) {
        if self.numberOfItems(inSection: 0) > 0 {
            let index = IndexPath(item: 0, section: 0)
            self.scrollToItem(at: index, at: .right, animated: animated)
        }
    }
    
    func scrollToItem(item: Int, animated: Bool) {
        if self.numberOfItems(inSection: 0) >= item {
            let index = IndexPath(item: item, section: 0)
            self.scrollToItem(at: index, at: .right, animated: animated)
        }
    }
}

//MARK:-
//MARK: TextField
//MARK:
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func getMaskPhoneNumber(maskFormat: String = "(XXX) XXX-XXXX") -> String {
        let resultString = self.text!
        
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
    
}

//MARK:- Dictionary

extension Dictionary {
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

//MARK:- UIViewController

extension UIViewController {
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}

extension UIApplication {
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

extension UITableView {
    func scrollToBottom() {
        kMainQueue.async {
            let sections = self.numberOfSections
            if sections > 0 {
                let rows = self.numberOfRows(inSection: sections-1)
                if rows > 0 {
                    let indexPath = IndexPath(row: rows-1, section: sections-1)
                    self.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
}

extension Bundle {
    var displayName: String? {
        let name = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return name ?? object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
    }
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
}

extension Int {
    func inThousand() -> String {
        return self/1000 > 0 ? "\(self/1000)K" : "\(self)"
    }
}

extension CGFloat {
    func inThousand() -> String {
        return self/1000 >= 1 ? "\(Int(self/1000))K" : "\(self)"
    }
}


//MARK:- UINavigationBar
extension UINavigationBar {
    /// SwifterSwift: Set navigationBar background and text colors
    ///
    /// - Parameters:
    ///   - background: backgound color
    ///   - text: text color
    public func setColors(background: UIColor, text: UIColor) {
        isTranslucent = false
        backgroundColor = background
        barTintColor = background
        setBackgroundImage(UIImage(), for: .default)
        tintColor = text
        titleTextAttributes = [.foregroundColor: text]
    }
    
    /// SwifterSwift: Make navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    public func makeTransparent(withTint tint: UIColor = .white) {
        isTranslucent = true
        backgroundColor = .clear
        barTintColor = .clear
        setBackgroundImage(UIImage(), for: .default)
        tintColor = tint
        titleTextAttributes = [.foregroundColor: tint]
        shadowImage = UIImage()
    }
}


extension URL {
    func valueOf(_ queryParamaterName: String) -> String {
        guard let url = URLComponents(string: self.absoluteString) else { return "" }
        let dict = url.queryItems?.first(where: { $0.name == queryParamaterName })
        guard let val = dict?.value else { return "" }
        return val
    }
}
