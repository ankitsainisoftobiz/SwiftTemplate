//
//  ASChatImageCell.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import SDWebImage

class ASChatImageCell: UITableViewCell {
    ///Attachment Collection view
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //Base Views
    @IBOutlet weak var uvBaseView: UIView?
    @IBOutlet weak var uvContentView: UIView?
    
    ///Constraints
    @IBOutlet weak var baseViewWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var baseViewLeadingConstraint: NSLayoutConstraint?
    @IBOutlet weak var baseViewTrailingConstraint: NSLayoutConstraint?
    
    ///Lables
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblMsg: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    
    ///Variables
    var arrImages: [MediaModal] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    var controller: UIViewController?
    
    
    //MARK:- INIT
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView?.register(UINib(nibName: "ASChatImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ASChatImageCollectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- CONFIGURATIONS
    
    /// Configure View and colors
    ///
    /// - Parameter isSender: Bool
    func configureViewsColors(isSender: Bool) {
        if isSender == true { //sender
            baseViewLeadingConstraint?.constant = Screen.width - (baseViewWidthConstraint?.constant ?? 217) - 8
            
            uvBaseView?.backgroundColor = .fbColor
            lblName?.textColor = .white
            lblMsg?.textColor = .white
            lblTime?.textColor = .white
            
        } else { //receiver
            baseViewLeadingConstraint?.constant = 8
            
            uvBaseView?.backgroundColor = .white
            lblName?.textColor = .black
            lblMsg?.textColor = .black
            lblTime?.textColor = .black
        }
    }
    
    /// Add images in collection view
    ///
    /// - Parameter images: [MediaModal]
    func addImages(images: [MediaModal]) {
        arrImages = images
    }
    
    /// Setup base view controller for preview present purpose.
    ///
    /// - Parameter controller: UIViewController?
    func setupController(controlr: UIViewController?) {
        controller = controlr
    }
}

//MARK:- SELECTED USERS COLLECTION
//MARK:-
extension ASChatImageCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// Number of items in sticker collection view
    ///
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - section: Int
    /// - Returns: Int
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count > 4 ? 4 : arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch arrImages.count {
        case 1:
            return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        case 2:
            return CGSize.init(width: (collectionView.frame.size.width/2)-1, height: collectionView.frame.size.height-1)
        case 3:
            return CGSize.init(width: (collectionView.frame.size.width/2)-1, height: (collectionView.frame.size.height/2)-1)
        default:
            break
        }
        return CGSize.init(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    // Layout: Set Edges
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // top, left, bottom, right
    }
    
    /// cellForItem in collection view
    ///
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - indexPath: IndexPath
    /// - Returns: UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ASChatImageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASChatImageCollectionCell", for: indexPath) as? ASChatImageCollectionCell else {
            return UICollectionViewCell()
        }
        
        let file = arrImages[indexPath.item]
        if file.image != nil {
            cell.imgVPic?.image = file.image
            
        } else {
            if let url = URL.init(string: file.url) {
                cell.imgVPic?.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgVPic?.sd_setImage(with: url, completed: { (img, _, _, _) in
                    if img == nil {
                        //cell.imgVPic?.image = kPlaceholder
                    }
                })
            }
            
        }
        
        cell.imgVPic?.layer.masksToBounds = true
        switch arrImages.count {
        case 1:
            cell.imgVPic?.contentMode = .scaleAspectFill
        case 2:
            cell.imgVPic?.contentMode = .scaleAspectFill
        case 3:
            cell.imgVPic?.contentMode = .scaleAspectFit
        default:
            cell.imgVPic?.contentMode = .scaleToFill
        }
        
        
        if arrImages.count > 4 && indexPath.item == 3 {
            cell.lblTitle?.text = "+\(arrImages.count - 4) more"
        } else {
            cell.lblTitle?.text = ""
        }

        return cell
    }
    
    
    /// didSelectItemAt indexPath
    ///
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - indexPath: IndexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. create SKPhoto Array from UIImage
        var images = [SKPhoto]()
        for item in arrImages {
            if item.image != nil {
                let photo = SKPhoto.photoWithImage(item.image!)// add some UIImage
                images.append(photo)
            } else {
                let photo = SKPhoto.photoWithImageURL(item.url)
                photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
                images.append(photo)
            }
            
        }
        
        if arrImages.count > 4 && indexPath.item == 3 {
            // 2. create PhotoBrowser Instance, and present from your viewController.
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(indexPath.item)
            if let controllr = controller {
                controllr.present(browser, animated: true, completion: {})
                return
            }
            kAppDelegate.window?.rootViewController?.present(browser, animated: true, completion: {})
            
        } else {
            // 2. create PhotoBrowser Instance, and present from your viewController.
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(indexPath.item)
            if let controllr = controller {
                controllr.present(browser, animated: true, completion: {})
                return
            }
            kAppDelegate.window?.rootViewController?.present(browser, animated: true, completion: {})
        }
    }
}
