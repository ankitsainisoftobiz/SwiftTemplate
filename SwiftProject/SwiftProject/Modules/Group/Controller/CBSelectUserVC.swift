//
//  CBSelectUserVC.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit

class CBSelectUserVC: ASBaseVC {
    ///
    ///OUTLET
    ///
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var uvHeader: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var arrSelectedIndex: [Int] = [] {
        didSet {
            weak var weakSelf = self
            kMainQueue.async {
                weakSelf?.tblMain.reloadData()
                weakSelf?.collectionView.reloadData()
            }
        }
    }
    
    //MARK:- CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Add Participant"
        self.navigationController?.navigationBar.setColors(background: .fbColor, text: .white)
        navBarButtons(left: #imageLiteral(resourceName: "back_arrow"), right: nil, shouldBack: true)
        btnRightMenu.setTitle("Next >", for: .normal)
        
        
    }
    
    //MARK:- ACTION METHODS
    
    override func navRightClicked(sender: UIButton) {
        guard let vc = Storyboard.group.viewController(viewControllerClass: CBGroupDetailVC.self) else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func actRemoveSelectedUser(sender: UIButton) {
        
    }
}

// MARK:- TableView Datasource
//MARK:
extension CBSelectUserVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CBSelectUserCell! = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CBSelectUserCell
        
        cell.btnCheck.isSelected = arrSelectedIndex.contains(indexPath.row)
        
        
        tableView.separatorStyle = .singleLine
        cell.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        uvHeader.isHidden = arrSelectedIndex.isEmpty
        return uvHeader
    }
    
}

//MARK:- UITableViewDelegate
extension CBSelectUserVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return arrSelectedIndex.isEmpty == false  ? 140 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrSelectedIndex.contains(indexPath.row) {
            arrSelectedIndex.removeAll { (element) -> Bool in
                return element == indexPath.row
            }
        } else {
            arrSelectedIndex.append(indexPath.row)
        }
    }
}


//MARK:-
//MARK: Table Cell
//MARK:
class CBSelectUserCell: UITableViewCell {
    @IBOutlet weak var imgVPic: ASImageView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
