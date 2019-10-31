//
//  Colors.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

///
///USAGE
///

/// Create an enum to handle each and every colour required in our application.
enum Color {
    /// Shadow Color
    static let shadowColor = Color.shadow.value

    /// Shadow Color with Alpha
    static let shadowColorWithAlpha = Color.shadow.withAlpha(0.5)

    /// Custom Color with Alpha
    static let customColorWithAlpha = Color.custom(hexString: "#123edd", alpha: 0.25).value

    /// Instagram Color
    static let instaColor = Color.custom(hexString: "#DE5153", alpha: 1.0).value

    /// Facebook Color
    static let fbColor = Color.custom(hexString: "#2D4486", alpha: 1.0).value

    /// TextField Background Color
    static let textFieldBGColor = Color.custom(hexString: "#1b1b1b", alpha: 1.0).value

    /// Green Color for progress bar
    static let progressGreenColor = Color.custom(hexString: "#00d169", alpha: 1.0).value
    
    ////
    /// CASE STARTS FROM HERE
    
    ///
    ///Colours on Navigation Bar, Button Titles, Progress Indicator etc.
    case theme
    
    ///Hair line separators in between views.
    case border
    
    /// Shadow colours for card like design.
    case shadow
    
    /// Dark background colour to group UI components with light colour.
    case darkBackground
    
    /// Light background colour to group UI components with dark colour.
    case lightBackground
    
    /// Used for grouping UI elements with some other colour scheme.
    case intermidiateBackground
    
    /// Dark Text Colour
    case darkText
    
    /// Light Text Colour
    case lightText
    
    /// Intermediate Text Colour
    case intermidiateText
    
    /// Colour to show success, something right for user.
    case affirmation
    
    /// Colour to show error, some danger zones for user.
    case negation
    
    /// custom(hexString: String, alpha: Double) to get UIColor values other than the previous ones.
    case custom(hexString: String, alpha: Double)
    
    /// withAlpha(_ alpha: Double) to get UIColor values with opacity.
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

/// Put the values (hex string or RGB literal) to the following extension of Color enum
extension Color {
    
    /// Color from hex
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .border:
            instanceColor = UIColor(hexString: "#3c3c3c")
        case .theme:
            instanceColor = UIColor(hexString: "#212121")
        case .shadow:
            instanceColor = UIColor(hexString: "#cccccc")
        case .darkBackground:
            instanceColor = UIColor(hexString: "#1b1b1b")
        case .lightBackground:
            instanceColor = UIColor(hexString: "#212121")
        case .intermidiateBackground:
            instanceColor = UIColor(hexString: "#cccc99")
        case .darkText:
            instanceColor = UIColor(hexString: "#333333")
        case .intermidiateText:
            instanceColor = UIColor(hexString: "#999999")
        case .lightText:
            instanceColor = UIColor(hexString: "#d8d8d8")
        case .affirmation:
            instanceColor = UIColor(hexString: "#00ff66")
        case .negation:
            instanceColor = UIColor(hexString: "#ff3300")
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return instanceColor
    }
}
