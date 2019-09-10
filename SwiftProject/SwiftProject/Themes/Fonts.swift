//
//  Fonts.swift
//  SwiftProject
//
//  Created by softobiz-as on 10/09/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

/// Fonts
struct Font {
    // Usage Examples
    static let navTitle            = Font(.system, size: .standard(.h4)).instance
    static let navButton            = Font(.system, size: .standard(.h4)).instance
    static let textField            = Font(.system, size: .standard(.h4)).instance
    static let formButtons            = Font(.systemWeighted(weight: .semibold), size: .standard(.h3)).instance
    
    static let robotoBlack14       = Font(.installed(.robotoBlack), size: .standard(.h4)).instance
    static let helveticaLight13    = Font(.custom("Helvetica-Light"), size: .custom(13.0)).instance
    
    
    /// FontType
    ///
    /// - installed: installed(FontName)
    /// - custom: custom(String)
    /// - system: system
    /// - systemBold: systemBold
    /// - systemItatic: systemItatic
    /// - systemWeighted: systemWeighted(weight: UIFont.Weight)
    /// - monoSpacedDigit: monoSpacedDigit(size: Double, weight: Double)
    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: UIFont.Weight)
        case monoSpacedDigit(size: Double, weight: Double)
    }
    
    /// FontSize
    ///
    /// - standard: standard(StandardSize)
    /// - custom: custom(Double)
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    /// FontName
    ///
    /// - robotoBlack: "Roboto-Black"
    enum FontName: String {
        case robotoBlack            = "Roboto-Black"
    }
    
    /// StandardSize
    ///
    /// - h1: 20.0
    /// - h2: 18.0
    /// - h3: 16.0
    /// - h4: 14.0
    /// - h5: 12.0
    /// - h6: 10.0
    enum StandardSize: Double {
        case h1 = 20.0
        case h2 = 18.0
        case h3 = 16.0
        case h4 = 14.0
        case h5 = 12.0
        case h6 = 10.0
    }
    
    /// FontType
    var type: FontType
    
    /// FontSize
    var size: FontSize
    
    /// init
    ///
    /// - Parameters:
    ///   - type: FontType
    ///   - size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

// MARK: - Font
extension Font {
    
    /// UIFont
    var instance: UIFont {
        
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        case .systemWeighted(let weight):
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value),
                                             weight: weight)
        case .monoSpacedDigit(let size, let weight):
            instanceFont = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size),
                                                            weight: UIFont.Weight(rawValue: CGFloat(weight)))
        }
        return instanceFont
    }
}
