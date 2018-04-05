//  Created by Jessica Joseph on 4/4/18.
//  Copyright © 2018 TFH Inc. All rights reserved.

import UIKit

@IBDesignable
class CircleImage: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}
