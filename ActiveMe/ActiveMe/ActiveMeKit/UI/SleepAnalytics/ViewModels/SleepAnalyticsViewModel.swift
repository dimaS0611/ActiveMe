//
//  SleepAnalyticsViewModel.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import Foundation
import Combine
import SwiftUI

class SleepAnalyticsViewModel: ObservableObject {
  @Published var stagesDuration: [String: Int] = [:]
  @Published var sleepQuality: Int = 0
  @Published var sleepEnough: Bool = false
  @Published var sleepAtTime: Bool = false

  @Binding var sleepData: [SleepModel]
  private var sleepDuration: Int = 0

  init(sleepData: Binding<[SleepModel]>) {
    self._sleepData = sleepData

    calculateDuration()
    initStagesDuration()
    calculateQuality()
  }

  func refresh() {
    calculateDuration()
    initStagesDuration()
    calculateQuality()
  }

  func calculateDuration() {
    sleepDuration = sleepData.map { $0.duration }.reduce(0, +)
  }

  func initStagesDuration() {
    var stages: [String: Int] = [:]
    for datum in sleepData {
      if let keyExists = stages[datum.stage] {
        stages[datum.stage] = keyExists + datum.duration
      } else {
        stages[datum.stage] = datum.duration
      }
    }

    self.stagesDuration = stages
  }

  func calculateQuality() {
    var nrem = 0
    var rem = 0

    stagesDuration.forEach { key, value in
      switch key.lowercased() {
      case "n1", "n2", "n3":
        nrem += value
      case "rem":
        rem = value
      default:
        break
      }
    }

    let remPercent = Double(rem) / (120 * 60)
    let nremPercent = Double(nrem) / (360 * 60)

    let quality = Int(((remPercent * 0.6) + (nremPercent * 0.4)) * 100)
    sleepQuality = quality > 100 ? 100 : quality

    let date = findStart()
    let calendar = Calendar.current

    let hour = calendar.component(.hour, from: date)

    sleepAtTime = hour < 22

    let durationHours = secondsToHoursMinutes(sleepDuration)
    sleepEnough = durationHours.0 >= 7
  }

  private func findStart() -> Date {
    let min = sleepData.min { lhs, rhs in
      return lhs.startTime < rhs.startTime
    }?.startTime

    return min ?? Date()
  }

  private func secondsToHoursMinutes(_ seconds: Int) -> (Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60)
  }
}
