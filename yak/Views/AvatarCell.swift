//  Created by Jessica Joseph on 4/4/18.
//  Copyright © 2018 TFH Inc. All rights reserved.

import UIKit

enum AvatarType {
    case dark
    case light
}

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configureCell(index: Int, type: AvatarType) {
        if type == AvatarType.dark {
            avatarImageView.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        } else  {
            avatarImageView.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.darkGray.cgColor
        }
    }
    
    func setupView() {
        self.layer.backgroundColor = UIColor.lightGray
        .cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
