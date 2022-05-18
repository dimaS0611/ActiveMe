//
//  WatchConnectionProvider.swift
//  ActiveMe WatchKit Extension
//
//  Created by Dima Semenovich on 11.05.22.
//

import SwiftUI
import Combine
import WatchConnectivity

class WatchConnectionProvider: NSObject, ObservableObject {
  
  private let session: WCSession
  
  var lastMessage: CFAbsoluteTime = 0
  
  init(session: WCSession = .default) {
    self.session = session
    super.init()
    self.session .delegate = self
    
    print("Connection provider initialized on watch")
    
    self.connect()
  }
  
  func connect() {
    guard  WCSession.isSupported() else {
      debugPrint("WCSession is not supported")
      return
    }
    
    session.activate()
  }
  
  func send(message: [String: Any]) {
    session.sendMessage(message, replyHandler: nil) { error in
      debugPrint(error.localizedDescription)
    }
  }
  
  func sendWatchMessage(_ msgData: Data, messageType: MessageType) {
    let currentTime = CFAbsoluteTimeGetCurrent()
    
    if lastMessage + 0.5 > currentTime {
      return
    }
    
    if session.isReachable {
      debugPrint("Sending Watch Message")
      let message = [messageType.rawValue : msgData]
      session.sendMessage(message,
                          replyHandler: { _ in
        print("Message received")
      }) { error in
        debugPrint(error.localizedDescription)
      }
      
      lastMessage = CFAbsoluteTimeGetCurrent()
    }
  }
}

  // MARK: - WCSessionDelegate implementation
extension WatchConnectionProvider: WCSessionDelegate {
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
  }
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
}

extension WatchConnectionProvider {
  enum MessageType: String {
    case sleepTelemetry = "sleepData"
    case sleepStage = "sleepStage"
  }
}
