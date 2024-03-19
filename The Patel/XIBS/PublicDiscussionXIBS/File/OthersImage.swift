//
//  OthersImage.swift
//  The Patel
//
//  Created by Akash on 14/03/24.
//

import UIKit

class OthersImage: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
