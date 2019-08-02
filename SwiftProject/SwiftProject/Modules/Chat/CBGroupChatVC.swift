//
//  CBGroupChatVC.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GrowingTextView

class CBGroupChatVC: ASBaseVC {

    enum ScreenFrom {
        case message
        case rightMenu
    }
    var kScreenFrom: ScreenFrom = .message
    var arrDateMessages: [MessageDateSection] = []
    var arrReceiverIds: [Int] = [4, 2, 3, 5]
    var groupId: String = "--XYZ--"
    let senderId: Int = 0
    ///
    //MARK:- Outlets
    ///
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var uvChatFooter: UIView!
    @IBOutlet weak var txtVmsg: GrowingTextView!
    @IBOutlet weak var uvFooterBottomConstraint: NSLayoutConstraint!
    
    //MARK:- LAZY INIT
    
    lazy var btnName: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 30))
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.numberOfLines = 0
//        btn.setImage(#imageLiteral(resourceName: "group_circle"), for: .normal)
        //btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(actGroupDetail(sender:)), for: .touchUpInside)
        return btn
    }()
    
    //MARK:- View CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///
        ///Nav Bar
        ///
        if kScreenFrom == .rightMenu {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationItem.hidesBackButton = true
        }
        
        self.navigationController?.navigationBar.setColors(background: UIColor.fbColor, text: .white)
        navBarButtons(left: #imageLiteral(resourceName: "back_arrow"), right: nil, shouldBack: false)
        
        btnLeftMenu.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let item1 = UIBarButtonItem.init(customView: btnLeftMenu)
        let item2 = UIBarButtonItem.init(customView: btnName)
        self.navigationItem.setLeftBarButtonItems([item1, item2], animated: true)
        
        ///
        ///SETUP UI
        ///
        setupUI()
        
        ///
        ///Add Notification observer
        ///
        addNotifications()
        
        ///
        ///Load history
        ///
        loadHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CBGroupChatVC viewWillAppear")
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    //MARK:- UI
    
    @objc func setupFriendNameStatus() {
        let status = ""//"\nOnline"
        
        let attString = "ConetBook".attributtedString(appendString: status, color1: .white, color2: .white, font1: UIFont.systemFont(ofSize: 14.0, weight: .regular), font2: UIFont.systemFont(ofSize: 11.0, weight: .regular), lineSpacing: 2.0)
        btnName.setAttributedTitle(attString, for: .normal)
    }
    
    func setupUI() {
        // *** Setup Other user Name and online status ***
        setupFriendNameStatus()
        
        txtVmsg.delegate = self
        
        // *** Listen to keyboard show / hide ***
        DefaultCenter.notification.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    //MARK:- De-Init
    deinit {
        print("deinit")
        releaseMemory()
    }
    
    /// Release any strong memory
    func releaseMemory() {
        DefaultCenter.notification.removeObserver(self)
        DefaultCenter.notification.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        txtVmsg.delegate = nil
    }
    
    //MARK:- ACTION METHODS
    
    /// Send Attachment pressed
    @IBAction func actAttchment(_ sender: UIButton) {
        showSelectionPopUP()
    }
    
    /// Send message pressed
    @IBAction func actSendMessage(_ sender: UIButton) {
        let strMsg = txtVmsg.text ?? ""
        if strMsg.isEmpty == true {
            return
        }
        txtVmsg.text = ""
        
        let msg = createMessage(msg: strMsg, messageType: .text)
        let signal = createSignal(message: msg)
        
        sendMessage(request: signal)
        
        showNewMessage(msg: msg)
    }
    
    /// back button pressed
    override func navLeftClicked(sender: UIButton) {
        if kScreenFrom == .rightMenu {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        releaseMemory()
        self.goBack()
    }
    
    /// Show group detail page
    ///
    /// - Parameter sender: UIButton
    @objc func actGroupDetail(sender: UIButton) {
        guard let vc = Storyboard.group.viewController(viewControllerClass: CBGroupDetailVC.self) else {return}
        vc.kScreenType = .groupDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /// Keyboard frame changed
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            uvFooterBottomConstraint.constant = -(keyboardHeight)//8
            view.layoutIfNeeded()
            kMainQueue.asyncAfter(deadline: .now() + 0.1, execute: {
                self.tblMain.scrollToBottom()
            })
        }
    }
    
}

// MARK: - GrowingTextViewDelegate
extension CBGroupChatVC: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

//
//MARK:- Notification Handling
//
extension CBGroupChatVC {
    func addNotifications() {
        
    }
    
    @objc func signalReceived(sender: Notification) {
        if let userInfo = sender.userInfo as? Dictionary<String, Any>, userInfo.isEmpty == false {
            print(userInfo)
            guard let type = userInfo["TYPE"] as? String, let signal = userInfo["SIGNAL"] as? String else {
                print("guard TYPE - SIGNAL failed")
                return
            }
            receivedTBSignal(type: type, data: signal)
        }
        
    }
}
