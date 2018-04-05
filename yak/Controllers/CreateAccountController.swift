//  Created by Jessica Joseph on 4/3/18.
//  Copyright © 2018 TFH Inc. All rights reserved.

import UIKit

class CreateAccountController: UIViewController {

    // Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImageView.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") && bgColor == nil {
                userImageView.backgroundColor = UIColor.darkGray
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupView() {
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        spinner.isHidden = true
    }
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    @IBAction func createAccountPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let name = usernameTextField.text, usernameTextField.text != "" else {
            return
        }
        guard let email = emailTextField.text , emailTextField.text != "" else {
            return
        }
        
        guard let password = passwordTextField.text , passwordTextField.text != "" else {
            return
        }
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("user registered")
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        print("user logged in")
                        print(self.avatarColor)
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                })
                
                
            }
        }
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255))/255
        let g = CGFloat(arc4random_uniform(255))/255
        let b = CGFloat(arc4random_uniform(255))/255
        
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b)]"
        print(avatarColor)
        UIView.animate(withDuration: 0.2) {
            self.userImageView.backgroundColor = self.bgColor
        }
    }
}
