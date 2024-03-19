//
//  FilterSearch.swift
//  The Patel
//
//  Created by Akash on 06/03/24.
//

import UIKit

class FilterSearch: UICollectionViewCell {

    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        filterView.borderColor = UIColor.clear
    }

}
