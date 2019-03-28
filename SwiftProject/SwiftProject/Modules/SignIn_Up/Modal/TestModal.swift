//
//  TestModal.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 28/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

/*
 http://jsoncafe.com
 
 {
 "job_information": {
 "title": "iOS Developer",
 "salary": 5000
 },
 "firstname": "John",
 "lastname": "Doe",
 "age": 20
 }
 */
struct Job: Codable {
    var title: String
    var salary: CGFloat
    
    init(title: String, salary: CGFloat) {
        self.title = title
        self.salary = salary
    }
    
    enum CodingKeys: String, CodingKey {
        case title, salary
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        salary = try values.decodeIfPresent(CGFloat.self, forKey: .salary) ?? 0
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
    }
}

struct Person: Codable {
    var job: Job?
    var firstName: String
    var lastName: String
    var age: Int
    
    init(job: Job, firstName: String, lastName: String, age: Int) {
        self.job = job
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    enum CodingKeys: String, CodingKey {
        case job = "job_information", firstName = "firstname", lastName = "lastname", age
    }
    //    init(from decoder: Decoder) throws {
    //        let values = try decoder.container(keyedBy: CodingKeys.self)
    //        age = try values.decodeIfPresent(Int.self, forKey: .age) ?? 0
    //        firstname = try values.decodeIfPresent(String.self, forKey: .firstname) ?? ""
    //        jobInformation = try values.decodeIfPresent([JobInformation].self, forKey: .jobInformation) ??
    //        lastname = try values.decodeIfPresent(String.self, forKey: .lastname)
    //    }
}

class Login: NSObject {
    static let shared = Login()
    var user: Person?
    
    
    /// This function is used to save the information of login for one time login.
    ///
    /// - Parameter user: Dictionary object of user returned from Server at the time of login into Data() form.
    func save(user: Data) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
        DefaultCenter.userDefaults.set(encodedData, forKey: Keys.userData)
    }
    
    /// This function is used to get the information of user and load user modal.
    ///
    /// - Returns: true if user is logged in else false
    func isUserLogin() -> Bool {
        // retrieving a value for a key
        if let rawData = DefaultCenter.userDefaults.data(forKey: Keys.userData), let info = NSKeyedUnarchiver.unarchiveObject(with: rawData) as? Data {
            if (info.count) > 0 {
                do {
                    let person = try JSONDecoder().decode(Person.self, from: info)
                    Login.shared.user = person
                    return true
                } catch let error {
                    print(error.localizedDescription)
                }
                return false
            }
        }
        return false
    }
    
    /// This is used to update the value of saved user object
    ///
    /// - Parameter user: Updated User object which needs to be saved and replaced with old one.
    /// - Returns: true if user is updated else false
    @discardableResult
    func update(user: Person) -> Bool {
        do {
            let encoded = try JSONEncoder().encode(user)
            print(String(data: encoded, encoding: .utf8) ?? "")
            Login.shared.save(user: encoded)
            return Login.shared.isUserLogin()
            
        } catch let error {
            print(error.localizedDescription)
        }
        return false
    }
}
