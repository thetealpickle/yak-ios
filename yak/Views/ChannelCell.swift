//  Created by Jessica Joseph on 4/5/18.
//  Copyright © 2018 TFH Inc. All rights reserved.

import UIKit
import UserNotifications

class ChannelCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var channelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel) {
        let title = channel.channelTitle ?? ""
        channelLabel.text = "#\(title)"
        channelLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        for id in MessageService.instance.unreadChannels {
            if id == channel.id {
                channelLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
    
            }
        }
    }
}
