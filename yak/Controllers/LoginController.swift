//  Created by Jessica Joseph on 4/3/18.
//  Copyright © 2018 TFH Inc. All rights reserved.

import UIKit

class LoginController: UIViewController {

    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinnerActivity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        spinnerActivity.isHidden = true
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    @IBAction func loginPressed(_ sender: Any) {
        spinnerActivity.isHidden = false
        spinnerActivity.startAnimating()
        
        guard let email = emailTextField.text , emailTextField.text != ""  else { return }
        guard let password = passwordTextField.text , passwordTextField.text != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinnerActivity.isHidden = true
                        self.spinnerActivity.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
}
