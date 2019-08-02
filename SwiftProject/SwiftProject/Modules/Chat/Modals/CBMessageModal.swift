//
//  CBMessageModal.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

enum CBChatType {
    static let group = "CB_Group_Chat"
    static let oneOne = "CB_One_One_Chat"
}

enum MessageType: String {
    case event = "event"
    case text = "text"
    case mediaImage = "media_image"
    case mediaVideo = "media_video"
    case mediaAudio = "media_audio"
    
    var val: String {
        return self.rawValue
    }
}

struct Message {
    var id: Int
    var senderId: Int
    var receiverIds: [Int]
    var name: String
    var picture: String
    var groupId: String
    var chatType: String
    var msgText: String
    var msgDate: String
    var type: MessageType
    var files: [MediaModal]
    
    init(dict: Dictionary<String, Any>) {
        
        self.id = dict["id"] as? Int ?? 0
        self.senderId = dict["senderId"] as? Int ?? 0
        self.receiverIds = dict["receiverIDs"] as? [Int] ?? []
        self.name = dict["senderName"] as? String ?? ""
        self.picture = (dict["senderPic"] as? String ?? "").decoding().encoding()
        self.groupId = dict["groupId"] as? String ?? ""
        self.chatType = dict["chatType"] as? String ?? ""
        self.msgText = dict["textMessage"] as? String ?? ""
        self.msgDate = dict["messageDateTime"] as? String ?? ""
        
        if let obj = dict["messageType"] as? String {
            self.type = MessageType.init(rawValue: obj) ?? .text
        } else {
            self.type = .text
        }
        
        var arrImages: [MediaModal] = []
        
        if let images = dict["images"] as? [String] {
            for item in images {
                let file = MediaModal.init(url: item, fileType: .mediaImage)
                arrImages.append(file)
            }
        }
        
        if let images = dict["videos"] as? [String] {
            for item in images {
                let file = MediaModal.init(url: item, fileType: .mediaVideo)
                arrImages.append(file)
            }
        }
        
        if let images = dict["audios"] as? [String] {
            for item in images {
                let file = MediaModal.init(url: item, fileType: .mediaAudio)
                arrImages.append(file)
            }
        }
        self.files = arrImages
    }
}

struct MessageDateSection {
    var msgDate: String
    var rows: [Message]
    
    init(date: String, message: [Message]) {
        self.msgDate = date
        self.rows = message
    }
}

//MARK:- MEDIA MODALS
struct MediaModal {
    var url: String
    var fileType: MessageType
    var image: UIImage?
    
    init(url: String, fileType: MessageType, image: UIImage? = nil) {
        self.url = url
        self.fileType = fileType
        self.image = image
    }
}
