//
//  ASFormTextField.swift
//  Dojo
//
//  Created by Ankit Saini on 24/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

/// Form Fields Delegates
protocol ASFormTextFieldDelegate: class {
    
    /// Text field is clicked
    /// - Parameter textField: UITextField
    func ASFormTextField(clicked textField: UITextField)
    
    /// Return key pressed of textfield
    /// - Parameter textField: UITextField
    func ASFormTextField(shouldReturn textField: UITextField)
}

/// Make Protocol optional
extension ASFormTextFieldDelegate {
    
    /// This Makes this protocol Optional
    func ASFormTextField(clicked textField: UITextField) {}
    /// This Makes this protocol Optional
    func ASFormTextField(shouldReturn textField: UITextField) {}
}

/// This class will represent the form textfields used in the application.
@IBDesignable class ASFormTextField: ASTextField, UITextFieldDelegate {
    
    /// Type of fields
    enum FieldType {
        /// Clickable field
        case clickable
        
        /// Normal field
        case normal
    }
    
    /// text field Actions
    private var textFieldAction: FieldType = .normal
    
    /// Delegate for current textfield
    weak var formDelegate: ASFormTextFieldDelegate?
    
    
    /// Setup Textfield properties
    /// - Parameter placeholder: String
    /// - Parameter error: String
    /// - Parameter returnKey: UIReturnKeyType
    /// - Parameter actionType: FieldType
    /// - Parameter lineHeight: CGFloat
    func setupFields(placeholder: String, error: String = "", returnKey: UIReturnKeyType = .done, actionType: FieldType = .normal, lineHeight: CGFloat = 0.0) {
        
        weak var weakSelf = self
        self.placeholder = placeholder
        
        self.selectedTitleColor = Color.lightText.value
        self.lineHeight = lineHeight
        self.selectedLineHeight = lineHeight
        
        self.placeholderColor = Color.lightText.value
        self.errorMessage = error
        self.autocorrectionType = .no
        self.keyboardType = .emailAddress
        self.returnKeyType = returnKey
        self.delegate = weakSelf
        self.textFieldAction = actionType
    }
    
    //MARK:- TEXTFIELD DELEGATES
    
    /// Asks the delegate if editing should begin in the specified text field.
    /// - Parameter textField: UITextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.textFieldAction == .clickable {
            formDelegate?.ASFormTextField(clicked: textField)
            return false
        }
        return true
    }
    
    /// Asks the delegate if the text field should process the pressing of the return button.
    /// - Parameter textField: UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            IQKeyboardManager.shared.resignFirstResponder()
        }
        formDelegate?.ASFormTextField(shouldReturn: textField)
        return false
    }
    
    /// Asks the delegate if the specified text should be changed.
    /// - Parameter textField: UITextField
    /// - Parameter range: NSRange
    /// - Parameter string: String
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.errorMessage = ""
        return true
    }
}
