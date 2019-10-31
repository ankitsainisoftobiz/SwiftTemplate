//
//  ASWebServices.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

/// Error type in API
enum ErrorType {
    
    /// Url is invalid
    static let invalidUrl = "invalid_url"
    
    /// Response is invalid
    static let invalidResponse = "invalid_response"
    
    /// Parameters are invalid
    static let invalidParameters = "invalid_parameters"
}

/// This class is responsible for all the web service requests.
class ASWebServices: NSObject {
    
    /// Shared instance
    static let shared = ASWebServices()
    
    /// JSONDecoder
    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
    
    ///
    //MARK:- Request Handler
    ///
    
    /// This is used to process the api request and parse the result
    ///
    /// - Parameters:
    ///   - request: URLRequest
    ///   - completion: Result<T, Error> => This will return the response of the request along with status code of the request and error string of response.
    func requestHandling<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        
        URLSession.shared.request(with: request) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    let error = NSError(domain: "Wrong status code",
                                        code: (response as? HTTPURLResponse)?.statusCode ?? 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Status code not found"])
                    completion(.failure(error))
                    return
                }
                print(statusCode)
                if statusCode != 200 {
                    print("statusCode should be 200, but is \(statusCode)")
                }
                
                do {
                    let reply = String(data: data, encoding: .utf8)
                    print(reply ?? "")
                    
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                    return
                } catch {
                    let reply = String(data: data, encoding: .utf8)
                    print(reply ?? "")
                    
                    let error = NSError(domain: "decoding issue", code: 0, userInfo: [NSLocalizedDescriptionKey: "Response is not in correct format"])
                    completion(.failure(error))
                    return
                }
            }
            }.resume()
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
    ///   - completion: Result<T, Error>
    func requestPostDataApi<T: Decodable>(url: String,
                                          parameters: Dictionary<String, Any>,
                                          method: String = HttpMethods.post,
                                          contentType: String = ContentType.applicationJson,
                                          extraHeader: Dictionary<String, String> = [:],
                                          completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let requestUrl = URL.init(string: url) else {
            let error = NSError(domain: ErrorType.invalidUrl, code: 0, userInfo: [NSLocalizedDescriptionKey: "URL not valid"])
            completion(.failure(error))
            return
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
        
        requestHandling(request: request) { (result) in
            completion(result)
        }
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
    func requestGETDataApi<T: Decodable>(url: String,
                                         parameters: Dictionary<String, Any>,
                                         method: String = HttpMethods.get,
                                         extraHeader: Dictionary<String, String> = [:],
                                         completion: @escaping (Result<T, Error>) -> Void) {
        
        var components = URLComponents.init(string: url)
        var queryItems: [URLQueryItem] = []
        let dictHeaders = extraHeader
        
        for item in parameters {
            let query = URLQueryItem(name: item.key, value: "\(item.value)")
            queryItems.append(query)
        }
        components?.queryItems = queryItems
        
        guard let requestUrl = components?.url else {
            let error = NSError(domain: ErrorType.invalidUrl, code: 0, userInfo: [NSLocalizedDescriptionKey: "URL not valid"])
            completion(.failure(error))
            return
        }
        print(requestUrl)
        
        var request: URLRequest = URLRequest(url: requestUrl)
        request.httpMethod = method
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies=false
        request.timeoutInterval = 60.0
        request.allHTTPHeaderFields = dictHeaders
        
        requestHandling(request: request) { (result) in
            completion(result)
        }
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
    func requestMultiPartApi<T: Decodable>(url: String,
                                           parameters: Dictionary<String, Any>,
                                           mediaFiles: [MediaFiles],
                                           method: String = HttpMethods.post,
                                           completion: @escaping (Result<T, Error>) -> Void) {
        
        let boundaryConstant  = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        let contentType = "multipart/form-data; boundary=\(boundaryConstant)"
        
        guard let requestUrl = URL.init(string: url) else {
            let error = NSError(domain: ErrorType.invalidUrl, code: 0, userInfo: [NSLocalizedDescriptionKey: "URL not valid"])
            completion(.failure(error))
            return
        }
        print(requestUrl )
        
        var request: URLRequest = URLRequest.init(url: requestUrl)
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
                    
                    let error = NSError(domain: ErrorType.invalidParameters, code: 0, userInfo: [NSLocalizedDescriptionKey: "Parameter's data is nil."])
                    completion(.failure(error))
                    return
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
                let imageData = file.fileImage?.jpegData(compressionQuality: 0.6),
                let data4 = "\r\n".data(using: .utf8) else {
                    
                    let error = NSError(domain: ErrorType.invalidParameters, code: 0, userInfo: [NSLocalizedDescriptionKey: "Media Files Parameter's data is nil."])
                    completion(.failure(error))
                    return
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
        
        requestHandling(request: request) { (result) in
            completion(result)
        }
    }
}

// MARK: - URLSession
extension URLSession {
    
    /// Request API in URLSession
    ///
    /// - Parameters:
    ///   - urlRequest: URLRequest
    ///   - result: Result<(URLResponse, Data), Error>
    /// - Returns: URLSessionDataTask
    func request(with urlRequest: URLRequest,
                 result:@escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        
        return dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: ErrorType.invalidResponse, code: 0, userInfo: [NSLocalizedDescriptionKey: "Response not valid"])
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        })
        
    }
}

//MARK:- MediaFiles
/// This modal will represent the media files which needs to upload on server.
struct MediaFiles {
    
    /// name of the parameter
    var keyName: String
    
    /// name of the file
    var fileName: String
    
    /// Image
    var fileImage: UIImage?
    
    /// File url
    var fileUrl: String

    /// Init Modal.
    /// - Parameter keyName: String
    /// - Parameter fileName: String
    /// - Parameter fileImage: UIImage?
    /// - Parameter fileUrl: String
    init(keyName: String, fileName: String, fileImage: UIImage?, fileUrl: String = "") {
        self.keyName = keyName
        self.fileName = fileName
        self.fileImage = fileImage
        self.fileUrl = fileUrl
    }
}
