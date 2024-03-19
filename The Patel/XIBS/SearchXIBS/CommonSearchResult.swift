//
//  CommonSearchResult.swift
//  The Patel
//
//  Created by Akash on 07/03/24.
//

import UIKit

class CommonSearchResult: UITableViewCell {

    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var searchTitle: UILabel!
    @IBOutlet weak var searchLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
