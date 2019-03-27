//
//  LocalizedStrings.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation

enum L10n {
    //No internet connected
    case noInternet
    /// Camera
    case camera
    /// Cancel
    case cancel
    /// OK
    case ok
    /// Dismiss
    case dismiss
    /// Done
    case done
    /// Entered email or mobile is not valid
    case enteredEmailOrMobileIsNotValid
    /// Error
    case error
    /// No record found
    case noRecordFound
    /// Password must be 6 characters long
    case passwordMustBe6CharactersLong
    /// Photo Library
    case photoLibrary
    /// Please enter password
    case pleaseEnterPassword
    /// Please enter username
    case pleaseEnterUsername
    /// Saved Photo Album
    case savedPhotoAlbum
    /// Select Source
    case selectSource
    /// Settings
    case settings
    /// Unable to upload file, try again
    case unableToUploadFileTryAgain
    /// Warning
    case warning
    /// You have denied the permission to access camera and gallery
    case youHaveDeniedThePermissionToAccessCamera
    //"Name can't be blank"
    case noName
    //"Name should be atleast 2 character long"
    case nameLength
    //"Email can't be blank"
    case noEmail
    //"Phone can't be blank"
    case noPhone
    //"Phone is not valid"
    case noValidPhone
    //"Email is not valid"
    case invalidEmail
    //"Password can't be blank"
    case noPwd
    //"Password minimum 6 char long"
    case pwdLength
    //"Password and confirm password should be same"
    case pwdNotMatched
    //"Please choose a profile picture."
    case chooseprofilepic
    /// loader msg
    case loading
    /// Uploading..
    case uploading
    /// Invalid response from server
    case invalidResponse
    //You are not authorised to login.
    case unauthorised
    //"Maximum selection limit reached"
    case imgLimitReached
    //No User is logged in.
    case noLoggedInUser
    // is Required
    case isRequired
    //Upload to server
    case uploadtoserver
    //Authentication Failed
    case authenticationfailed
    
}
// swiftlint:enable type_body_length
extension L10n: CustomStringConvertible {
    var description: String { return self.string }
    
    var string: String {
        switch self {
        case .authenticationfailed:
            return L10n.tr(key: "Authentication Failed")
        case .noInternet:
            return L10n.tr(key: "No internet connected")
        case .camera:
            return L10n.tr(key: "Camera")
        case .cancel:
            return L10n.tr(key: "Cancel")
        case .ok:
            return L10n.tr(key: "OK")
        case .dismiss:
            return L10n.tr(key: "Dismiss")
        case .done:
            return L10n.tr(key: "Done")
        case .enteredEmailOrMobileIsNotValid:
            return L10n.tr(key: "Entered email or mobile is not valid")
        case .error:
            return L10n.tr(key: "Error")
        case .noRecordFound:
            return L10n.tr(key: "No record found")
        case .passwordMustBe6CharactersLong:
            return L10n.tr(key: "Password must be 6 characters long")
        case .photoLibrary:
            return L10n.tr(key: "Photo Library")
        case .pleaseEnterPassword:
            return L10n.tr(key: "Please enter password")
        case .pleaseEnterUsername:
            return L10n.tr(key: "Please enter username")
        case .savedPhotoAlbum:
            return L10n.tr(key: "Saved Photo Album")
        case .selectSource:
            return L10n.tr(key: "Select Source")
        case .settings:
            return L10n.tr(key: "Settings")
        case .unableToUploadFileTryAgain:
            return L10n.tr(key: "Unable to upload file, try again")
        case .warning:
            return L10n.tr(key: "Warning")
        case .youHaveDeniedThePermissionToAccessCamera:
            return L10n.tr(key: "You have denied the permission to access camera and gallery")
        case .noName:
            return L10n.tr(key: "Name can't be blank")
        case .nameLength:
            return L10n.tr(key: "Minimum 2 characters required")
        case .noEmail:
            return L10n.tr(key: "Email can't be blank")
        case .invalidEmail:
            return L10n.tr(key: "Email is not valid")
        case .noPhone:
            return L10n.tr(key: "Phone can't be blank")
        case .noValidPhone:
            return L10n.tr(key: "Phone is not valid")
        case .noPwd:
            return L10n.tr(key: "Password can't be blank")
        case .pwdLength:
            return L10n.tr(key: "Minimum 6 characters required")
        case .pwdNotMatched:
            return L10n.tr(key: "Password & Confirm password not matched")
        case .chooseprofilepic:
            return L10n.tr(key: "Please choose a profile picture.")
        case .loading:
            return L10n.tr(key: "Loading..")
        case .uploading:
            return L10n.tr(key: "Uploading")
        case .invalidResponse:
            return L10n.tr(key: "Invalid response from server")
        case .unauthorised:
            return L10n.tr(key: "You are not authorised to login.")
        case .imgLimitReached:
            return L10n.tr(key: "Maximum selection limit reached")
        case .noLoggedInUser:
            return L10n.tr(key: "No User is Logged In")
        case .isRequired:
            return L10n.tr(key: "is required")
        case .uploadtoserver:
            return L10n.tr(key: "Upload to server as:")
        }
    }
    
    private static func tr(key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, bundle: Bundle(for: BundleToken.self), comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

func tr(_ key: L10n) -> String {
    return key.string
}

private final class BundleToken {}
