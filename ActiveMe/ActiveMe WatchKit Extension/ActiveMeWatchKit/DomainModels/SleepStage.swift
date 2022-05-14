//
//  SleepStage.swift
//  ActiveMe WatchKit Extension
//
//  Created by Dima Semenovich on 8.05.22.
//

import Foundation

struct SleepStage: Identifiable, Equatable {
  var id = UUID()
  
  var stage: String
  var startTime: Date
  var endTime: Date
  
  var plainType: PlainType {
    .init(rawValue: stage) ?? .awake
  }
  
  enum PlainType: String {
    case n1
    case n2
    case n3
    case rem
    case awake
    
    case none
    
    init?(rawValue: String) {
      switch rawValue{
      case "n1", "stage1":
        self = .n1
      case "n2", "stage2":
        self = .n2
      case "n3", "stage3":
        self = .n3
      case "awake", "stage0":
        self = .awake
      case "rem", "stage5":
        self = .rem
      default:
        self = .none
      }
    }
  }
}
