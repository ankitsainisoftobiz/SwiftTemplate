//
//  ASDataModal.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import UIKit

/// This class is responsible for handling all API request's and validations of response.
class ASDataModal: NSObject {
    
    /// Shared Instance
    static let shared = ASDataModal()
    
    /// Utilities Shared Instance
    private let objUtil = ASUtility.shared
    
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
    ///   - completion: validatedData => The response of the APi, isSuccess => true or false based on status code, msg: String of the message received with response.
    func requestPostDataApi<T: Codable>(with url: String,
                                        parameters: Dictionary<String, Any>,
                                        method: String = HttpMethods.post,
                                        contentType: String = ContentType.applicationJson,
                                        extraHeader: Dictionary<String, String> = [:],
                                        showErrorToast: Bool = true,
                                        completion: @escaping (T?, ResponseTuples?) -> Void) {
        
        print(parameters)
        weak var weakSelf = self
        ASWebServices.shared.requestPostDataApi(url: url, parameters: parameters, method: method, contentType: contentType, extraHeader: extraHeader) { (result: Result<Success<T>, Error>) in
            
            let response = weakSelf?.responseOutput(result: result, showErrorToast: showErrorToast)
            completion(response?.0, response?.1)
        }
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
    ///   - completion: validatedData => The response of the APi, isSuccess => true or false based on status code, msg: String of the message received with response.
    func requestUploadFileApi<T: Codable>(with url: String,
                                          parameters: Dictionary<String, Any>,
                                          method: String = HttpMethods.post,
                                          contentType: String = ContentType.applicationJson,
                                          mediaFiles: [MediaFiles],
                                          showErrorToast: Bool = true,
                                          completion: @escaping (T?, ResponseTuples?) -> Void) {
        
        print(parameters)
        weak var weakSelf = self
        ASWebServices.shared.requestMultiPartApi(url: url, parameters: parameters, mediaFiles: mediaFiles) { (result: Result<Success<T>, Error>) in
            
            let response = weakSelf?.responseOutput(result: result, showErrorToast: showErrorToast)
            completion(response?.0, response?.1)
        }
        
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
    ///   - completion: validatedData => The response of the APi, isSuccess => true or false based on status code, msg: String of the message received with response.
    func requestGetDataApi<T: Codable>(with url: String,
                                       parameters: Dictionary<String, Any>,
                                       method: String = HttpMethods.get,
                                       extraHeader: Dictionary<String, String> = [:],
                                       showErrorToast: Bool = true,
                                       completion: @escaping (T?, ResponseTuples?) -> Void) {
        
        weak var weakSelf = self
        
        ASWebServices.shared.requestGETDataApi(url: url, parameters: parameters, method: method, extraHeader: extraHeader) { (result: Result<Success<T>, Error>) in
            
            let response = weakSelf?.responseOutput(result: result, showErrorToast: showErrorToast)
            completion(response?.0, response?.1)
        }
    }
}

//MARK:- RESPONSE VALIDATIONS
extension ASDataModal {
    
    /// This function will validate and returns the validated response of request.
    /// - Parameter result: Result<Success<T>, Error>
    /// - Parameter showErrorToast: If true then app will show a toast for any error that occurs else false.
    private func responseOutput<T: Codable>(result: Result<Success<T>, Error>, showErrorToast: Bool = true) -> (T?, ResponseTuples) {
        
        switch result {
        case .failure(let error):
            print(error.localizedDescription)
            
            let response = ASDataModal.shared.validateData(with: false, statusCode: 201, error: error.localizedDescription, showAlert: showErrorToast)
            
            let tuple = ResponseTuples.init(isSuccess: response.isSuccess, statusCode: response.statusCode, error: response.msg)
            
            return (nil, tuple)
            
        case .success(let data):
            let response = ASDataModal.shared.validateData(with: data.isSuccess, statusCode: data.statusCode, error: data.error, showAlert: showErrorToast)
            
            let tuple = ResponseTuples.init(isSuccess: response.isSuccess, statusCode: response.statusCode, error: response.msg)
            
            return (data.data, tuple)
        }
    }
    
    /// This function is used to validate the response received from API in order to check success and failure and custom handling.
    ///
    /// - Parameters:
    ///   - isSuccess: Bool
    ///   - statusCode: Status code of the request i.e 200, 401 etc.
    ///   - error: Error returned by HTTP Client if any, otherwise empty.
    ///   - showAlert: If want to show the alert for failure.
    /// - Returns:  isSuccess => true or false based on status code, msg: String of the message received with response.
    private func validateData(with isSuccess: Bool, statusCode: Int, error: String?, showAlert: Bool = false) -> (isSuccess: Bool, msg: String, statusCode: Int) {
        
        var msg = ""
        if let message = error {
            msg = message
        }
        
        if statusCode == 200 {
            if isSuccess == true {
                return (true, msg, statusCode)
            }
            return (false, msg, statusCode)
        }
        
        if showAlert == true {
            if msg.isEmpty == false {
                kMainQueue.async {
                    ASUtility.shared.dissmissAlert(title: "", message: msg, lblDone: L10n.ok.string)
                }
                return (false, "", statusCode)
            }
        }
        return (false, msg, statusCode)
    }
}
