//
//  SleepClassification.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 8.05.22.
//

import Foundation

class SleepClassificationData: NSObject, ObservableObject, NSSecureCoding, Codable {
  
  public static var supportsSecureCoding: Bool = true
  
  var id: UUID = UUID()
  var startTime: Date?
  var endTime: Date?
  var date: Date?
  var sleepStage: String?
  var sessionId: UUID?
  var stringDate: String?
  
  func initWithData(startTime: Date,
                    endTime: Date,
                    date: Date,
                    sleepStage: String,
                    sessionId: UUID,
                    stringDate: String) {
    self.startTime = startTime
    self.endTime = endTime
    self.date = date
    self.sleepStage = sleepStage
    self.sessionId = sessionId
    self.stringDate = stringDate
  }
  
  public required convenience init?(coder: NSCoder) {
    guard let startTime = coder.decodeObject(forKey: "start_time") as? Date,
          let endTime = coder.decodeObject(forKey: "end_time") as? Date,
          let date = coder.decodeObject(forKey: "date") as? Date,
          let sleepStage = coder.decodeObject(forKey: "sleep_stage") as? String,
          let sessionId = coder.decodeObject(forKey: "session_id") as? UUID,
          let stringDate = coder.decodeObject(forKey: "string_date") as? String
    else {
      return nil
    }
    
    self.init()
    self.initWithData(startTime: startTime,
                      endTime: endTime,
                      date: date,
                      sleepStage: sleepStage,
                      sessionId: sessionId,
                      stringDate: stringDate)
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(self.startTime, forKey: "start_time")
    coder.encode(self.endTime, forKey: "end_time")
    coder.encode(self.date, forKey: "date")
    coder.encode(self.sleepStage, forKey: "sleep_stage")
    coder.encode(self.sessionId, forKey: "session_id")
    coder.encode(self.stringDate, forKey: "string_date")
  }
}
