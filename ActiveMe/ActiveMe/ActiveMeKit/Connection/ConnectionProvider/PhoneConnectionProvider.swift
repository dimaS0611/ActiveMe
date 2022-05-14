  //
  //  ConnectionProvider.swift
  //  ActiveMe
  //
  //  Created by Dima Semenovich on 8.05.22.
  //

import SwiftUI
import Combine
import WatchConnectivity

class PhoneConnectionProvider: NSObject, ObservableObject{
  
  private let session: WCSession
  
  var sleepTelemetry = [SleepTelemetry]()
  @Published var receivedSleepTelemetry = [SleepTelemetry]()
  
  var sleepClassification = [SleepClassificationData]()
  @Published var receivedSleepClassification = [SleepClassificationData]()
  
  
  @Published var messageReceived: String = "none"
  
  var lastMessage: CFAbsoluteTime = 0
  
  init(session: WCSession = .default) {
    self.session = session
    super.init()
    self.session.delegate = self
    
    print("Connection provider initialized on phone")
    
    self.connect()
  }
  
  func connect() {
    guard  WCSession.isSupported() else {
      debugPrint("WCSession is not supported")
      return
    }

    session.activate()
  }
}

// MARK: - WCSessionDelegate implementation
extension PhoneConnectionProvider: WCSessionDelegate {
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    debugPrint("Entered didReceiveMessage")
    if message["sleepStage"] != nil {
      guard let loadedData = message["sleepStage"] as? Data
      else {
        debugPrint("Invalid data received")
        return
      }
      
      NSKeyedUnarchiver.setClass(SleepClassificationData.self, forClassName: "SleepClassificationData")
      
      guard let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: loadedData) else {
        debugPrint("Unable to unarchive data")
        return
      }
      unarchiver.decodingFailurePolicy = .setErrorAndReturn
      let decoded = unarchiver.decodeDecodable([SleepClassificationData].self, forKey:
                                                          NSKeyedArchiveRootObjectKey)!
      unarchiver.finishDecoding()

      DispatchQueue.main.async {
        self.receivedSleepClassification = decoded
        debugPrint("Sleep telemetry received")
        self.messageReceived = "Success: received"
      }
    }
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
    self.session(session, didReceiveMessage: message)
    replyHandler(["response": "success"])
  }
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) {
    debugPrint("\(#function): activationState = \(session.activationState.rawValue)")
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
      // Activate the new session after having switched to a new watch.
    session.activate()
  }
}

extension PhoneConnectionProvider {
  enum MessageType: String {
    case sleepTelemetry = "sleepData"
    case sleepStage = "sleepStage"
  }
}
