//  Created by Jessica Joseph on 4/3/18.
//  Copyright © 2018 TFH Inc. All rights reserved. c

import UIKit

class ChannelController: UIViewController {

    //Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImageView: CircleImage!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            userImageView.image = UIImage(named: UserDataService.instance.avatarName)
            userImageView.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginButton.setTitle("Login", for: .normal)
            userImageView.image = UIImage(named: "menuProfileIcon")
            userImageView.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
}
