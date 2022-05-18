//
//  SleepGraph.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import Foundation
import SwiftUI

struct SleepGraphModel: Identifiable, Hashable {
  var id = UUID()
  var stage: String = ""
  var duration: Int = 0
  var percent: Int = 0
  var durationStringFormat: String = ""
  var color: Color {
    stageColor[stage.lowercased()] ?? Color("primary")
  }

  private var stageColor: [String: Color] = [
    "n1" : Color("primary"),
    "n2" : Color("secondary"),
    "n3" : Color("bgColorPurple"),
    "rem" : Color("highlighter")
  ]

  var plainType: SleepStageInfoViewModel.Stage {
    switch stage.lowercased() {
    case "n1":
      return .n1
    case "n2":
      return .n2
    case "n3":
      return .n3
    case "rem":
      return .rem
    default:
      return .n1
    }
  }
}
