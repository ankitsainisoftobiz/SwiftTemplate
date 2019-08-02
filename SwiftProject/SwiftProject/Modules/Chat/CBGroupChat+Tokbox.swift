//
//  CBGroupChat+Tokbox.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

//MARK:- SIGNALS
extension CBGroupChatVC {
    /// Received Tokbox signal
    ///
    /// - Parameters:
    ///   - type: String
    ///   - data: String
    func receivedTBSignal(type: String, data: String) {
        if type == CBChatType.group {
            let signal = data.toDictionary()
            if signal.isEmpty == true {
                print("signal is empty")
                return
            }
            guard let dict = signal["data"] as? Dictionary<String, Any> else {
                return
            }
            let msg = Message.init(dict: dict)
            ///
            ///Check the sender of the message
            if msg.senderId == senderId {
                print("Message sent by me")
                return
            }
            
            ///
            ///Check if the message is for me or not.
            if msg.receiverIds.contains(senderId) == false {
                print("Message sender id : \(msg.senderId)")
                print("Message sended to: \(msg.receiverIds)")
                print("Logged in user \(senderId)")
                print("Message is not for me")
                return
            }
            
            if msg.groupId != groupId {
                print("Message not for current group")
                return
            }
            showNewMessage(msg: msg)
        }
    }
}

//MARK:- MESSAGES
extension CBGroupChatVC {
    
    /// Send media message
    ///
    /// - Parameter files: [MediaModal]
    ///   - messageType: MessageType
    func sendMediaMessage(files: [MediaModal], messageType: MessageType) {
        
        var msg = createMessage(msg: "", messageType: messageType)
        msg.files = files
        
        let signal = createSignal(message: msg)
        
        sendMessage(request: signal)
        showNewMessage(msg: msg)
    }
    
    /// Send message signal in tokbox session
    ///
    /// - Parameter request: Dictionary<String, Any>
    func sendMessage(request: Dictionary<String, Any>) {
        print(">>>>>>>>>>>>>> SIGNAL SENT>>>>>>>>>>>>>>>>>>>")
        print(request.toString())
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
        //FIXME:- ADD SEND METHOD HERE
//        guard let session = SessionConnect.sessionConnectCommunicator() else { return }
//        session.sendDefaultSignal(CBChatType.group, string: request.toString())
    }
    
    /// Create Tokbox signal data from message
    ///
    /// - Parameter message: Message
    /// - Returns: Dictionary<String, Any>
    func createSignal(message: Message) -> Dictionary<String, Any> {
        let arrImg = message.files.filter({$0.fileType.val == MessageType.mediaImage.val})
        let images = arrImg.map({$0.url})
        
        let arrVideo = message.files.filter({$0.fileType.val == MessageType.mediaVideo.val})
        let videos = arrVideo.map({$0.url})
        
        let arrAudio = message.files.filter({$0.fileType.val == MessageType.mediaAudio.val})
        let audios = arrAudio.map({$0.url})
        
        ///
        /// Create signal request to send message
        ///
        let request: Dictionary<String, Any> = ["data": [
            "senderId": message.senderId,
            "receiverIDs": message.receiverIds,
            "senderName": message.name,
            "senderPic": message.picture,
            "groupId": message.groupId,
            "chatType": message.chatType,
            "textMessage": message.msgText,
            "messageDateTime": message.msgDate, ///"yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
            "messageType": message.type.val,
            "images": images,
            "videos": videos,
            "audios": audios
            ]]
        
        return request
    }
    
    /// Create Message object to send message
    ///
    /// - Parameter msg: String
    /// - Returns: Message
    func createMessage(msg: String, messageType: MessageType) -> Message {
        ///
        /// Create message request to send message
        ///
        let msg = Message.init(dict: [
            "senderId": senderId,
            "receiverIDs": arrReceiverIds,
            "senderName": "JOHN",
            "senderPic": "",
            "groupId": groupId,
            "chatType": CBChatType.group,
            "textMessage": msg,
            "messageDateTime": Date().toString(format: .isoDateTimeMilliSec), ///"yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
            "messageType": messageType.val,
            "images": [],
            "videos": [],
            "audios": []
            ])
        
        return msg
    }
}
