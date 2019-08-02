//
//  ASChatCell.swift
//  LowRateInsuranceAgency
//
//  Created by softobiz on 1/11/18.
//  Copyright © 2018 Ankit_Saini. All rights reserved.
//

import UIKit

class ASChatCell: UITableViewCell {

    
    @IBOutlet weak var uvReceiverView: UIView!
    @IBOutlet weak var uvSenderView: UIView!
    //@IBOutlet weak var imgReceiver: ASImageView!
    @IBOutlet weak var lblMsgReceiver: UILabel!
    @IBOutlet weak var lblDateReceiver: UILabel!
    @IBOutlet weak var uvReceiverMsgBG: ASView!
    @IBOutlet weak var lblReceiverName: UILabel!
    
    
    @IBOutlet weak var uvSenderMsgBG: ASView!
    //@IBOutlet weak var imgSender: ASImageView!
    @IBOutlet weak var lblMSGSender: UILabel!
    @IBOutlet weak var lblDateSender: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
