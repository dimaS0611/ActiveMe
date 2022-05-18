//
//  Data Processor.swift
//  ActiveMe WatchKit Extension
//
//  Created by Dima Semenovich on 8.05.22.
//

import Foundation

class SleepDataProcessor {
  var connectionProvider: WatchConnectionProvider
  var sleepData = [SleepStage]()
  let sessionId = UUID()
  
  init(connectionProvider: WatchConnectionProvider) {
    self.connectionProvider = connectionProvider
  }
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, h:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
  
  func appendData(_ stage: SleepStage) {
    if sleepData.isEmpty {
      sleepData.append(stage)
    }
    
    guard let lastRecord = sleepData.last,
          let lastIndex = sleepData.firstIndex(of: lastRecord)
    else { return }
    
    if lastRecord.plainType == stage.plainType {
      let newRecord = SleepStage(stage: stage.stage,
                                 startTime: lastRecord.startTime,
                                 endTime: stage.endTime,
                                 sessionId: sessionId,
                                 stringDate: extractDate(date: Date()))
      sleepData[lastIndex] = newRecord
      
      print("Merge last stage: \(lastRecord.stage) \(dateFormatter.string(from: lastRecord.startTime)) \(dateFormatter.string(from:lastRecord.endTime))")
      print("And new stage: \(stage.stage) \(dateFormatter.string(from: stage.startTime)) \(dateFormatter.string(from:stage.endTime))")
      print("Result: \(sleepData[lastIndex].stage) \(dateFormatter.string(from: sleepData[lastIndex].startTime)) \(dateFormatter.string(from:sleepData[lastIndex].endTime))")
    } else {
      sleepData.append(stage)
    }
  }
  
  func saveSession() {
    let dataToSave = sleepData.map {
      SleepStage(stage: $0.stage,
                 startTime: $0.startTime,
                 endTime: $0.endTime,
                 sessionId: sessionId,
                 stringDate: extractDate(date: Date()))
    }
    WatchPersistenceController.shared.saveSleepData(dataToSave)
  }
  
  func pushToPhone() {
    let msg = sleepData.map { data -> SleepClassificationData in
      let obj = SleepClassificationData()
      obj.initWithData(startTime: data.startTime,
                       endTime: data.endTime,
                       date: Date(),
                       sleepStage: data.stage,
                       sessionId: data.sessionId ?? UUID(),
                       stringDate: extractDate(date: Date()))
      return obj
    }
    if !msg.isEmpty {
      let archiver = NSKeyedArchiver(requiringSecureCoding: true)
      guard let _ = try? archiver.encodeEncodable(msg, forKey: NSKeyedArchiveRootObjectKey)
      else {
        debugPrint("Unable to archive data")
        return
      }
      archiver.finishEncoding()
      connectionProvider.sendWatchMessage(archiver.encodedData, messageType: .sleepStage)
    }
  }

  func extractDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "MM/dd/yyyy"

    return formatter.string(from: date)
  }
}
