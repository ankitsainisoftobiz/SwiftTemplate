//
//  ASS3Upload.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
/*
import AWSS3
import AWSCore

/// This class is responsible to upload any file over S3 bucket on AWS.
class ASS3Upload {
    
    /// This function is used to authorize user with AWS.
    private static func connectWithAWS() -> AWSServiceConfiguration? {
        
        /// Simple session credentials with keys and session token.
        let credentialsProvider = AWSBasicSessionCredentialsProvider.init(accessKey: Singleton.shared.awsAccessKeyId, secretKey: Singleton.shared.awsSecretAccessKey, sessionToken: Singleton.shared.awsSessionToken)
        
        /// A service configuration object.
        guard let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider) else {
            return nil
        }
        
//        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        return configuration
    }
    
    /// upload a file to AWS S3 bucket.
    ///
    /// - Parameters:
    ///   - file: AWSS3File Modal of inputs
    ///   - completion: success: Bool, _ url: String, _ err: String
    static func uploadFileToS3(file: AWSS3File, completion:@escaping (_ response: AWSS3Response?) -> Void) {
        
        /// Get configurations for bucket
        guard let configuration = ASS3Upload.connectWithAWS() else {
            kMainQueue.async {
                kAppDelegate.hideLoader()
                ASUtility.shared.showToast(with: "AWSServiceConfiguration Not Initialised.", completion: {})
                completion(nil)
            }
            return
        }
        
        ///Check if a AWSS3TransferUtility already exist for current access key or not.
        let trans = AWSS3TransferUtility.s3TransferUtility(forKey: Singleton.shared.awsAccessKeyId)
        
        if trans == nil {
            /// If AWSS3TransferUtility is nil than create new for a access id
            ///
            AWSS3TransferUtility.register(with: configuration, transferUtilityConfiguration: nil, forKey: Singleton.shared.awsAccessKeyId) { (err) in
                print("Error in AWSS3TransferUtility.register: ->>> \(err?.localizedDescription ?? "")")
            }
        }

        ///
        /// Check if a AWSS3TransferUtility already exist for current access key or not.
        guard let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: Singleton.shared.awsAccessKeyId) else {
            kMainQueue.async {
                kAppDelegate.hideLoader()
                ASUtility.shared.showToast(with: "AWSS3TransferUtility Not Initialised.", completion: {})
                completion(nil)
            }
            return
        }
        
        ///
        /// Start Uploading process
        ///
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")
        
        let s3BucketName = file.bucketName
        
        let url = URL.init(fileURLWithPath: file.fileURL)
        
        transferUtility.uploadFile(url, bucket: s3BucketName, key: file.fileName, contentType: file.contentType, expression: expression) { (task, error) in
            kMainQueue.async {
                if error != nil {
                    print("Upload failed ❌ (\(error!))")
                    completion(AWSS3Response.init(success: false, url: "", err: "Upload failed ❌ (\(error!.localizedDescription))", fileName: file.fileName))
                    return
                }
                if task.status == AWSS3TransferUtilityTransferStatusType.completed {
                    let s3URL = "https://\(s3BucketName).s3.amazonaws.com/\(task.key)"
                    print("Uploaded to:\n\(s3URL)")
                    completion(AWSS3Response.init(success: true, url: s3URL, err: "", fileName: task.key))
                    return
                } else {
                    print("Not uploaded")
                }
            }
            
            }.continueWith { (task) -> Any? in
                if let error = task.error {
                    print("Upload failed ❌ (\(error))")
                    completion(AWSS3Response.init(success: false, url: "", err: "Upload failed ❌ (\(error.localizedDescription))", fileName: file.fileName))
                    return nil
                }
                
                if task.result != nil, task.isCompleted == true {
                    
                    let s3URL = "https://\(s3BucketName).s3.amazonaws.com/\(task.result!.key)"
                    print("Uploading Start of : \(s3URL)")
                    
                } else {
                    print("Unexpected empty result.")
                    
                }
                return nil
        }
    }
}

/// Modal to pass request in AWS Upload function
struct AWSS3File {
    var fileURL: String
    var fileName: String
    var ext: String
    var bucketName: String
    var contentType: String
}

/// Modal of aws s3 response
struct AWSS3Response {
    var success: Bool
    var url: String
    var err: String
    var fileName: String
}
*/
