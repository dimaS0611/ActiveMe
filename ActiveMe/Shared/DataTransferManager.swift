//
//  DataTransferManager.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 27.03.22.
//

import Foundation
import WatchConnectivity

protocol DataTransferManager {
    func sendMessage(_ message: [String: Any])
    func sendMessageData(_ messageData: Data)
    func cancel()
    func cancel(notifying command: Command)
}

extension DataTransferManager {
    // Send a message if the session is activated and update UI with the command status.
    //
    func sendMessage(_ message: [String: Any]) {
        var commandStatus = CommandStatus(command: .sendMessage, phrase: .sent)
        
        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: commandStatus)
        }
        
        WCSession.default.sendMessage(message, replyHandler: { replyMessage in
            if let response = replyMessage["response"] as? String {
                print(response)
            }
            commandStatus.phrase = .replied
            postNotification(.dataDidFlow, command: commandStatus)
        }, errorHandler: { error in
            commandStatus.phrase = .failed
            commandStatus.errorMessage = error.localizedDescription
            self.postNotification(.dataDidFlow, command: commandStatus)
        })
    }
    
    // Send  a piece of message data if the session is activated and update UI with the command status.
    //
    func sendMessageData(_ messageData: Data) {
        var commandStatus = CommandStatus(command: .sendMessageData, phrase: .sent)
        
        guard WCSession.default.activationState == .activated else {
            return handleSessionUnactivated(with: commandStatus)
        }

        WCSession.default.sendMessageData(messageData, replyHandler: { replyData in
            commandStatus.phrase = .replied
            postNotification(.dataDidFlow, command: commandStatus)

        }, errorHandler: { error in
            commandStatus.phrase = .failed
            commandStatus.errorMessage = error.localizedDescription
            postNotification(.dataDidFlow, command: commandStatus)
        })
        postNotification(.dataDidFlow, command: commandStatus)
    }
    
    func cancel(notifying command: Command) {
        let commandStatus = CommandStatus(command: command, phrase: .canceled)
        
        cancel()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .dataDidFlow, object: commandStatus)
        }
    }
    
    private func postNotification(_ notification: Notification.Name, command: CommandStatus) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: notification, object: command)
        }
    }
    
    private func handleSessionUnactivated(with commandStatus: CommandStatus) {
        var mutableStatus = commandStatus
        mutableStatus.phrase = .failed
        mutableStatus.errorMessage =  "WCSession is not activeted yet!"
        postNotification(.dataDidFlow, command: commandStatus)
    }
}
