//
//  ASWebServices.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit

/// This class is responsible for all the web service requests.
class ASWebServices: NSObject {
    
    /// Shared instance
    static let shared = ASWebServices()
    
    ///
    //MARK:- Request Handler
    ///
    
    /// This function is used to request api with normal json form-data request.
    ///
    /// - Parameters:
    ///   - request: URLRequest consisting of parameters and media files if any.
    ///   - error: Error string if any in request.
    /// - Returns: This will return the response of the request along with status code of the request and error string of response.
    func requestHandling(request: URLRequest,
                         error: String) -> (response: Dictionary<String,Any>, statusCode: Int, error: String) {
        var strError = error
        let semaphore = DispatchSemaphore(value: 0)
        var responseData: Data = Data()
        var statusCode: Int = 403
        
        ///------------------------------------SSL Pinning------------------------------------------///
        //        let urlSession = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
        
        ///------------------------------------------------------------------------------///
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            //        let task = urlSession.dataTask(with: request) { data, response, error in
            
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
    
    //MARK:- POST REQUEST
    
    /// This function is used to request api with normal json form-data request.
    ///
    /// - Parameters:
    ///   - url: url string of the request
    ///   - parameters: parameters which are required for the request
    ///   - method: Http method for the request i.e. POST, DELETE etc. Dont pass GET method here , GET request is different.
    ///   - contentType: Content Type for the request.
    ///   - extraHeader: send header fields
    /// - Returns: This will return the response of the request along with status code of the request.
    
    func requestPostDataApi(url: String,
                            parameters: Dictionary<String, Any>,
                            method: String = HttpMethods.post,
                            contentType: String = ContentType.applicationJson,
                            extraHeader: Dictionary<String, String> = [:]) -> (Dictionary<String,Any>, Int, String) {
        
        var strError = ""
        guard let requestUrl = URL.init(string: url) else {
            return ([:], 404, strError)
        }
        print(requestUrl )
        
        var request: URLRequest = URLRequest(url: requestUrl)
        request.httpMethod = method
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        print(contentType)
        for (key, value) in extraHeader {
            request.setValue(value, forHTTPHeaderField: key)
        }
        if contentType == ContentType.applicationJson {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = jsonData
            } catch let error {
                strError = error.localizedDescription
                print("Failed to request JSONSerialization: \(error.localizedDescription)")
            }
        } else if contentType == ContentType.applicationXWWFormUrlencoded {
            
            var queryItems: [URLQueryItem] = []
            for (key, value) in parameters {
                let queryItem = URLQueryItem.init(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                queryItems.append(queryItem)
            }
            var component = URLComponents.init(string: url)
            component?.queryItems = queryItems
            request.url = component?.url
        }
        
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 60.0
        
        return requestHandling(request: request, error: strError)
    }
    
    //MARK:- GET REQUEST
    
    /// This function is used to request api with normal json form-data request .
    ///
    /// - Parameters:
    ///   - url: url string of the request
    ///   - parameters: parameters which are required for the request
    ///   - method: GET method.
    ///   - extraHeader: send header fields
    /// - Returns: This will return the response of the request along with status code of the request.
    func requestGETDataApi(url: String,
                           parameters: Dictionary<String, Any>,
                           method: String = HttpMethods.get,
                           extraHeader: Dictionary<String, String> = [:]) -> (Dictionary<String, Any>, Int, String) {
        
        let strError = ""
        var components = URLComponents.init(string: url)
        var queryItems: [URLQueryItem] = []
        let dictHeaders = extraHeader
        
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
        request.allHTTPHeaderFields = dictHeaders
        
        return requestHandling(request: request, error: strError)
    }
    
    ///
    //MARK:- Multipart/Form-data
    ///
    
    /// This function is used to upload media files on server as Multipart/form-data.
    ///
    /// - Parameters:
    ///   - url: url string of the request.
    ///   - parameters: parameters which are required for the request.
    ///   - mediaFiles: Array of all files which needs to upload.
    ///   - method: HTTP Method, default is POST.
    /// - Returns: This will return the response of the request along with status code of the request.
    func requestMultiPartApi(url: String,
                             parameters: Dictionary<String, Any>,
                             mediaFiles: [MediaFiles],
                             method: String = HttpMethods.post) -> (Dictionary<String,Any>, Int, String) {
        
        var strError = ""
        let boundaryConstant  = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        let contentType = "multipart/form-data; boundary=\(boundaryConstant)"
        
        guard let requestUrl = URL.init(string: url) else {
            return ([:], 404, strError)
        }
        print(requestUrl )
        
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.url = requestUrl
        request.httpMethod = method
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies=false
        request.timeoutInterval = 60.0
        
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        ///
        ///Append parameters in body
        ///
        for (key, value) in parameters {
            print("\(key) : \(value)")
            
            guard let data1 = "--\(boundaryConstant)\r\n".data(using: .utf8),
                let data2 = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8),
                let data3 = "\(value)\r\n".data(using: .utf8),
                let data4 = "\r\n".data(using: .utf8) else {
                    
                    strError = "Parameter's data is nil."
                    return ([:], 404, strError)
            }
            body.append(data1)
            body.append(data2)
            body.append(data3)
            body.append(data4)
        }
        ///
        ///Append media files in body
        ///
        for file in mediaFiles {
            let mediaContentType: String = "image/jpeg"
            //image begin
            let keyName = "\(file.keyName)"
            let fileName = "\(file.fileName)"
            
            guard let data1 = "--\(boundaryConstant)\r\n".data(using: .utf8),
                let data2 = "Content-Disposition: form-data; name=\"\(keyName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8),
                let data3 = "Content-Type: \(mediaContentType)\r\n\r\n".data(using: .utf8),
                let imageData = file.fileImage.jpegData(compressionQuality: 0.6),
                let data4 = "\r\n".data(using: .utf8) else {
                    
                    strError = "Media Files Parameter's data is nil."
                    return ([:], 404, strError)
            }
            body.append(data1)
            body.append(data2)
            body.append(data3)
            body.append(imageData)
            body.append(data4)
            
            // image end
        }
        body.append("--\(boundaryConstant)--".data(using: .utf8)!)
        request.httpBody  = body as Data
        
        return requestHandling(request: request as URLRequest, error: strError)
    }
}
//MARK:- URLSessionDelegate
extension ASWebServices: URLSessionDelegate {
    
    /// The last message a session receives.  A session will only become invalid because of a systemic error or when it has been explicitly invalidated, in which case the error parameter will be nil.
    ///
    /// - Parameters:
    ///   - session: URLSession
    ///   - error: Error -> Reason for failure.
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("urlSession didBecomeInvalidWithError")
        print(error?.localizedDescription ?? "")
    }
    
    /// when a connection level authentication challenge has occurred, this delegate will be given the opportunity to provide authentication credentials to the underlying connection. Some types of authentication will apply to more than one request on a given connection to a server (SSL Server Trust challenges). If this delegate message is not implemented, the behavior will be to use the default handling, which may involve user interaction.
    ///
    /// - Parameters:
    ///   - session: URLSession
    ///   - challenge: URLAuthenticationChallenge
    ///   - completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?)
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("URLSessionDelegate didReceive challenge")
        print(challenge.protectionSpace.authenticationMethod)
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)
                
                if errSecSuccess == status {
                    print(SecTrustGetCertificateCount(serverTrust))
                    
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateData)
                        let size = CFDataGetLength(serverCertificateData)
                        let cert1 = NSData(bytes: data, length: size)
                        print("cert1.count: \(cert1.count)")
                        let fileDir = Bundle.main.path(forResource: "certificate", ofType: "cer")//Bundle.main.url(forResource: "certificate", withExtension: "cer")
                        
                        if let file = fileDir {
                            if let cert2 = NSData(contentsOfFile: file) {//try? NSData(contentsOf: file) {
                                print("cert2.count: \(cert2.count)")
                                if cert1.isEqual(to: cert2 as Data) {
                                    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Pinning failed
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
}

/// This modal will represent the media files which needs to upload on server.
struct MediaFiles {
    
    /// name of the parameter
    var keyName: String
    
    /// name of the file
    var fileName: String
    
    /// Image
    var fileImage: UIImage
}

