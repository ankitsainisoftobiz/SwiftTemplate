//
//  ASButton.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

/// This class will extends the various properties at design time like: cornerRadius, borderWidth, borderColor
@IBDesignable class ASButton: UIButton {
    
    /// borderWidth: CGFloat
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            if borderWidth > 0 {
                layer.borderWidth = borderWidth
            }
        }
    }
    
    /// borderColor: UIColor
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /// cornerRadius: CGFloat
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
}


/// This class will be used to add Buttons with Spinning loader feature.
@IBDesignable class LoadingButton: ASButton {
    
    /// Original String of button
    var originalButtonText: String?
    
    /// UIActivityIndicatorView in the button.
    var activityIndicator: UIActivityIndicatorView?
    
    /// This will start loading spinner inside the button.
    ///
    /// - Parameter screenInteraction: If passed false then it will stop the screen interaction untill loader is on.
    func showLoading(screenInteraction: Bool = true) {
        kAppDelegate.screenInteraction(enable: screenInteraction)
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        
        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }
        showSpinning()
    }
    
    /// This function will stop the loading spinner and reset the button to its previous value.
    func hideLoading() {
        kAppDelegate.screenInteraction(enable: true)
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator?.stopAnimating()
    }
    
    /// Create spinner instance.
    ///
    /// - Returns: UIActivityIndicatorView
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }
    
    /// Show Spinner.
    private func showSpinning() {
        if activityIndicator != nil {
            activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(activityIndicator!)
            centerActivityIndicatorInButton()
            activityIndicator?.startAnimating()
        }
    }
    
    /// Center the spinner inside the button.
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
