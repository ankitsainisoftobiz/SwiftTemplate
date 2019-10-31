//
//  ASFormLogo+ProgressView.swift
//  Dojo
//
//  Created by Ankit Saini on 29/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

/// View of Form Header with ProgressBar and logo
@IBDesignable class ASFormLogoProgressView: ASView {
    
    /// Image view for the logo
    var imgLogoView: UIImageView = UIImageView()
    
    /// Progress Bae view for the progress
    var progressBar: UIProgressView = UIProgressView()
    
    /// Logo Image
    @IBInspectable public var logoImage: UIImage? {
        didSet {
            setItemProperties()
        }
    }
    
    /// Background color of progress Bar
    @IBInspectable public var progressBarBackground: UIColor? {
        didSet {
            setItemProperties()
        }
    }
    
    /// Tint color of progress Bar
    @IBInspectable public var progressBarTintColor: UIColor? {
        didSet {
            setItemProperties()
        }
    }
    
    /// Set value of progress bar
    @IBInspectable public var progressValue: Float = 0.0 {
        didSet {
            setProgressValue()
        }
    }
    
    //MARK:-
    //MARK:- Initialization
    
    /// Initialize main view
    /// - Parameter frame: CGRect
    override public init(frame: CGRect) {
        super.init(frame: frame)
        customInitialization()
    }
    
    
    /// Initializations
    ///
    /// - Parameter aDecoder: NSCoder
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInitialization()
    }
    
    //MARK:- Overriden methods.
    
    /// prepareForInterfaceBuilder
    override public func prepareForInterfaceBuilder() {
        customInitialization()
    }
    
    /// layoutSubviews
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK:- CUSTOMISATIONS
    
    /// Initialize all views
    private func customInitialization() {
        ////
        ////Add Image View
        ///
        self.addSubview(imgLogoView)
        imgLogoView.anchorAllEdgesToSuperview(top: 0, left: 0, bottom: 0, right: 0, width: 0, height: 60)
        ///
        /// Add Progress View
        ///
        self.addSubview(progressBar)
        progressBar.anchor(top: imgLogoView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 4)
        
        setItemProperties()
    }
    
    /// Set the properties of the items contained in This view.
    private func setItemProperties() {
        imgLogoView.image = logoImage ?? #imageLiteral(resourceName: "login_logo")
        imgLogoView.contentMode = .left
        
        progressBar.backgroundColor = progressBarBackground ?? Color.lightText.value
        progressBar.tintColor = progressBarTintColor ?? Color.progressGreenColor
    }
    
    /// Set Value of progress Bar
    private func setProgressValue() {
        progressBar.progress = progressValue
    }
}
