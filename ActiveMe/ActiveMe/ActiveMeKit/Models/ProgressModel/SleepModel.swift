//
//  SleepModel.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import Foundation
import SwiftUI

struct SleepModel: Identifiable, Hashable {
  var id = UUID()
  var stage: String
  var startTime: Date
  var endTime: Date
  var duration: Int
  var color: Color = Color("primary")

  var stageColor: [String: Color] = [
    "n1" : Color("primary"),
    "n2" : Color("secondary"),
    "n3" : Color("bgColorPurple"),
    "rem" : Color("highlighter")
  ]

  init(stage: String,
       startTime: Date,
       endTime: Date) {
    self.stage = stage
    self.startTime = startTime
    self.endTime = endTime
    self.duration = Calendar.current.dateComponents([.second], from: startTime, to: endTime).second ?? 0
    self.color = stageColor[stage.lowercased()] ?? Color("primary")
  }
}

extension SleepModel {
  init(model: SleepClassificationData) {
    self.stage = model.sleepStage ?? "error"
    self.startTime = model.startTime ?? Date()
    self.endTime = model.endTime ?? Date()
    self.duration = Calendar.current.dateComponents([.second], from: startTime, to: endTime).second ?? 0
    self.color = stageColor[stage.lowercased()] ?? Color("primary")
  }
}

var sleep: [SleepModel] = [
  .init(stage: "N1", startTime: Date(), endTime: Date().addingTimeInterval(670)),
  .init(stage: "N2", startTime: Date().addingTimeInterval(671), endTime: Date().addingTimeInterval(1500)),
  .init(stage: "REM", startTime: Date().addingTimeInterval(1501), endTime: Date().addingTimeInterval(2000)),
  .init(stage: "N3", startTime: Date().addingTimeInterval(2001), endTime: Date().addingTimeInterval(2476)),
  .init(stage: "N2", startTime: Date().addingTimeInterval(2477), endTime: Date().addingTimeInterval(3700)),
]
