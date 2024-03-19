//
//  OthersMessage.swift
//  The Patel
//
//  Created by Akash on 13/03/24.
//

import UIKit

class OthersMessage: UITableViewCell {

    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var messageView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setWidth(width: CGFloat){
//        messageView.widthAnchor.constraint(lessThanOrEqualToConstant: width).isActive = true
//        messageView.layoutIfNeeded()
    }
}
