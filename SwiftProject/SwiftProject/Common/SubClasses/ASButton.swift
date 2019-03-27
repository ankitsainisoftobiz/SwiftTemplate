//
//  ASButton.swift
//  LowRateInsuranceAgency
//
//  Created by softobiz on 12/7/17.
//  Copyright © 2017 Ankit_Saini. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class Button: UIButton {
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            if borderWidth > 0 {
                layer.borderWidth = borderWidth
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
}
