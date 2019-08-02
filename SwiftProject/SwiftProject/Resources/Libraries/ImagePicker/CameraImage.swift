//
//  CameraImage.swift
//  Ankit_Saini
//
//  Created by softobiz on 11/13/17.
//  Copyright © 2017 Ankit_Saini. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import MobileCoreServices


enum MediaType {
    case image
    case video
    
    var string: String {
        switch self {
        case .image:
            return kUTTypeImage as String
            
        case .video:
            return kUTTypeMovie as String
        }
    }
}



class CameraImage: NSObject {
    
    static var shared = CameraImage()
    var fromVC: UIViewController?
    var complete:((_ image: UIImage?, _ url: URL?) -> Void)?
    
    var dictionaryPath: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        guard let documentsDirectory = paths.firstObject as? String else { return "" }
        return documentsDirectory
    }
    
    func cameraNotPermitted() -> Bool {
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status {
        case .authorized:
            return false
        case .denied, .restricted:
            openSettings()
        case .notDetermined:
            return false
        @unknown default:
            break
        }
        return true
    }
    
    fileprivate func openSettings() {
        
        openAlert(title: "", message: L10n.youHaveDeniedThePermissionToAccessCamera.string, with: [L10n.settings.string]) { (index) in
            
            if index == 0 {//Press setting option.
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } else {
                    // -- Add open Settings for lower versions
                }
            }
        }
    }
    
    func captureImage(from vc: UIViewController, captureOptions sources: [UIImagePickerController.SourceType], allowEditting crop: Bool, fileTypes: [MediaType], callBack: ((_ image: UIImage?, _ url: URL?) -> Void)?) {
        
        if cameraNotPermitted() {
            return
        }
        
        self.fromVC = vc
        self.complete = callBack
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let mediaTypes = fileTypes.map({ ($0.string) })
        imagePicker.mediaTypes = mediaTypes
        imagePicker.allowsEditing = crop
        
        if sources.count > 1 {
            openActionSheet(with: imagePicker, sources: sources)
        } else {
            let source = sources[0]
            if source == .camera && cameraExists {
                imagePicker.sourceType = source
            }
            vc.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openActionSheet(with imagePicker: UIImagePickerController, sources: [UIImagePickerController.SourceType]) {
        
        let actionSheet = UIAlertController(title: L10n.selectSource.string, message: nil, preferredStyle: .actionSheet)
        for source in sources {
            let action = UIAlertAction(title: source.name, style: .default, handler: { (_) in
                imagePicker.sourceType = source
                self.fromVC?.present(imagePicker, animated: true, completion: nil)
            })
            if source == .camera {
                if cameraExists { actionSheet.addAction(action) }
            } else {
                actionSheet.addAction(action)
            }
        }
        let cancel = UIAlertAction(title: L10n.cancel.string, style: .cancel) { (_) in
        }
        actionSheet.addAction(cancel)
        if Screen.isIPAD == true {
            actionSheet.popoverPresentationController?.sourceView = fromVC?.view
            actionSheet.popoverPresentationController?.permittedArrowDirections = []
            actionSheet.popoverPresentationController?.sourceRect = CGRect.init(x: Screen.centerW, y: Screen.height, width: 0, height: 0)
        }
        fromVC?.present(actionSheet, animated: true, completion: nil)
    }
}




extension CameraImage {
    
    func openOptions(from: UIViewController, source: UIImagePickerController.SourceType, of mediaType: String, callBack: ((_ image: UIImage?, _ url: URL?) -> Void)?) {
        
        let imagePicker = UIImagePickerController()
        if source == .camera {
            if cameraExists { imagePicker.sourceType = source }
        } else {
            imagePicker.sourceType = source
        }
        imagePicker.delegate = self
        imagePicker.mediaTypes = [mediaType]
        self.complete = callBack
        self.fromVC = from
        fromVC?.present(imagePicker, animated: true, completion: nil)
    }
}


extension CameraImage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var cameraExists: Bool {
        let front = UIImagePickerController.isCameraDeviceAvailable(.front)
        let rear = UIImagePickerController.isCameraDeviceAvailable(.rear)
        return front || rear
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        guard let callBack = complete else {
            fromVC?.dismiss(animated: true, completion: nil)
            releaseMemory()
            return
        }
        callBack(nil, nil)
        fromVC?.dismiss(animated: true, completion: nil)
        releaseMemory()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var image: UIImage?
        var url: URL?
        
        if  let imgUrl = info[.referenceURL] as? URL {
            url = imgUrl
        }
        
        //Get file by checking its file type
        guard let mediaType = info[.mediaType] as? String else {
            fromVC?.dismiss(animated: true, completion: nil)
            releaseMemory()
            return
            
        }
        if mediaType == MediaType.image.string {
            if let edittedImage = info[.editedImage] as? UIImage {
                image = edittedImage
            } else if let fullImage = info[.originalImage] as? UIImage {
                image = fullImage
            }
            
            if let complete = complete {
                complete(image, url)
            }
        } else if mediaType == MediaType.video.string {
            if let videoURL = info[.mediaURL] as? URL {
                getUrlFromVideoFile(url: videoURL)
            }
        }
        fromVC?.dismiss(animated: true, completion: nil)
        releaseMemory()
    }
    
    /// Release parent controllers and memory
    func releaseMemory() {
        autoreleasepool(invoking: {
            fromVC = nil
        })
    }
}

extension UIImagePickerController.SourceType {
    
    var name: String {
        
        switch self {
        case .camera:
            return L10n.camera.string
            
        case .photoLibrary:
            return L10n.photoLibrary.string
            
        case .savedPhotosAlbum:
            return L10n.savedPhotoAlbum.string
            
        @unknown default:
            return ""
        }
    }
}

extension CameraImage {
    
    func compressVideoFromInputUrl(_ fromUrl: URL, toUrl url: URL, completionHandler: @escaping ((_ exportSession: AVAssetExportSession) -> Void)) {
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("error in removing file at path \(url)")
        }
        let asset: AVURLAsset = AVURLAsset(url: fromUrl)
        let exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exportSession?.outputURL = url
        exportSession?.outputFileType = AVFileType.mov
        exportSession?.exportAsynchronously(completionHandler: {
            completionHandler(exportSession!)
        })
    }
    
    
    func getUrlFromVideoFile(url: URL) {
        
        let documentPath = self.dictionaryPath.appendingFormat("/%@", "video.mp4")
        let toUrl = URL(fileURLWithPath: documentPath)
        
        compressVideoFromInputUrl(url, toUrl: toUrl) { (_) in
            if let complete = self.complete {
                print(toUrl)
                complete(nil, toUrl)
            }
        }
    }
    
}

