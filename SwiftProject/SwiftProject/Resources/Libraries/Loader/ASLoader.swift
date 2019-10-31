//
//  ASLoader.swift
//  WorkMode
//
//  Created by Ankit Saini on 08/05/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

/// Activity Loader indicator.
class ASLoader: UIActivityIndicatorView {
    
    /// Shared variable
    static let shared = ASLoader()
    
    /// Start the loader.
    ///
    /// - Parameters:
    ///   - view: View in which loader needs to be started.
    ///   - tintColor: color of the loading spinner.
    func start(in view: UIView, tintColor: UIColor = .gray) {
        self.center = view.center
        self.style = .gray
        self.tintColor = tintColor
        self.hidesWhenStopped = true
        view.addSubview(self)
        self.startAnimating()
    }
    
    /// Customize the loader frame.
    ///
    /// - Parameters:
    ///   - view: View in which loader needs to be started.
    ///   - frame: frame of the loader.
    func startCustom(in view: UIView, frame: CGRect) {
        self.frame = frame
        self.style = .gray
        view.addSubview(self)
        self.startAnimating()
    }
    
    /// Stop the loader.
    func stop() {
        DispatchQueue.main.async {
            self.stopAnimating()
            self.removeFromSuperview()
        }
    }
}
