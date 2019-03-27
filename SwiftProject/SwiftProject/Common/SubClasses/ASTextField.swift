//
//  ASTextField.swift
//  LowRateInsuranceAgency
//
//  Created by softobiz on 12/7/17.
//  Copyright © 2017 Ankit_Saini. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class TextField: UITextField {
    
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

// MARK:-
// MARK: FormTextField
// MARK:

/**
 * @Author : Ankit Saini on 11/12/2017 v1.0
 *
 * class name: FormTextField
 *
 * @description:  This class is used to create textfields in forms used in the app.
 *
 */
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

@objc protocol FormTextFieldDelegate {
    
    @objc optional func formTextFieldResigned(returnKey: UIReturnKeyType)
    @objc optional func formTextFieldClicked(textField: FormTextField)
    
}
class FormTextField: SkyFloatingLabelTextField, UITextFieldDelegate {
    
    enum FieldType {
        case clickable
        case normal
    }
    
    weak var formDelegate: FormTextFieldDelegate?
    private var textFieldAction: FieldType = .normal
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFields(placeholder: String, error: String = "", returnKey: UIReturnKeyType = .done, actionType: FieldType = .normal) {
        self.placeholder = placeholder
        self.textColor = .lightBlack
        self.selectedLineColor = .skyBlue
        self.selectedTitleColor = .skyBlue
        self.lineColor = .placeholderColor
        self.placeholderColor = .placeholderColor
        self.errorMessage = error
        self.autocorrectionType = .no
        self.keyboardType = .emailAddress
        self.font = Font.textField.val
        self.placeholderFont = Font.textField.val
        self.returnKeyType = returnKey
        self.delegate = self
        self.textFieldAction = actionType
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.textFieldAction == .clickable {
            formDelegate?.formTextFieldClicked!(textField: self)
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        formDelegate?.formTextFieldResigned!(returnKey: textField.returnKeyType)
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.errorMessage = ""
        return true
    }
}
