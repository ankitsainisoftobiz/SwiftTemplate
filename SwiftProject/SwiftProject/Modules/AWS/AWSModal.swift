//
//  AWSModal.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
/*
struct AWSModal {
    
    /// This function is used to check if AWS Key are available.
    ///
    /// - Parameters:
    ///   - showLoader: Bool => Need to show the loader or not.
    ///   - internetToast: Bool => Need to show the internet connectivity toast or not.
    ///   - completion: Bool = true/false.
    static func getAWSDetails(showLoader: Bool = false, internetToast: Bool = false, completion:@escaping (_ status: Bool) -> Void) {
        
        if Singleton.shared.awsExpiration.isEmpty == false,
            Singleton.shared.awsAccessKeyId.isEmpty == false,
            Singleton.shared.awsSessionToken.isEmpty == false,
            Singleton.shared.awsSecretAccessKey.isEmpty == false,
            Singleton.shared.awsBucketName.isEmpty == false {
            
            if AWSModal.isAWSS3KeysValid() == true {
                completion(true)
                return
            }
        }
        
        AWSModal.getAWSKeysAPI(showLoader: showLoader, internetToast: internetToast) { (_) in
            if Singleton.shared.awsExpiration.isEmpty == false,
                Singleton.shared.awsAccessKeyId.isEmpty == false,
                Singleton.shared.awsSessionToken.isEmpty == false,
                Singleton.shared.awsSecretAccessKey.isEmpty == false,
                Singleton.shared.awsBucketName.isEmpty == false {
                
                if AWSModal.isAWSS3KeysValid() == true {
                    completion(true)
                    return
                }
            }
            completion(false)
            return
        }
    }
    
    /// Check if the AWS Crendentials are expired or not.
    ///
    /// - Returns: Bool
    static func isAWSS3KeysValid() -> Bool {
        let expiry = Singleton.shared.awsExpiration
        guard let dateExpiry = Date.init(fromString: expiry, format: .isoDateTimeSec) else {
            return false
        }
        let time = dateExpiry.difference(from: Date())
        print(time)
        if time.totalSeconds > 0 {
            return true
        }
        return false
    }
    
    /// This function is used to get all the access keys related to AWS.
    ///
    /// - Parameters:
    ///   - showLoader: Bool => Need to show the loader or not.
    ///   - internetToast: Bool => Need to show the internet connectivity toast or not.
    ///   - completion: status: Bool = true/false.
    static func getAWSKeysAPI(showLoader: Bool = false, internetToast: Bool = false, completion:@escaping (_ status: Bool) -> Void) {
        if kAppDelegate.checkInternet(with: internetToast) == false {
            completion(false)
            return
        }
        
        if showLoader == true {
            kAppDelegate.showLoader()
        }
        
        BackgroundQueue.awsDetail.async {
            let response = ASDataModal.shared.requestPostDataApi(with: "URL FOR API", parameters: [:], extraHeader: ["Authorization": ""])
            
            print(response.validatedData)
            if showLoader == true {
                kMainQueue.async {
                    kAppDelegate.hideLoader()
                }
            }
            
            if response.isSuccess == true {
                guard let accessKeyId = response.validatedData["AccessKeyId"] as? String, let expiration = response.validatedData["Expiration"] as? String, let secretAccessKey = response.validatedData["SecretAccessKey"] as? String, let sessionToken = response.validatedData["SessionToken"] as? String, let bucketName = response.validatedData["bucket-name"] as? String else {
                    
                    completion(false)
                    return
                }
                let folder = response.validatedData["folder"] as? String ?? ""
                
                Singleton.shared.awsExpiration = expiration
                Singleton.shared.awsAccessKeyId = accessKeyId
                Singleton.shared.awsSessionToken = sessionToken
                Singleton.shared.awsSecretAccessKey = secretAccessKey
                Singleton.shared.awsBucketName = bucketName
                Singleton.shared.awsBucketFolderName = folder
                completion(true)
                return
            }
            completion(false)
            return
        }
    }
}
*/
