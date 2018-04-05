//  Created by Jessica Joseph on 4/3/18.
//  Copyright © 2018 TFH Inc. All rights reserved. c

import UIKit

class ChannelController: UIViewController {

    //Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImageView: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelsLoaded), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    @objc func channelsLoaded() {
        tableView.reloadData()
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
    }
    
    func setupUserInfo() {
        if AuthService.instance.isLoggedIn {
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            userImageView.image = UIImage(named: UserDataService.instance.avatarName)
            print(UserDataService.instance.avatarColor)
            userImageView.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginButton.setTitle("Login", for: .normal)
            userImageView.image = UIImage(named: "menuProfileIcon")
            userImageView.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            // Show profile page
            let profile = ProfileController()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func addChannelPressed(_ sender: Any) {
        let addChannel = AddChannelController()
        addChannel.modalPresentationStyle = .custom
        
        present(addChannel, animated: true, completion: nil)
    }
}

extension ChannelController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        self.revealViewController().revealToggle(animated: true)
    }
}
