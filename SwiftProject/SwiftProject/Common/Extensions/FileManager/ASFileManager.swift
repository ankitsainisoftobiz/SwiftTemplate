//
//  ASFileManager.swift
//  Ankit_Saini
//
//  Created by softobiz on 12/22/17.
//  Copyright © 2017 Ankit_Saini. All rights reserved.
//

import Foundation

extension FileManager {
    
    // MARK: - Variables
    
    /// Path type enum.
    ///
    /// - mainBundle: Main bundle path.
    /// - library: Library path.
    /// - documents: Documents path.
    /// - cache: Cache path.
    public enum PathType: Int {
        case documents
        case temprary
    }
    
    // MARK: - Functions
    
    /// Get the path for a PathType.
    ///
    /// - Parameter path: Path type.
    /// - Returns: Returns the path type String.
    public func pathFor(_ path: PathType) -> String? {
        var pathString: String?
        
        switch path {
        case .documents:
            pathString = self.documentsPath()
        case .temprary:
            pathString = NSTemporaryDirectory()
        }
        
        return pathString
    }
    
    /// Save a file with given content.
    ///
    /// - Parameters:
    ///   - file: File to be saved.
    ///   - path: File path.
    ///   - content: Content to be saved.
    /// - Throws: write(toFile:, atomically:, encoding:) errors.
    public func save(file: String, in path: PathType, content: Data) -> String {
        guard let path = FileManager.default.pathFor(path) else {
            print("Path not found")
            return ""
        }
        
        let filePath = path.appending("\(file)")
        self.createFile(atPath: filePath, contents: content, attributes: nil)
        
        return filePath
    }
    
    /// Read a file an returns the content as String.
    ///
    /// - Parameters:
    ///   - file: File to be read.
    ///   - path: File path.
    /// - Returns: Returns the content of the file a String.
    /// - Throws: Throws String(contentsOfFile:, encoding:) errors.
    public func read(file: Data, from path: PathType) throws -> Data? {
        guard let path = FileManager.default.pathFor(path) else {
            return nil
        }
        return self.contents(atPath: path)
    }
    
    /// Get Documents path for a filename.
    ///
    /// - Parameter file: Filename
    /// - Returns: Returns the path as a String.
    public func documentsPath(file: String = "") -> String? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsURL.path.appending("\(file)")
    }
    
}


extension FileManager {
    
    // MARK: - Common Directories
    static var temporaryDirectoryPath: String {
        return NSTemporaryDirectory()
    }
    
    static var temporaryDirectoryURL: URL {
        return URL(fileURLWithPath: FileManager.temporaryDirectoryPath, isDirectory: true)
    }
    
    // MARK: - File System Modification
    @discardableResult
    static func createDirectory(atPath path: String) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    static func createDirectory(at url: URL) -> Bool {
        return createDirectory(atPath: url.path)
    }
    
    @discardableResult
    static func removeItem(atPath path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    static func removeItem(at url: URL) -> Bool {
        return removeItem(atPath: url.path)
    }
    
    @discardableResult
    static func removeAllItemsInsideDirectory(atPath path: String) -> Bool {
        let enumerator = FileManager.default.enumerator(atPath: path)
        var result = true
        
        while let fileName = enumerator?.nextObject() as? String {
            let success = removeItem(atPath: path + "/\(fileName)")
            if !success { result = false }
        }
        
        return result
    }
    
    @discardableResult
    static func removeAllItemsInsideDirectory(at url: URL) -> Bool {
        return removeAllItemsInsideDirectory(atPath: url.path)
    }
}
