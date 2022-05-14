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
  
  func initWithData(startTime: Date,
                    endTime: Date,
                    date: Date,
                    sleepStage: String) {
    self.startTime = startTime
    self.endTime = endTime
    self.date = date
    self.sleepStage = sleepStage
  }
  
  public required convenience init?(coder: NSCoder) {
    guard let startTime = coder.decodeObject(forKey: "start_time") as? Date,
          let endTime = coder.decodeObject(forKey: "end_time") as? Date,
          let date = coder.decodeObject(forKey: "date") as? Date,
          let sleepStage = coder.decodeObject(forKey: "sleep_stage") as? String
    else {
      return nil
    }
    
    self.init()
    self.initWithData(startTime: startTime,
                      endTime: endTime,
                      date: date,
                      sleepStage: sleepStage)
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(self.startTime, forKey: "start_time")
    coder.encode(self.endTime, forKey: "end_time")
    coder.encode(self.date, forKey: "date")
    coder.encode(self.sleepStage, forKey: "sleep_stage")
  }
}
