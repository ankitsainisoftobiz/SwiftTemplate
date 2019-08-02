//
//  ASColors.swift
//  LowRateInsuranceAgency
//
//  Created by softobiz on 12/7/17.
//  Copyright © 2017 Ankit_Saini. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let skyBlue = UIColor.init(hexString: "#0189EF")
    static let lightBlack = UIColor.init(hexString: "#333333")
    static let fbColor = UIColor.init(hexString: "#0d4c92")
    static let chatSection = UIColor.init(hexString: "#CEEAFD")
    static let linkedinColor = UIColor.init(hexString: "#0172b1")
    static let placeholderColor = UIColor.init(hexString: "#9dacbc")
    static let lightGrayColor = UIColor.init(hexString: "#F2F2F2")
    static let titleBlack = UIColor.init(hexString: "#212121")
    static let subTitleBlack = UIColor.init(hexString: "#666666")
    static let greenDot = UIColor.init(hexString: "#63b75f")
    static let darkGreenDot = UIColor.init(hexString: "#2EA282")
    static let redDot = UIColor.init(hexString: "#d67070")
    static let grayDot = UIColor.init(hexString: "#cccccc")
    static let blueButton = UIColor.init(hexString: "#2855A9")
    
    static let bgColor = UIColor.init(hexString: "#F5F5F5")
    
    static let circleOne = UIColor.init(hexString: "#56afd1")
    static let circleTwo = UIColor.init(hexString: "#f48fb1")
    static let circleThree = UIColor.init(hexString: "#48c2a8")
    static let circleFour = UIColor.init(hexString: "#f1bc00")
    
    static let refBlue = UIColor.init(hexString: "#2753a8")
    static let refGreen = UIColor.init(hexString: "#32af94")
    static let refRed = UIColor.init(hexString: "#d85656")
    static let refYellow = UIColor.init(hexString: "#db8c0f")
    
    
    // MARK:-
    // MARK: Character Color
    // MARK:
    
    /// This function is used to assign diffrent background color to button or lable according to character
    ///
    /// - Parameter char: Pass the first character
    /// - Returns: this will return the UIColor for every character
    class func with(char: String) -> UIColor {
        let arrColors: [UIColor] = [.circleOne, .circleTwo, .circleThree, .circleFour]
        let arrAlpha = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        let position = arrAlpha.firstIndex(of: char.uppercased())
        if position != nil {
            let reminder = position! % arrColors.count
            if arrColors.count  > reminder {
                return arrColors[reminder]
            }
        }
        
        return .circleOne
    }
}

extension UIColor {
    
    convenience init(hexString: String) {
        let hexString: NSString = hexString.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        let scanner            = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format: "#%06x", rgb) as String
    }
    
    
}
