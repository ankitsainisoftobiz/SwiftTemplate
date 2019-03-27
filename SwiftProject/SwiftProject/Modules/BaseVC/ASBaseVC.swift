//
//  ASBaseVC.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 24/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ASBaseVC: UIViewController {

    //MARK:- View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    // MARK:-
    // MARK: Navigation Bar
    
    /// This function is used to set the title of the navigation bar.
    ///
    /// - Parameters:
    ///   - withTitle: Bar Title
    ///   - font: Font
    ///   - color: Text Color
    func navBar(withTitle: String, font: UIFont = Font.navTitle.val, color: UIColor = .white) {
        self.navigationItem.title = withTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
    }
    
    func navBarButtons(left: UIImage?, right: UIImage?, shouldBack: Bool = false) {
        btnLeftMenu.frame = CGRect.init(x: 0, y: 0, width: 40, height: 30)
        
        if shouldBack == true {
            btnLeftMenu.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        } else {
            btnLeftMenu.addTarget(self, action: #selector(navLeftClicked(sender:)), for: .touchUpInside)
        }
        
        if left != nil {
            btnLeftMenu.setImage(left, for: .normal)
        }
        btnLeftMenu.contentHorizontalAlignment = .left
        let item1 = UIBarButtonItem.init(customView: btnLeftMenu)
        
        btnRightMenu.frame = CGRect.init(x: 0, y: 0, width: 40, height: 30)
        btnRightMenu.addTarget(self, action: #selector(navRightClicked(sender:)), for: .touchUpInside)
        btnRightMenu.titleLabel?.font = Font.navButton.val
        if right != nil {
            btnRightMenu.setImage(right, for: .normal)
        }
        let item2 = UIBarButtonItem.init(customView: btnRightMenu)
        
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)
        self.navigationItem.setRightBarButtonItems([item2], animated: true)
    }

    // MARK:-
    // MARK: Action Methods
    // MARK:
    
    @objc func navLeftClicked(sender: UIButton) {
        print("left clicked")
    }
    
    @objc func navRightClicked(sender: UIButton) {
        print("right clicked")
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissVC() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- LAZY INITIALIZERS
    
    lazy var btnLeftMenu: UIButton = {
        return UIButton()
    }()
    
    lazy var btnRightMenu: UIButton = {
        return UIButton()
    }()
}
// MARK:-
// MARK: Keyboard Manager
extension ASBaseVC {
    func resignKeyboard() {
        IQKeyboardManager.shared.resignFirstResponder()
    }
    
    func gotoNextField() {
        if IQKeyboardManager.shared.canGoNext == true {
            _ = IQKeyboardManager.shared.goNext()
        }
    }
    
    func gotoPrevField() {
        if IQKeyboardManager.shared.canGoPrevious == true {
            _ = IQKeyboardManager.shared.goPrevious()
        }
    }
}
