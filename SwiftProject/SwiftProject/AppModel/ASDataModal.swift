//
//  ASDataModal.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit

class ASDataModal: NSObject {

    let objUtil = ASUtility.shared
    
    static let shared = ASDataModal()
    
    //MARK:- POST REQUEST
    
    /// This function is used to hit api to server with parameters.
    ///
    /// - Parameters:
    ///   - url: Url string of the request.
    ///   - parameters: Parameters which is required to use the API.
    ///   - method: Http method for the APi.
    ///   - contentType: Content Type for the request.
    ///   - extraHeader: send header fields
    ///   - showErrorToast: Weather to show error alert or not.
    /// - Returns: validatedData => The response of the APi, isSuccess => true or false based on status code, msg: String of the message received with response.
    func requestPostDataApi(with url: String,
                            parameters: Dictionary<String, Any>,
                            method: String = HttpMethods.post,
                            contentType: String = ContentType.applicationJson,
                            extraHeader: Dictionary<String, String> = [:],
                            showErrorToast: Bool = true) -> (validatedData: Dictionary<String, Any>, isSuccess: Bool, msg: String) {
        
        print(parameters)
        let (apiResponse, statusCode, strError) = ASWebServices.shared.requestPostDataApi(url: url,
                                                                                          parameters: parameters,
                                                                                          method: method,
                                                                                          contentType: contentType, extraHeader: extraHeader)
        
        let response = self.validateData(with: apiResponse, statusCode: statusCode, error: strError, showAlert: showErrorToast)
        return (response.validatedData, response.isSuccess, response.msg)
    }
    
    //MARK:- UPLOAD FILE REQUEST
    
    /// This function is used to hit api to server with parameters.
    ///
    /// - Parameters:
    ///   - url: Url string of the request.
    ///   - parameters: Parameters which is required to use the API.
    ///   - method: Http method for the APi.
    ///   - contentType: Content Type for the request.
    ///   - showErrorToast: Weather to show error alert or not.
    /// - Returns: validatedData => The response of the APi, isSuccess => true or false based on status code, msg: String of the message received with response.
    func requestUploadFileApi(with url: String,
                              parameters: Dictionary<String, Any>,
                              method: String = HttpMethods.post,
                              contentType: String = ContentType.applicationJson,
                              mediaFiles: [MediaFiles],
                              showErrorToast: Bool = true) -> (validatedData: Dictionary<String, Any>, isSuccess: Bool, msg: String) {
        
        print(parameters)
        let (apiResponse, statusCode, strError) = ASWebServices.shared.requestMultiPartApi(url: url, parameters: parameters, mediaFiles: mediaFiles, method: method)
        
        let response = self.validateData(with: apiResponse, statusCode: statusCode, error: strError, showAlert: showErrorToast)
        return (response.validatedData, response.isSuccess, response.msg)
    }
    
    //MARK:- GET REQUEST
    
    /// This function is used to hit api to server with parameters.
    ///
    /// - Parameters:
    ///   - url: Url string of the request.
    ///   - parameters: Parameters which is required to use the API.
    ///   - method: Http method for the APi.
    ///   - extraHeader: Header fields for request
    ///   - showErrorToast: Weather to show error alert or not.
    /// - Returns: validatedData => The response of the APi, isSuccess => true or false based on status code, msg: String of the message received with response.
    func requestGetDataApi(with url: String,
                           parameters: Dictionary<String, Any>,
                           method: String = HttpMethods.get,
                           extraHeader: Dictionary<String, String> = [:],
                           showErrorToast: Bool = true) -> (validatedData: Dictionary<String, Any>, isSuccess: Bool, msg: String) {
        
        let (apiResponse, statusCode, strError) = ASWebServices.shared.requestGETDataApi(url: url, parameters: parameters, method: method, extraHeader: extraHeader)
        
        let response = self.validateData(with: apiResponse, statusCode: statusCode, error: strError, showAlert: showErrorToast)
        return (response.validatedData, response.isSuccess, response.msg)
    }
    
}
extension ASDataModal {
    
    /// This function is used to validate the response received from API in order to check success and failure and custom handling.
    ///
    /// - Parameters:
    ///   - response: Api Response
    ///   - statusCode: Status code of the request i.e 200, 401 etc.
    ///   - error: Error returned by HTTP Client if any, otherwise empty.
    ///   - showAlert: If want to show the alert for failure.
    /// - Returns: validatedData => The response of the APi, isSuccess => true or false based on status code, msg: String of the message received with response.
    func validateData(with response: Dictionary<String, Any>,
                      statusCode: Int,
                      error: String,
                      showAlert: Bool = false) -> (validatedData: Dictionary<String,Any>, isSuccess: Bool, msg: String) {
        print(response)
        if error.isEmpty == false {
            if showAlert == true {
                kMainQueue.async {
                    ASUtility.shared.dissmissAlert(title: "", message: error, lblDone: L10n.ok.string)
                }
            }
            return (response, false, "")
        }
        if statusCode == 200 {
            
            var message = ""
            
            guard let original = response["original"] as? Dictionary<String, Any>, let status = original["status"] as? Bool  else {
                
                if let httpStatus = response["http_status"] as? String {
                    let message = response["message"] as? String ?? ""
                    if httpStatus == "401" {
                        kMainQueue.async {
                            ASUtility.shared.showToast(with: message, completion: {
                                DefaultCenter.notification.post(name: Notifications.logout.name, object: nil)
                            })
                        }
                    }
                }
                return (response, false, "")
            }
            
            if let msg = original["message"] as? String {
                message = msg
            }
            
            guard let data = original["data"] as? Dictionary<String, Any> else {
                return (original, status, message)
            }
            
            
            return (data, status, message)
            
        } else if statusCode == 503 {
            kMainQueue.async {
                self.objUtil.dissmissAlert(title: "", message: "Service Unavailable", lblDone: L10n.ok.string)
            }
            return (response, false, "")
            
        } else if statusCode == 401 {
            //            if let msg = response["Message"] as? String {
            //                kMainQueue.async {
            //                    self.objUtil.dissmissAlert(title: "", message: msg, txtDone: L10n.ok.string)
            //                    kDefaultCenter.post(name: Notifications.logout.name, object: nil)
            //                }
            //            }
            if let msg = response["exception"] as? String {
                kMainQueue.async {
                    self.objUtil.dissmissAlert(title: "", message: msg, lblDone: L10n.ok.string)
                }
            }
            return (response, false, "")
        } else {
            
            if showAlert == true {
                if let msg = response["exception"] as? String {
                    kMainQueue.async {
                        self.objUtil.dissmissAlert(title: "", message: msg, lblDone: L10n.ok.string)
                    }
                }
            }
            return (response, false, "")
        }
    }
}
