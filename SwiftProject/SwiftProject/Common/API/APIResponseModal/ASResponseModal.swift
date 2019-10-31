//
//  ASResponseModal.swift
//  Dojo
//
//  Created by Ankit Saini on 24/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation

/// Success Modal of APi Response
struct Success<T: Codable>: Codable {
    
    /// If request is success
    let isSuccess: Bool
    
    /// Status code of response
    let statusCode: Int

    /// Error string of response
    let error: String?
    
    /// Data of response
    let data: T?
    
    /// Keys for Response Modal
    enum CodingKeys: String, CodingKey {
        /// isSuccess, error, statusCode, data
        case isSuccess, error, statusCode, data
    }
}

/// Response Tuples
struct ResponseTuples {
    
    /// Is Success
    let isSuccess: Bool
    
    /// Status code
    let statusCode: Int
    
    /// Error String
    let error: String?
}
