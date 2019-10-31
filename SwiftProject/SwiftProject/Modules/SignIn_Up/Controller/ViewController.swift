//
//  ViewController.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit

class ViewController: ASBaseVC {

    var timer: RepeatingTimer?
    
    
    //MARK:- View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ///1
//        navBar(withTitle: "Home", color: .black)
//        navBarButtons(left: #imageLiteral(resourceName: "nav_back"), right: #imageLiteral(resourceName: "nav_back"), shouldBack: false)
        self.navigationController?.navigationBar.setColors(background: Color.fbColor, text: UIColor.white)
        
        ///2
//        _ = Storyboard.main.instance.instantiateViewController(withIdentifier: ViewController.storyboardID)
//        _ = Storyboard.main.viewController(viewControllerClass: ViewController.self)
        
        
        ///3
//        kMainQueue.asyncAfter(deadline: .now() + 1.0) {
//            let params = ["version": 1]
//            kAppDelegate.showLoader()
//            UserLogin.authenticateUser(with: params, completion: { (isSuccess) in
//                kAppDelegate.hideLoader()
//                print(isSuccess)
//            })
//        }
        
        ///4
        self.view.addSubview(txtUserName)
        self.view.addSubview(txtPassword)
        self.view.addSubview(btnSubmit)
        
        ///5
        //startObserverPoll()
        
        ///6
        let dict: Dictionary<String, Any> = [
            "job_information": [
                "title": "iOS Developer",
                "salary": NSNull()
            ],
            "firstname": "John",
            "lastname": "Doe",
            "age": 20
        ]
        Login.shared.save(user: dict.toData())
        if Login.shared.isUserLogin() == true {
            print("<<<<<<<<<<<<<<<<<<<")
            print(Login.shared.user?.firstName ?? "")
            print(Login.shared.user?.job?.title ?? "")
            if var person = Login.shared.user {
                person.firstName = "XYZ"
                person.job = nil
                Login.shared.update(user: person)
                print(">>>>>>>>>>>>>>>>>>>")
                print(Login.shared.user?.firstName ?? "")
                print(Login.shared.user?.job?.title ?? "nil")
            }
            
        }
    }
    
    deinit {
        print("deinit")
        timer?.suspend()
        timer = nil
    }

    //MARK:- Action Methods
    
    @objc func actSubmit(sender: UIButton) {
        if timer != nil {
            timer?.suspend()
            timer = nil
        }
        
        
        guard let vc = Storyboard.chat.viewController(viewControllerClass: CBMessageListVC.self) else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Lazy Initializers
    
    func validation() -> Bool {
        if txtUserName.textField.text?.isEmpty == true {
            txtUserName.textField.errorMessage = "\(txtUserName.placeholder ?? "") \(L10n.isRequired.string)"
            return false
        }
        if txtPassword.textField.text?.isEmpty == true {
            txtPassword.textField.errorMessage = "\(txtPassword.placeholder ?? "") \(L10n.isRequired.string)"
            return false
        }
        return true
    }
    
    lazy var txtUserName: ASFormFieldView = {
        let txtF = ASFormFieldView.init(frame: fieldFrame)
        txtF.placeholder = "Username"
        return txtF
    }()
    
    lazy var txtPassword: ASFormFieldView = {
        let txtF = ASFormFieldView.init(frame: fieldFrame)
        txtF.frame.origin.y = txtUserName.frame.maxY + fieldMargin
        txtF.placeholder = "Password"
        return txtF
    }()
    
    lazy var btnSubmit: ASButton = {
        let btn = ASButton.init(frame: CGRect.init(x: Screen.centerW-(170/2), y: txtPassword.frame.maxY + fieldMargin + 5, width: 170, height: self.fieldHeight-5))
        btn.setTitle("SUBMIT", for: .normal)
        btn.titleLabel?.font = Font.formButtons
        btn.cornerRadius = (self.fieldHeight-5)/2
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = Color.darkBackground.value
        btn.showsTouchWhenHighlighted = true
        btn.addTarget(self, action: #selector(actSubmit(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let fieldHeight: CGFloat = 55.0
    let fieldMargin: CGFloat = 10.0
    
    lazy var fieldFrame: CGRect = {
        return CGRect.init(x: 25, y: fieldMargin, width: Screen.width-50, height: self.fieldHeight)
    }()
}

extension ViewController {
    func startObserverPoll() {
        weak var controller = self
        timer = RepeatingTimer.init(timeInterval: .seconds(1))
        timer?.eventHandler = {
            print("Timer Fired")
            autoreleasepool(invoking: {
                UserLogin.pollUserUpdates(with: [:], controller: controller, completion: { isSuccess in
                    print(isSuccess)
                })
            })

        }
        timer?.resume()
    }
}
