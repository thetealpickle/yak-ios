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
        if AuthService.instance.isLoggedIn {
            let user = UserDataService.instance
            socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
            completion(true)
        }
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
}
