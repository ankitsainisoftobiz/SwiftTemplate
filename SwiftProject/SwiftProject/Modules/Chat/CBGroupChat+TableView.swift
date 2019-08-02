//
//  CBGroupChat+TableView.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

//
// MARK:- TableView Datasource
//MARK:
extension CBGroupChatVC: UITableViewDataSource {
    
    /// Reporting the number of sections
    ///
    /// - Parameter tableView: UITableView
    /// - Returns: Int
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrDateMessages.count
    }
    
    /// Reporting the number of sections and rows in the table.
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDateMessages[section].rows.count
    }
    
    /// Providing cells for each row of the table.
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = arrDateMessages[indexPath.section].rows[indexPath.row]
        
        //MARK:- EVENT CELL
        if message.type == .event {
            let identifier = "ASChatEventCell"
            
            var cell: ASChatEventCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ASChatEventCell
            if cell == nil {
                tableView.register(UINib(nibName: "ASChatEventCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ASChatEventCell
            }
            
            cell.lblEvent.text = message.msgText
            
            tableView.separatorStyle = .none
            cell.selectionStyle = .none
            
            return cell!
            
        } else if message.type == .mediaImage || message.type == .mediaVideo || message.type == .mediaAudio {
            //MARK:- MEDIA CELL
            
            let identifier = "ASChatImageCell"
            
            var cell: ASChatImageCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ASChatImageCell
            if cell == nil {
                tableView.register(UINib(nibName: "ASChatImageCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ASChatImageCell
            }
            
            let isSender = message.senderId == 0 ? true : false
            let convertedDate = Date.init(fromString: message.msgDate, format: .isoDateTimeMilliSec)
            
            cell.lblMsg?.text = "\(message.msgText)"
            cell.lblTime?.text = convertedDate?.toString(format: .custom("hh:mm a"))
            
            ///
            ///configure views
            ///
            cell.configureViewsColors(isSender: isSender)
            ///
            ///Pass files
            cell.addImages(images: message.files)
            
            
            tableView.separatorStyle = .none
            cell.selectionStyle = .none
            
            return cell!
            
        } else {
            
            //MARK:- TEXT CELL
            
            let identifier = "ASChatCell"
            
            var cell: ASChatCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ASChatCell
            if cell == nil {
                tableView.register(UINib(nibName: "ASChatCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ASChatCell
            }
            
            
            clearCell(message: message, cell: cell)
            
            let convertedDate = Date.init(fromString: message.msgDate, format: .isoDateTimeMilliSec)
            
            if message.senderId == 0 { //sender
                
                cell.uvSenderView.isHidden = false
                cell.uvReceiverView.isHidden = true
                
                cell.lblMSGSender.text = "\(message.msgText)"
                cell.lblDateSender.text = convertedDate?.toString(format: .custom("hh:mm a"))
                
            } else { //receiver
                cell.uvSenderView.isHidden = true
                cell.uvReceiverView.isHidden = false
                
                cell.lblReceiverName.text = message.name.capitalized
                cell.lblMsgReceiver.text = "\(message.msgText)"
                cell.lblDateReceiver.text = convertedDate?.toString(format: .custom("hh:mm a"))
            }
            
            tableView.separatorStyle = .none
            cell.selectionStyle = .none
            
            return cell!
        }
        
    }
    
    /// viewForHeaderInSection
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: UIView?
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let uvDateSection = UIView()
        uvDateSection.backgroundColor = .clear
        
        ///
        ///Create Lable
        let lblDateSection1 = UILabel()
        uvDateSection.addSubview(lblDateSection1)
        lblDateSection1.centerEdgesToSuperview(width: 130, height: 30, toView: uvDateSection)
        lblDateSection1.layer.cornerRadius = 6.0
        lblDateSection1.layer.masksToBounds = true
        
        lblDateSection1.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        lblDateSection1.textAlignment = .center
        lblDateSection1.textColor = .black
        lblDateSection1.backgroundColor = .chatSection
        
        let date = arrDateMessages[section].msgDate
        let orizinalDate = Date.init(fromString: date, format: .custom("yyyy-MM-dd"))
        if orizinalDate != nil {
            lblDateSection1.text = orizinalDate?.toString(format: .custom("MM/dd/yyyy"))
            
        } else {
            lblDateSection1.text = date
        }
        return uvDateSection
    }
    
    /// viewForFooterInSection
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: UIView?
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    /// Clear messages from cell
    ///
    /// - Parameters:
    ///   - message: Message
    ///   - cell: ASChatCell
    func clearCell(message: Message, cell: ASChatCell) {
        
        cell.lblMsgReceiver.text = ""
        cell.lblMSGSender.text = ""
        cell.lblDateSender.text = ""
        cell.lblDateReceiver.text = ""
        cell.lblReceiverName.text = ""
    }
}

//MARK:- UITableViewDelegate
extension CBGroupChatVC: UITableViewDelegate {
    
    /// heightForRowAt indexPath
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: CGFloat
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// heightForHeaderInSection
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: CGFloat
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    /// heightForFooterInSection
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: CGFloat
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
