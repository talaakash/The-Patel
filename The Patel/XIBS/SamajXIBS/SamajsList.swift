//
//  SamajsList.swift
//  The Patel
//
//  Created by Akash on 11/03/24.
//

import UIKit

class SamajsList: UITableViewCell {

    @IBOutlet weak var samajImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
