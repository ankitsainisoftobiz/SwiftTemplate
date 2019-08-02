//
//  CBGroupDetailVC.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit

class CBGroupDetailVC: ASBaseVC {

    enum ScreenType {
        case newGroup
        case groupDetail
    }
    var kScreenType: ScreenType = .newGroup
    
    ///OutLets
    @IBOutlet weak var uvHeaderInfo: UIView!
    @IBOutlet weak var imgVGroupPic: UIImageView!
    @IBOutlet weak var txtGroupName: UITextField!
    
    
    @IBOutlet weak var uvHeaderParticipants: UIView!
    @IBOutlet weak var lblParticipantCount: UILabel!
    @IBOutlet weak var btnAddNewUser: UIButton!
    
    
    //MARK:- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        if kScreenType == .newGroup {
            self.navigationItem.title = "Create New Group"
        } else {
            self.navigationItem.title = "Group Details"
        }
        
        self.navigationController?.navigationBar.setColors(background: .fbColor, text: .white)
        navBarButtons(left: #imageLiteral(resourceName: "back_arrow"), right: nil, shouldBack: true)
        ///
        ///Setup UI
        setupUI()
    }
    
    func setupUI() {
        btnRightMenu.setTitle("Done", for: .normal)
        if kScreenType == .newGroup {
            btnAddNewUser.isHidden = true
            lblParticipantCount.text = "Selected Participants"
            lblParticipantCount.textColor = .black
        } else {
            btnAddNewUser.isHidden = false
            lblParticipantCount.text = "0 Participants"
            lblParticipantCount.textColor = .fbColor
        }
    }
    //MARK:- ACTION
    @IBAction func actCamera(_ sender: UIButton) {
    }
    @IBAction func actAddNewUser(_ sender: UIButton) {
    }
    
    
}


// MARK:- TableView Datasource
//MARK:
extension CBGroupDetailVC: UITableViewDataSource {
    
    /// Number of sections in table
    ///
    /// - Parameter tableView: UITableView
    /// - Returns: Int
    func numberOfSections(in tableView: UITableView) -> Int {
        if kScreenType == .groupDetail {
            return 3
        }
        return 2
    }
    
    /// Number of rows in table
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 4
        case 2:
            return 3
        default:
            break
        }
        return 0
    }
    
    /// Cell for indexpath
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell: CBSelectUserCell! = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CBSelectUserCell
            
            if kScreenType == .groupDetail {
                cell.btnCheck.isHidden = true
            } else {
                cell.btnCheck.isHidden = false
            }
            
            tableView.separatorStyle = .singleLine
            cell.selectionStyle = .none
            
            return cell!
            
        } else if indexPath.section == 2 {
            let cell: CBDetailCell! = tableView.dequeueReusableCell(withIdentifier: "CBDetailCell") as? CBDetailCell
            
            cell.imgVRightArrow.isHidden = true
            cell.lblDetail.isHidden = true
            switch indexPath.row {
            case 0:
                cell.lblTitle.text = "Notification"
                cell.lblTitle.textColor = .black
                cell.imgVRightArrow.isHidden = false
                cell.lblDetail.isHidden = false
            case 1:
                cell.lblTitle.text = "Clear Chat"
                cell.lblTitle.textColor = .red
            case 2:
                cell.lblTitle.text = "Exit Group"
                cell.lblTitle.textColor = .red
            default:
                break
            }
            
            tableView.separatorStyle = .singleLine
            cell.selectionStyle = .none
            
            return cell!
        }
        return UITableViewCell()
    }
    
    /// View for footer in each section
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: UIView?
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    /// View for header in section
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: UIView?
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return uvHeaderInfo
        } else if section == 1 {
            return uvHeaderParticipants
        }
        return nil
    }
    
}

//MARK:- UITableViewDelegate
extension CBGroupDetailVC: UITableViewDelegate {
    
    /// Height for each row
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: CGFloat
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 60
        }
        return 80
        
    }
    
    /// Height for header in section
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: CGFloat
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 180
        } else if section == 1 {
            return 80
        }
        return 0
    }
    
    /// Height for footer in section
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: CGFloat
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    /// Selected a row from table
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK:-
//MARK: Table Cell
//MARK:
class CBDetailCell: UITableViewCell {
    @IBOutlet weak var imgVRightArrow: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
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
