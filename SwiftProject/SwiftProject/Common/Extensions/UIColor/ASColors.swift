//
//  ASColors.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor representation of custom colors
extension UIColor {
    
    /// Circle Color One
    static let circleOne = UIColor.init(hexString: "#56afd1")
    
    /// Circle Color Two
    static let circleTwo = UIColor.init(hexString: "#f48fb1")
    
    /// Circle three
    static let circleThree = UIColor.init(hexString: "#48c2a8")
    
    /// Circle Four
    static let circleFour = UIColor.init(hexString: "#f1bc00")
    
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

//MARK:- HEX CONVERSION
extension UIColor {
    
    /// Hex string conversion for color
    /// - Parameter hexString: String
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
    
    /// Convert string to color
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
