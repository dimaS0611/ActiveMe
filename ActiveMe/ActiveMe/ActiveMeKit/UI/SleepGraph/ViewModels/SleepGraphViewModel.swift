//
//  SleepGraphViewModel.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import SwiftUI

class SleepGraphViewModel: ObservableObject {
  @Binding var data: [SleepModel]

  @Published var stagesGridData: [Int: [SleepGraphModel]] = [:]

  @Published var stagesDurationStringFormat: [String: String] = [:]

  @Published var stagesDuration: [String: Int] = [:]
  @Published var stagesPercents: [String: Int] = [:]

  private var sleepDuration: Int = 0
  let columnsCount: Int = 2

  init(data: Binding<[SleepModel]>) {
    self._data = data

    calculateDuration()
    initStagesDuration()
    initPercents()

    initGridData()
  }

  func refresh() {
    calculateDuration()
    initStagesDuration()
    initPercents()

    initGridData()
  }

  func initGridData() {
    var tmpGridData: [Int: [SleepGraphModel]] = [:]
    var columnIdx: Int = 0

    var graphModels = [SleepGraphModel]()
    stagesPercents.forEach { key, value in
      var model = SleepGraphModel()
      model.stage = key
      model.percent = value
      graphModels.append(model)
    }

    stagesDuration.forEach { key, value in
      if var model = graphModels.first(where: { $0.stage == key }) {
        model.duration = value
        if let idx = graphModels.firstIndex(of: model) {
          graphModels[idx] = model
        }
      }
    }

    stagesDurationStringFormat.forEach { key, value in
      if var model = graphModels.first(where: { $0.stage == key }) {
        model.durationStringFormat = value
        if let idx = graphModels.firstIndex(of: model) {
          graphModels[idx] = model
        }
      }
    }

    for graphModel in graphModels {
      if var model = tmpGridData[columnIdx] {
        model.append(graphModel)
        tmpGridData[columnIdx] = model
      } else {
        tmpGridData[columnIdx] = [graphModel]
      }
      columnIdx = columnIdx == 0 ? 1 : 0
    }

    self.stagesGridData = tmpGridData
  }

  func initStagesDuration() {
    var stages: [String: Int] = [:]
    for datum in data {
      if let keyExists = stages[datum.stage] {
        stages[datum.stage] = keyExists + datum.duration
      } else {
        stages[datum.stage] = datum.duration
      }
    }

    self.stagesDuration = stages

    var result: [String: String] = [:]
    stages.forEach { key, value in
      let time = secondsToHoursMinutes(value)
      result[key] = "\(time.0)h\(time.1)mm"
    }

    self.stagesDurationStringFormat = result
  }

  func initPercents() {
    var percents: [String: Int] = [:]

    stagesDuration.forEach { key, value in
      percents[key] = Int(Double((Double(value) / Double(sleepDuration))) * Double(100))
    }

    self.stagesPercents = percents
  }

  func calculateDuration() {
    sleepDuration = data.map { $0.duration }.reduce(0, +)
  }

  private func secondsToHoursMinutes(_ seconds: Int) -> (Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60)
  }
}
