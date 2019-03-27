//
//  ASWebServices.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit

class ASWebServices: NSObject {

    static let shared = ASWebServices()
    
    //MARK:- Application / Json
    
    /// This function is used to request api with normal json form-data request .
    ///
    /// - Parameters:
    ///   - url: url string of the request
    ///   - parameters: parameters which are required for the request
    ///   - method: Http method for the request i.e. POST, DELETE etc. Dont pass GET method here , GET request is different.
    /// - Returns: This will return the response of the request along with status code of the request.
    func requestPostDataApi(url: String,
                            parameters: Dictionary<String, Any>,
                            method: String = HttpMethods.post) -> (Dictionary<String,Any>, Int, String) {
        
        var strError = ""
        guard let requestUrl = URL.init(string: url) else {
            return ([:], 404, strError)
        }
        print(requestUrl )
        
        var request: URLRequest = URLRequest(url: requestUrl)
        request.httpMethod = method
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        } catch let error {
            print("Failed to JSONSerialization: \(error.localizedDescription)")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies=false
        request.timeoutInterval = 60.0
        
        let semaphore = DispatchSemaphore(value: 0)
        var responseData: Data = Data()
        var statusCode: Int = 403
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil && data != nil else {  // check for fundamental networking error
                print("error=\(error?.localizedDescription ??  "")")
                strError = error?.localizedDescription ??  ""
                kMainQueue.async {
                    kAppDelegate.hideLoader()
                }
                responseData = Data()
                semaphore.signal()
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {// check for http errors
                
                statusCode = httpStatus.statusCode
                print(statusCode)
                
                if statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                }
            }
            
            if let dataResponse = data {
                responseData = dataResponse
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
//        if statusCode != 200 {
//            let reply = String(data: responseData, encoding: .utf8)
//            print("Response : \(String(describing: reply))")
//        }
        
        do {
            
            if let serverResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                return (serverResponse, statusCode, strError)
            } else if let serverResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [Any] {
                return (["data": serverResponse], statusCode, strError)
            } else {
                let reply = String(data: responseData, encoding: .utf8)
                print(reply ?? "")
            }
            
        } catch let error {
            print("Failed to load: \(error.localizedDescription)")
            if strError.isEmpty == true {
                strError = error.localizedDescription
            }
            kMainQueue.async {
                kAppDelegate.hideLoader()
            }
            let reply = String(data: responseData, encoding: .utf8)
            print(reply ?? "")
            
            return ([:], statusCode, strError)
        }
        return ([:], statusCode, strError)
    }
    
    //MARK:- GET Request
    
    /// This function is used to request api with normal json form-data request .
    ///
    /// - Parameters:
    ///   - url: url string of the request
    ///   - parameters: parameters which are required for the request
    ///   - method: GET method.
    /// - Returns: This will return the response of the request along with status code of the request.
    func requestGETDataApi(url: String,
                           parameters: Dictionary<String, Any>,
                           method: String = HttpMethods.get) -> (Dictionary<String,Any>, Int, String) {
        
        var strError = ""
        var components = URLComponents.init(string: url)
        var queryItems: [URLQueryItem] = []
        
        for item in parameters {
            let query = URLQueryItem(name: item.key, value: "\(item.value)")
            queryItems.append(query)
        }
        components?.queryItems = queryItems
        
        guard let requestUrl = components?.url else {
            return ([:], 404, strError)
        }
        print(requestUrl)
        
        var request: URLRequest = URLRequest(url: requestUrl)
        request.httpMethod = method
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies=false
        request.timeoutInterval = 60.0
        
        let semaphore = DispatchSemaphore(value: 0)
        var responseData: Data = Data()
        var statusCode: Int = 403
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil && data != nil else {  // check for fundamental networking error
                print("error=\(error?.localizedDescription ??  "")")
                strError = error?.localizedDescription ??  ""
                kMainQueue.async {
                    kAppDelegate.hideLoader()
                }
                responseData = Data()
                semaphore.signal()
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {// check for http errors
                
                statusCode = httpStatus.statusCode
                print(statusCode)
                
                if statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                }
            }
            
            if let dataResponse = data {
                responseData = dataResponse
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        do {
            
            if let serverResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                return (serverResponse, statusCode, strError)
            } else if let serverResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [Any] {
                return (["data": serverResponse], statusCode, strError)
            } else {
                let reply = String(data: responseData, encoding: .utf8)
                print(reply ?? "")
            }
        } catch let error {
            print("Failed to load: \(error.localizedDescription)")
            if strError.isEmpty == true {
                strError = error.localizedDescription
            }
            kMainQueue.async {
                kAppDelegate.hideLoader()
            }
            let reply = String(data: responseData, encoding: .utf8)
            print(reply ?? "")
            
            return ([:], statusCode, strError)
        }
        return ([:], statusCode, strError)
    }
}

struct Media {
    var keyName: String
    var fileName: String
    var fileImage: UIImage
    
    init(fileName: String, fileImage: UIImage, keyName: String) {
        self.fileName = fileName
        self.fileImage = fileImage
        self.keyName = keyName
    }
}

