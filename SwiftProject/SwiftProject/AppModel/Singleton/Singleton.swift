//
//  Singleton.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation

/// This is a singleton class to store data during app cycle
class Singleton: NSObject {
    
    /// Shared instance
    static let shared = Singleton()
    
    /// String
    var strAuthToken: String = ""
    
    /// Delete all local stored data in singleton
    func clearData() {
        strAuthToken = ""
    }
}
