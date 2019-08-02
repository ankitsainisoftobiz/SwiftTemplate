//
//  CBGroupChat+API.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//


import Foundation

//MARK:- CBGroupChatVC
extension CBGroupChatVC {
    
    /// Add and show new message in list
    ///
    /// - Parameter msg: Message
    func showNewMessage(msg: Message) {
        addNewMessage(message: msg)
        kMainQueue.async {
            self.tblMain.reloadData()
            self.tblMain.scrollToBottom()
        }
    }
    /// Add new message in list
    ///
    /// - Parameter message: Message
    func addNewMessage(message: Message) {
        let date = "\(message.msgDate)"
        let newDate = date.components(separatedBy: "T")
        if newDate.isEmpty == false {
            
            if arrDateMessages.contains(where: { $0.msgDate == newDate.first! }) == false { //date not exist add as new entry
                
                let list = MessageDateSection.init(date: newDate.first!, message: [message])
                arrDateMessages.append(list)
                
            } else { //date exist append in previous section
                
                let index = arrDateMessages.firstIndex(where: { (item) -> Bool in
                    item.msgDate == newDate.first!
                })
                
                if index != nil {
                    var allMessages = arrDateMessages[index!].rows
                    allMessages.append(message)
                    arrDateMessages[index!] = MessageDateSection.init(date: newDate.first!, message: allMessages)
                }
            }
        }
    }
    
    func loadHistory() {
        
        let row1 = Message.init(dict: [
            "senderId": 0,
            "receiverIDs": [1],
            "senderName": "JOHN",
            "senderPic": "",
            "groupId": groupId,
            "chatType": CBChatType.group,
            "textMessage": "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print. The passage is attributed to an unknown typesetter in the 15th century",
            "messageDateTime": "2019-07-30T19:20:30.45+01:00",
            "messageType": MessageType.text.val,
            "images": [],
            "videos": [],
            "audios": []
            ])
        
        let row2 = Message.init(dict: [
            "senderId": 1,
            "receiverIDs": [0],
            "senderName": "JOHN",
            "senderPic": "",
            "groupId": groupId,
            "chatType": CBChatType.group,
            "textMessage": "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print. The passage is attributed to an unknown typesetter in the 15th century",
            "messageDateTime": "2019-07-30T19:20:30.45+01:00",
            "messageType": MessageType.text.val,
            "images": [],
            "videos": [],
            "audios": []
            ])
        
        let row3 = Message.init(dict: [
            "senderId": 1,
            "receiverIDs": [0],
            "senderName": "JOHN",
            "senderPic": "",
            "groupId": groupId,
            "chatType": CBChatType.group,
            "textMessage": "You created this group",
            "messageDateTime": "2019-07-29T19:20:30.45+01:00",
            "messageType": MessageType.event.val,
            "images": [],
            "videos": [],
            "audios": []
            ])
        
        let row4 = Message.init(dict: [
            "senderId": 1,
            "receiverIDs": [0],
            "senderName": "JOHN",
            "senderPic": "",
            "groupId": groupId,
            "chatType": CBChatType.group,
            "textMessage": "You created this group",
            "messageDateTime": "2019-07-29T19:20:30.45+01:00",
            "messageType": MessageType.mediaImage.val,
            "images": ["https://placehold.jp/150x150.png", "https://placehold.jp/150x150.png", "https://placehold.jp/150x150.png", "https://placehold.jp/150x150.png", "https://placehold.jp/150x150.png"],
            "videos": [],
            "audios": []
            ])
        
        let row5 = Message.init(dict: [
            "senderId": 0,
            "receiverIDs": [1],
            "senderName": "JOHN",
            "senderPic": "",
            "groupId": groupId,
            "chatType": CBChatType.group,
            "textMessage": "You created this group",
            "messageDateTime": "2019-07-29T19:20:30.45+01:00",
            "messageType": MessageType.mediaImage.val,
            "images": ["https://placehold.jp/150x150.png"],
            "videos": [],
            "audios": []
            ])
        
        let row6 = Message.init(dict: [
            "senderId": 1,
            "receiverIDs": [0],
            "senderName": "JOHN",
            "senderPic": "",
            "groupId": groupId,
            "chatType": CBChatType.group,
            "textMessage": "You created this group",
            "messageDateTime": "2019-07-29T19:20:30.45+01:00",
            "messageType": MessageType.mediaImage.val,
            "images": ["https://placehold.jp/150x150.png", "https://placehold.jp/150x150.png", "https://placehold.jp/150x150.png", "https://placehold.jp/150x150.png"],
            "videos": [],
            "audios": []
            ])
        
        let md1 = MessageDateSection.init(date: "2019-07-30", message: [row1, row2, row1, row3, row2, row1, row5, row6, row4])
        let md2 = MessageDateSection.init(date: "2019-07-29", message: [row1, row2, row1, row1, row2, row1, row5, row6, row4])
        let md3 = MessageDateSection.init(date: "2019-07-27", message: [row1, row2, row4, row5, row3, row2, row1, row6, row2])
        let md4 = MessageDateSection.init(date: "2019-07-26", message: [row1, row2, row1, row1, row2, row3, row5, row6, row2])
        arrDateMessages = [md1, md2, md3, md4]
        tblMain.reloadData()
    }
}
