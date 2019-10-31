//
//  ASScroll.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

//
//MARK:- UIScrollView
//MARK:
extension UIScrollView {
    
    /// Scroll to particular co-ordinate
    ///
    /// - Parameter yCo: CGFloat
    func scrollToY(yCo: CGFloat) {
        let offset = CGPoint.init(x: 0, y: yCo)
        self.setContentOffset(offset, animated: true)
    }
}

//MARK:- UITableView
extension UITableView {
    
    /// Scroll the tableview to bottom
    func scrollToBottom() {
        kMainQueue.async {
            let sections = self.numberOfSections
            if sections > 0 {
                let rows = self.numberOfRows(inSection: sections-1)
                if rows > 0 {
                    let indexPath = IndexPath(row: rows-1, section: sections-1)
                    self.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
}

//
//MARK:- UICollectionView
//MARK:
extension UICollectionView {
    
    /// Scroll to last element
    ///
    /// - Parameter animated: Bool
    func scrollToLast(animated: Bool) {
        if self.numberOfItems(inSection: 0) > 0 {
            let index = IndexPath(item: self.numberOfItems(inSection: 0)-1, section: 0)
            self.scrollToItem(at: index, at: .right, animated: animated)
        }
    }
    
    /// Scroll to first element
    ///
    /// - Parameter animated: Bool
    func scrollToFirst(animated: Bool) {
        if self.numberOfItems(inSection: 0) > 0 {
            let index = IndexPath(item: 0, section: 0)
            self.scrollToItem(at: index, at: .right, animated: animated)
        }
    }
    
    /// Scroll to particular item in collection
    ///
    /// - Parameters:
    ///   - item: Int
    ///   - animated: Bool
    func scrollToItem(item: Int, animated: Bool) {
        if self.numberOfItems(inSection: 0) >= item {
            let index = IndexPath(item: item, section: 0)
            self.scrollToItem(at: index, at: .right, animated: animated)
        }
    }
}
