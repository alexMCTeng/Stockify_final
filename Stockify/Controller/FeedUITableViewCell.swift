//
//  FeedUITableViewCell.swift
//  Stockify
//
//  Created by Liam on 11/28/20.
//  Copyright © 2020 Group24. All rights reserved.
//

import UIKit

class FeedUITableViewCell: UITableViewCell {

    @IBOutlet weak var upDownGraphic: UIImageView!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func set_percent_change(change : Float) {
        timeLabel.text = "\(round(abs(change) * 100.0) / 100.0)%"
        if change > 0 {
            // set the image to be positive arrow
            upDownGraphic.image = UIImage(systemName: "arrowtriangle.up.fill")
            upDownGraphic.tintColor = UIColor.green
        } else {
            // set the image to be negative arrow
            upDownGraphic.image = UIImage(systemName: "arrowtriangle.down.fill")
            upDownGraphic.tintColor = UIColor.red
        }
    }
    
    func set_ticker(ticker : String) {
        tickerLabel.text = ticker
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // set the time
        var currentTime: String {
            Date().description(with: .current)
        }
        timeLabel.text = currentTime
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
