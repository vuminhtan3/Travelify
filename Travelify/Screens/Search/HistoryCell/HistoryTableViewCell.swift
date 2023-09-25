//
//  HistoryTableViewCell.swift
//  Travelify
//
//  Created by Minh Tan Vu on 12/09/2023.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var placeNameLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        placeNameLb.text = nil
    }
    
    func bindData(placeName: String) {
        self.placeNameLb.text = placeName
    }
}
