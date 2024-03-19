//
//  PublicDiscussions.swift
//  The Patel
//
//  Created by Akash on 12/03/24.
//

import UIKit

class PublicDiscussions: UITableViewCell {

    @IBOutlet weak var discussionImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var sender: UILabel!
    @IBOutlet weak var message: UILabel!
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
