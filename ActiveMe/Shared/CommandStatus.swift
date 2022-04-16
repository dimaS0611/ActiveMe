//
//  CommandStatus.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 27.03.22.
//

import Foundation

// Constants to identify the Watch Connectivity methods, also used as user-visible strings in UI.
//
enum Command: String {
    case updateAppContext = "UpdateAppContext"
    case sendMessage = "SendMessage"
    case sendMessageData = "SendMessageData"
    case transferUserInfo = "TransferUserInfo"
    case transferFile = "TransferFile"
    case transferCurrentComplicationUserInfo = "TransferComplicationUserInfo"
}

// Constants to identify the phrases of a Watch Connectivity communication.
//
enum Phrase: String {
    case updated = "Updated"
    case sent = "Sent"
    case received = "Received"
    case replied = "Replied"
    case transferring = "Transferring"
    case canceled = "Canceled"
    case finished = "Finished"
    case failed = "Failed"
}

struct CommandStatus {
    var command: Command
    var phrase: Phrase
    var errorMessage: String?
    
    init(command: Command, phrase: Phrase) {
        self.command = command
        self.phrase = phrase
    }
}
