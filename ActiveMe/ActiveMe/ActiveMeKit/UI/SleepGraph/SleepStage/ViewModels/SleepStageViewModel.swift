//
//  SleepGraphViewModel.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import SwiftUI

class SleepStageViewModel: ObservableObject {
  @Published var data: [SleepModel]
  @Published var guides: [String]

  private var sleepDuration: Int = 0

  let formatter = DateFormatter()

  init(data: Binding<[SleepModel]>) {
    self._data = Published(wrappedValue: data.wrappedValue)
    self.guides = []

    self.formatter.locale = Locale(identifier: "en_US_POSIX")
    self.formatter.dateFormat = "HH:mm"

    calculateDuration()
    self.guides = getGraphGuides()
  }

  func refresh() {
    calculateDuration()
    self.guides = getGraphGuides()
  }

  func calculateDuration() {
    sleepDuration = data.map { $0.duration }.reduce(0, +)
  }

  func getWidth(value: Double, availableWidth: CGFloat) -> CGFloat {
    let percent = value / Double(sleepDuration)
    let width = percent * (availableWidth - 20)

    return width
  }

  func processGestureLocation(_ location: CGFloat, availableWidth: CGFloat) -> UUID {
    var location = location
    let barWidths = calculateEachBarWidth(availableWidth: availableWidth)

    var id: UUID?

    for idx in data.indices {
      location -= barWidths[idx]

      if location <= 0 {
        id = data[idx].id
        break
      }
    }

    return id ?? data.last?.id ?? UUID()
  }

  func calculateEachBarWidth(availableWidth: CGFloat) -> [CGFloat] {
    var blocks: [CGFloat] = []

    for block in data {
      let percent = Double(block.duration) / Double(sleepDuration)
      let width = percent * (availableWidth - 20)
      blocks.append(width)
    }

    return blocks
  }

  func getGraphGuides() -> [String] {
    let lastTime = getLastTime()
    let firstTime = getFirstTime()

    let middle = sleepDuration / 2
    let middleTime = Calendar.current.date(byAdding: .second, value: middle, to: firstTime)

    var guides: [String] = []

    guides.append(formatter.string(from: firstTime))
    if let middleTime = middleTime {
      guides.append(formatter.string(from: middleTime))
    }
    guides.append(formatter.string(from: lastTime))

    return guides
  }

  private func getLastTime() -> Date {
    let max = data.max { lhs, rhs in
      return rhs.endTime > lhs.endTime
    }

    return max?.endTime ?? Date()
  }

  private func getFirstTime() -> Date {
    let min = data.min { lhs, rhs in
      return lhs.startTime < rhs.startTime
    }

    return min?.startTime ?? Date()
  }
}
