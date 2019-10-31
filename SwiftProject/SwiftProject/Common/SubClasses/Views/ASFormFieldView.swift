//
//  ASFormFieldView.swift
//  Dojo
//
//  Created by Ankit Saini on 24/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

/// View of Form field
@IBDesignable class ASFormFieldView: ASView {
    
    /// Text field for the Form
    var textField: ASFormTextField = ASFormTextField()
    
    /// View color
    @IBInspectable public var viewColor: UIColor? {
        didSet {
            setColors()
        }
    }
    
    /// Textfield Placeholder string
    @IBInspectable public var placeholder: String? {
        didSet {
            setPlaceholder()
        }
    }
    
    /// Textfield Placeholder string
    @IBInspectable public var keyboard: UIKeyboardType = .emailAddress {
        didSet {
            setKeyboard()
        }
    }
    
    /// Textfield Placeholder string
    @IBInspectable public var enterKey: UIReturnKeyType = .done {
        didSet {
            setKeyboard()
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
        ////Setup text field
        ///
        self.addSubview(textField)
        textField.anchorAllEdgesToSuperview(top: 8, left: 16, bottom: -16, right: -16, width: 0, height: 0)
        textField.setupFields(placeholder: (placeholder ?? ""), error: "", returnKey: enterKey, actionType: .normal)
        setFieldProperties()
        setupViewProperties()
    }
    
    /// Set properties for current View
    func setupViewProperties() {
        borderColor = Color.border.value
        setColors()
    }
    
    /// Set the colors of all views
    private func setColors() {
        if viewColor == nil {
            self.backgroundColor = Color.textFieldBGColor
        } else {
            self.backgroundColor = viewColor
        }
    }
    
    /// Set properties of Fields
    private func setFieldProperties() {
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.selectedLineColor = .clear
        textField.lineColor = .clear
        textField.font = Font.textFieldFont
        textField.titleFont = Font.textFieldTitleFont
        textField.placeholderFont = Font.textFieldPlaceHolderFont
        textField.errorColor = .red
        
    }
    
    /// Set Placeholders
    func setPlaceholder() {
        textField.placeholder = placeholder
    }
    
    /// Set Keyboard
    func setKeyboard() {
        textField.keyboardType = keyboard
        textField.returnKeyType = enterKey
    }
}
