//
//  Colors.swift
//  SwiftProject
//
//  Created by softobiz-as on 10/09/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

///
///USAGE
///
let shadowColor = Color.shadow.value
let shadowColorWithAlpha = Color.shadow.withAlpha(0.5)
let customColorWithAlpha = Color.custom(hexString: "#123edd", alpha: 0.25).value

/// create an enum to handle each and every colour required in our application.
///
/// - theme: Colours on Navigation Bar, Button Titles, Progress Indicator etc.
/// - border: Hair line separators in between views.
/// - shadow: Shadow colours for card like design.
/// - darkBackground: Dark background colour to group UI components with light colour.
/// - lightBackground: Light background colour to group UI components with dark colour.
/// - intermidiateBackground: Used for grouping UI elements with some other colour scheme.
/// - darkText: Dark Text Colour
/// - lightText: Light Text Colour
/// - intermidiateText: Intermediate Text Colour
/// - affirmation: Colour to show success, something right for user.
/// - negation: Colour to show error, some danger zones for user.
/// - custom: custom(hexString: String, alpha: Double) to get UIColor values other than the previous ones.
enum Color {
    
    case theme
    case border
    case shadow
    
    case darkBackground
    case lightBackground
    case intermidiateBackground
    
    case darkText
    case lightText
    case intermidiateText
    
    case affirmation
    case negation
    // 1
    case custom(hexString: String, alpha: Double)
    // 2
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

// MARK: - Put the values (hex string or RGB literal) to the following extension of Color enum
extension Color {
    
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .border:
            instanceColor = UIColor(hexString: "#333333")
        case .theme:
            instanceColor = UIColor(hexString: "#ffcc00")
        case .shadow:
            instanceColor = UIColor(hexString: "#cccccc")
        case .darkBackground:
            instanceColor = UIColor(hexString: "#999966")
        case .lightBackground:
            instanceColor = UIColor(hexString: "#cccc66")
        case .intermidiateBackground:
            instanceColor = UIColor(hexString: "#cccc99")
        case .darkText:
            instanceColor = UIColor(hexString: "#333333")
        case .intermidiateText:
            instanceColor = UIColor(hexString: "#999999")
        case .lightText:
            instanceColor = UIColor(hexString: "#cccccc")
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
