//
//  CameraImage.swift
//  Ankit_Saini
//
//  Created by Ankit Saini on 11/13/17.
//  Copyright © 2017 Ankit_Saini. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import MobileCoreServices


/// Media Types
enum MediaType {
    /// Image
    case image
    
    /// Video
    case video
    
    /// String value
    var string: String {
        switch self {
        case .image:
            return kUTTypeImage as String
            
        case .video:
            return kUTTypeMovie as String
        }
    }
}



/// This class will be used to show media picker to user.
class CameraImage: NSObject {
    
    /// Shared instance
    static var shared = CameraImage()
    
    /// Caller view controller
    var fromVC: UIViewController?
    
    /// Completion handler for the class.
    var complete:((_ image: UIImage?, _ url: URL?) -> Void)?
    
    /// Base Path of document directory to store videos.
    var dictionaryPath: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        guard let documentsDirectory = paths.firstObject as? String else { return "" }
        return documentsDirectory
    }
    
    /// This function is used to show whether the permission for capturing is granted or not.
    ///
    /// - Returns: This will return true if permission granted else return false.
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
    
    /// Open System settings to update permissions
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
    
    /// This will be used to capture images.
    ///
    /// - Parameters:
    ///   - vc: Caller viewController
    ///   - sources: Source array
    ///   - crop: allow croping or not
    ///   - fileTypes: Type of media to be picked
    ///   - callBack: callback handler.
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
    
    /// Open actionsheet to ask to select source.
    ///
    /// - Parameters:
    ///   - imagePicker: Image picker instance
    ///   - sources: Options array
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
    
    /// Open image picker with options.
    ///
    /// - Parameters:
    ///   - from: UIViewController
    ///   - source: UIImagePickerController.SourceType
    ///   - mediaType: String
    ///   - callBack: (_ image: UIImage?, _ url: URL?)
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
    
    /// If device has camera or not
    var cameraExists: Bool {
        let front = UIImagePickerController.isCameraDeviceAvailable(.front)
        let rear = UIImagePickerController.isCameraDeviceAvailable(.rear)
        return front || rear
    }
    
    /// User canceled the image picker options.
    ///
    /// - Parameter picker: UIImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        guard let callBack = complete else {
            fromVC?.dismiss(animated: true, completion: nil)
            return
        }
        callBack(nil, nil)
        fromVC?.dismiss(animated: true, completion: nil)
    }
    
    /// User finished with the image picker.
    ///
    /// - Parameters:
    ///   - picker: UIImagePickerController
    ///   - info: [UIImagePickerController.InfoKey: Any]
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
    }
}

extension UIImagePickerController.SourceType {
    
    /// Name of the option
    var name: String {
        
        switch self {
        case .camera:
            return L10n.camera.string
            
        case .photoLibrary:
            return L10n.photoLibrary.string
            
        case .savedPhotosAlbum:
            return L10n.savedPhotoAlbum.string
            
        @unknown default:
            return L10n.photoLibrary.string
        }
    }
}

extension CameraImage {
    
    /// Compress the video
    ///
    /// - Parameters:
    ///   - fromUrl: URL
    ///   - url: To which URL
    ///   - completionHandler: (_ exportSession: AVAssetExportSession)
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
    
    
    /// Get url of the video from the file url.
    ///
    /// - Parameter url: file URL
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

