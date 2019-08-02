//
//  CBGroupChatVC+Helpers.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import AVFoundation
import MobileCoreServices

//MARK:- ATTACHMENTS
extension CBGroupChatVC {
    
    /// Show the attachment picker option
    ///
    /// - Parameter completion: MediaModal?
    func showSelectionPopUP() {
        weak var weakSelf = self
        guard let appName = Bundle.main.displayName else { return }
        
        openActionSheet(title: nil, message: nil, with: ["From Gallery", "From \(appName)"]) { (index) in
            guard let index = index else { return }
            if index == 0 {
                weakSelf?.openActionSheet(title: nil, message: nil, with: ["Take a new image", "Choose existing image","Take a new video", "Choose existing video"], didSelect: { (option) in
                    guard let option = option else { return }
                    switch option {
                    case 0:///Take a new image
                        weakSelf?.captureCameraImage()
                    case 1:///Choose existing image
                        weakSelf?.chooseExistingImage()
                    case 2:///Take a new video
                        break
                    case 3:///Choose existing video
                        break
                    default:
                        break
                    }
                })
            }
        }
    }
    
    /// Capture the image from camera
    func captureCameraImage() {
        weak var weakSelf = self
        CameraImage.shared.captureImage(from: self, captureOptions: [.camera], allowEditting: true, fileTypes: [.image]) { (image, _) in
            guard let image = image else {
                return
            }
            let file = MediaModal.init(url: "", fileType: .mediaImage, image: image)
            kMainQueue.asyncAfter(deadline: .now() + 0.1) {
                weakSelf?.sendMediaMessage(files: [file], messageType: .mediaImage)
            }
        }
    }
    
    /// Choose Image from photo library
    func chooseExistingImage() {
        weak var weakSelf = self
        CameraImage.shared.captureImage(from: self, captureOptions: [.photoLibrary], allowEditting: true, fileTypes: [.image]) { (image, _) in
            guard let image = image else {
                return
            }
            let file = MediaModal.init(url: "", fileType: .mediaImage, image: image)
            kMainQueue.asyncAfter(deadline: .now() + 0.1) {
                weakSelf?.sendMediaMessage(files: [file], messageType: .mediaImage)
            }
        }
    }
}


