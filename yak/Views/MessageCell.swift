//  Created by Jessica Joseph on 4/5/18.
//  Copyright © 2018 TFH Inc. All rights reserved.

import UIKit

class MessageCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var userImageView: CircleImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(message: Message) {
        messageBodyLabel.text = message.message
        userNameLabel.text = message.username
        userImageView.image = UIImage(named: message.userAvatar)
        userImageView.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
    }
}
