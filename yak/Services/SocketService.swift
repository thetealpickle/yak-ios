//  Created by Jessica Joseph on 4/5/18.
//  Copyright © 2018 TFH Inc. All rights reserved.

import SocketIO
import UIKit

class SocketService: NSObject {
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!)
    lazy var socket : SocketIOClient = manager.defaultSocket
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion:@escaping CompletionHandler) {
            if AuthService.instance.isLoggedIn {
            socket.emit("newChannel", channelName, channelDescription)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion:@escaping CompletionHandler) {
            let user = UserDataService.instance
            socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
            completion(true)
    }
    
    func getChannel(completion:@escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArr, ack) in
            guard let channelName = dataArr[0] as? String else { return }
            guard let channelDesc = dataArr[1] as? String else { return }
            guard let channelId = dataArr[2] as? String else { return }

            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func getMessage(completion:@escaping CompletionHandler) {
        socket.on("messageCreated") { (dataArr, ack) in
            guard let messageBody = dataArr[0] as? String else { return }
            guard let channelId = dataArr[2] as? String else { return }
            guard let username = dataArr[3] as? String else { return }
            guard let userAvatar = dataArr[4] as? String else { return }
            guard let userAvatarColor = dataArr[5] as? String else { return }
            guard let messageId = dataArr[6] as? String else { return }
            guard let timeStamp = dataArr[7] as? String else { return }

            if channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                let newMessage = Message(id: messageId, message: messageBody, username: username, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timeStamp, channelId: channelId)
                
                MessageService.instance.messages.append(newMessage)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getTypingUsers(_ completionHandler:@escaping (_ typingUsers: [String:String]) -> Void) {
        socket.on("userTypingUpdate") { (dataArr, ack) in
            guard let typingUsers = dataArr[0] as? [String: String] else { return }
            completionHandler(typingUsers)
        }
    }
    
}
