  //
  //  SleepTelemetry.swift
  //  ActiveMe
  //
  //  Created by Dima Semenovich on 8.05.22.
  //

import SwiftUI

public final class SleepTelemetry: NSObject, ObservableObject, NSSecureCoding {
  
  public static var supportsSecureCoding: Bool = true
  
  let id = UUID()
  @Published var heartRate: Double?
  @Published var moveX: Double?
  @Published var moveY: Double?
  @Published var moveZ: Double?
  @Published var stepsCount: Int?
  @Published var time: Date?
  
  func initWithData(heartRate: Double,
                    moveX: Double,
                    moveY: Double,
                    moveZ: Double,
                    stepsCount: Int,
                    time: Date) {
    self.heartRate = heartRate
    self.moveX = moveX
    self.moveY = moveY
    self.moveZ = moveZ
    self.stepsCount = stepsCount
    self.time = time
  }
  
  public required convenience init?(coder: NSCoder) {
    guard let heartRate = coder.decodeObject(forKey: "heart_rate") as? Double,
          let moveX = coder.decodeObject(forKey: "move_x") as? Double,
          let moveY = coder.decodeObject(forKey: "move_y") as? Double,
          let moveZ = coder.decodeObject(forKey: "move_z") as? Double,
          let stepsCount = coder.decodeObject(forKey: "steps_count") as? Int,
          let time = coder.decodeObject(forKey: "time") as? Date
    else {
      return nil
    }
    
    self.init()
    self.initWithData(heartRate: heartRate,
                      moveX: moveX,
                      moveY: moveY,
                      moveZ: moveZ,
                      stepsCount: stepsCount,
                      time: time)
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(self.heartRate, forKey: "heart_rate")
    coder.encode(self.moveX, forKey: "move_x")
    coder.encode(self.moveY, forKey: "move_y")
    coder.encode(self.moveZ, forKey: "move_z")
    coder.encode(self.stepsCount, forKey: "steps_count")
    coder.encode(self.time, forKey: "time")
  }
}
