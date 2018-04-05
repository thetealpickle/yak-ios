//  Created by Jessica Joseph on 4/5/18.
//  Copyright © 2018 TFH Inc. All rights reserved.

import UIKit

class ProfileController: UIViewController {

    //Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func closeTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        usernameLabel.text = UserDataService.instance.name
        userEmailLabel.text = UserDataService.instance.email
        profileImageView.image = UIImage(named: UserDataService.instance.avatarName)
        profileImageView.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeTap))
        self.bgView.addGestureRecognizer(closeTouch)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE , object: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
