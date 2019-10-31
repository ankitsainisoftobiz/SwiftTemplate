//
//  ASStringExt.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

//MARK:- ================== HTML CONVERSION ====================
extension Data {
    
    /// HTML to Attributed String
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    
    /// HTML to String
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    
    /// HTML to Attributed String
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    
    /// HTML to String
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
//MARK:- ================== [ HTML CONVERSION END ] ====================
//
//MARK:- String
//MARK:
extension String {
    
    /// Create an attributted string from a string.
    ///
    /// - Parameters:
    ///   - appendString: second string to be appended
    ///   - color1: UIColor of first string
    ///   - color2: UIColor of second string
    ///   - font1: UIFont for first string
    ///   - font2: UIFont of second string
    ///   - lineSpacing: CGFloat space between lines
    ///   - align: Int-> 1 =left, 2 = right else center
    /// - Returns: New NSAttributedString
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
    
    /// Check if email string is valid
    ///
    /// - Returns: True if valid else false
    func isValidEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    /// Create initials from a string i.e Ankit Saini => (A, S)
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
    
    /// Create a random string of some length
    ///
    /// - Parameter len: Total lenth of the string
    /// - Returns: Random String
    static func randomString(len: Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let c = Array(charSet)
        var s: String = ""
        for _ in 1...len {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
    
    /// Return image name with extension of file type
    ///
    /// - Parameter ext: MediaExtension
    /// - Returns: String
    func with(ext: MediaExtension) -> String {
        return "\(self)\(ext.dotName)"
    }
    
    /// Convert the string to Dictionary
    ///
    /// - Returns: Dictionary<String, Any>
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
    
    /// Converts the String to Int.
    ///
    /// - Returns: Int
    func intVal() -> Int {
        if self.isEmpty == true {
            return 0
        }
        return (self as NSString).integerValue
    }
    
    /// Converts the String into CGFloat
    ///
    /// - Returns: CGFloat
    func floatVal() -> CGFloat {
        let fl: CGFloat = CGFloat((self as NSString).doubleValue)
        return fl
    }
    
    /// Encode the string into url encoded string
    ///
    /// - Returns: Encoded String
    func encoding() -> String {
        let str = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if str != nil { return str! }
        return self
    }
    
    /// Decode url encoded string into normal string
    ///
    /// - Returns: String
    func decoding() -> String {
        let str = self.removingPercentEncoding
        if str != nil { return str! }
        return self
    }
}
