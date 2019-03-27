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
    ///   - showErrorToast: Weather to show error alert or not.
    /// - Returns: validatedData => The response of the APi, isSuccess => true or false based on status code.
    func requestPostDataApi(with url: String,
                            parameters: Dictionary<String, Any>,
                            method: String = HttpMethods.post,
                            showErrorToast: Bool = true) -> (validatedData: Dictionary<String, Any>, isSuccess: Bool) {
        
        
        let (apiResponse, statusCode, strError) = ASWebServices.shared.requestPostDataApi(url: url, parameters: parameters, method: method)
        
        let response = self.validateData(with: apiResponse, statusCode: statusCode, error: strError, showAlert: showErrorToast)
        return (response.validatedData, response.isSuccess)
    }
    
    //MARK:- GET REQUEST
    
    /// This function is used to hit api to server with parameters.
    ///
    /// - Parameters:
    ///   - url: Url string of the request.
    ///   - parameters: Parameters which is required to use the API.
    ///   - method: Http method for the APi.
    ///   - showErrorToast: Weather to show error alert or not.
    /// - Returns: validatedData => The response of the APi, isSuccess => true or false based on status code.
    func requestGetDataApi(with url: String,
                           parameters: Dictionary<String, Any>,
                           method: String = HttpMethods.get,
                           showErrorToast: Bool = true) -> (validatedData: Dictionary<String, Any>, isSuccess: Bool) {
        
        let (apiResponse, statusCode, strError) = ASWebServices.shared.requestGETDataApi(url: url, parameters: parameters, method: method)
        
        let response = self.validateData(with: apiResponse, statusCode: statusCode, error: strError, showAlert: showErrorToast)
        return (response.validatedData, response.isSuccess)
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
    /// - Returns: validatedData => The response of the APi, isSuccess => true or false based on status code.
    func validateData(with response: Dictionary<String, Any>,
                      statusCode: Int,
                      error: String,
                      showAlert: Bool = false) -> (validatedData: Dictionary<String,Any>, isSuccess: Bool) {
        
        if error.isEmpty == false {
            if showAlert == true {
                kMainQueue.async {
                    self.objUtil.dissmissAlert(title: "", message: error, lblDone: L10n.ok.string)
                }
            }
            return (response, false)
        }
        if statusCode == 200 {
        
            if let status = response["Status"] as? Bool, status == false {
                if let msg = response["Message"] as? String, showAlert == true {
                    kMainQueue.async {
                        self.objUtil.dissmissAlert(title: "", message: msg, lblDone: L10n.ok.string)
                    }
                }
                return (response, false)
            }
            return (response, true)
            
        } else if statusCode == 503 {
            kMainQueue.async {
                self.objUtil.dissmissAlert(title: "", message: "Service Unavailable", lblDone: L10n.ok.string)
            }
            return (response, false)
            
        } else if statusCode == 401 {
//            if let msg = response["Message"] as? String {
//                kMainQueue.async {
//                    self.objUtil.dissmissAlert(title: "", message: msg, txtDone: L10n.ok.string)
//                    kDefaultCenter.post(name: Notifications.logout.name, object: nil)
//                }
//            }
            return (response, false)
        } else {
            
            if showAlert == true {
                if let msg = response["message"] as? String {
                    kMainQueue.async {
                        self.objUtil.dissmissAlert(title: "", message: msg, lblDone: L10n.ok.string)
                    }
                } else if let data = response["Data"] as? [Dictionary<String, String>] {
                    //
                    // Get all values of the error dictionary in response array
                    //
                    let arrErrValues = data
                        .map {$0.values}
                        .reduce([], +)
                    
                    if arrErrValues.isEmpty == false {
                        let strError = arrErrValues.joined(separator: "\n\n")
                        kMainQueue.async {
                            self.objUtil.dissmissAlert(title: "", message: strError, lblDone: L10n.ok.string)
                        }
                    }
                }
            }
            return (response, false)
        }
    }
}
