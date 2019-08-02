//
//  CBMessageListVC.swift
//  SwiftProject
//
//  Created by Ankit Saini on 02/07/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import UIKit

class CBMessageListVC: ASBaseVC {
    @IBOutlet weak var tblMain: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ///
        ///Nav Bar
        ///
        self.navigationItem.title = "Messages"
        self.navigationController?.navigationBar.setColors(background: .fbColor, text: .white)
    }
    
    @IBAction func actNewChat(_ sender: UIButton) {
    }
    @IBAction func actNewGroup(_ sender: UIButton) {
        guard let vc = Storyboard.group.viewController(viewControllerClass: CBSelectUserVC.self) else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK:- TableView Datasource
//MARK:
extension CBMessageListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CBMessageListCell! = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CBMessageListCell
        
        let font1 = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        let font2 = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        
//        let attachment: NSTextAttachment = NSTextAttachment()
//        attachment.image = #imageLiteral(resourceName: "new_contact")
//        let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
//        let attStr = "Albert Nicholas".attriString.setAtt({ (make) in
//            make.font = font1
//            make.color = UIColor.black
//            make.lineSpacing = 5.0
//        }).append(string: "\nHello, How are you?".attriString.setAtt({ (make) in
//            make.font = font2
//            make.color = UIColor.darkGray
//        })).append(string: attachmentString)
        
        ///
        ///Setup Title and message
        let attStr = "Albert Nicholas".attributtedString(appendString: "\nHello, How are you?", color1: .black, color2: .darkGray, font1: font1, font2: font2, lineSpacing: 5)
        cell.lblTitle.attributedText = attStr
        cell.lblTitle.numberOfLines = 0
        
        ///
        ///Setup Date
        cell.lblDate.text = Date().toString(format: .isoDate)
        
        tableView.separatorStyle = .singleLine
        cell.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

//MARK:- UITableViewDelegate
extension CBMessageListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = Storyboard.chat.viewController(viewControllerClass: CBGroupChatVC.self) else { return }
        vc.kScreenFrom = .message
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:-
//MARK: Table Cell
//MARK:
class CBMessageListCell: UITableViewCell {
    @IBOutlet weak var imgVPic: ASImageView!
    @IBOutlet weak var uvOnline: ASView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
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
