//
//  AppViewModel.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 8.05.22.
//

import SwiftUI
import Combine
import WatchConnectivity

final class AppViewModel: ObservableObject {
  @Published var connectivityProvider: PhoneConnectionProvider
  @Published var healthStore: HealthStore

  @Published var rings: [Ring] = [
    Ring(progress: 72, value: "Steps", keyIcon: "figure.walk", keyColor: Color("highlighter")),
    Ring(progress: 36, value: "Calories", keyIcon: "flame.fill", keyColor: Color("primary")),
    Ring(progress: 91, value: "Sleep time", keyIcon: "😴", keyColor: Color("secondary"), isText: true)
  ]

  @Published var steps: [Step] = [
    Step(value: 500, key: "1-4 AM"),
    Step(value: 100, key: "5-8 AM", color: Color("secondary")),
    Step(value: 50, key: "9-11 AM"),
    Step(value: 200, key: "12-4 PM", color: Color("secondary")),
    Step(value: 250, key: "5-8 PM"),
    Step(value: 600, key: "9-12 PM", color: Color("secondary")),
  ]

  @Published var stepsCount: String = ""

  let numberFormatter = NumberFormatter()
  
  private var disposeBag = Set<AnyCancellable>()
  
  init() {
    self._connectivityProvider = Published(wrappedValue: PhoneConnectionProvider())
    self._healthStore = Published(wrappedValue: HealthStore())
    if WCSession.isSupported() {
      self.connectivityProvider.connect()
    }
    bindInputs()

    numberFormatter.numberStyle = .decimal
    numberFormatter.usesGroupingSeparator = true
    numberFormatter.groupingSeparator = ","
    numberFormatter.groupingSize = 3
    numberFormatter.maximumFractionDigits = 0
  }
  
  private func bindInputs() {
    connectivityProvider
      .$receivedSleepClassification
      .receive(on: DispatchQueue.main)
      .sink { [weak self] data in
        self?.saveReceivedData(data)
        LocalNotification.shared.dataHasRecorded()
      }
      .store(in: &disposeBag)
  }

  func fetchHealthDataForDate(_ date: Date) {
    healthStore.requestAuthorization { [weak self] success in
      guard let self = self else { return }
      if success {
        self.healthStore.getSteps(date: date) { steps in
          self.healthStore.steps = steps
          DispatchQueue.main.async {
            self.rings[0] = Ring(progress: (steps / 10000) * 100, value: "Steps", keyIcon: "figure.walk", keyColor: Color("highlighter"))
            self.stepsCount = self.numberFormatter.string(from: steps as NSNumber) ?? ""
          }
        }

        self.healthStore.getCalories(date: date) { energy in
          self.healthStore.energyBurned = energy
          DispatchQueue.main.async {
            self.rings[1] = Ring(progress: (energy / 660) * 100, value: "Calories", keyIcon: "flame.fill", keyColor: Color("primary"))
          }
        }
      }
    }

    let sleepDuration = fetchSleepDataForDate(date: date).map { $0.duration }.reduce(0, +)
    self.rings[2] = Ring(progress: CGFloat(Double(sleepDuration) / (8 * 3600)) * 100, value: "Sleep time", keyIcon: "😴", keyColor: Color("secondary"), isText: true)
  }

  func fetchStepsDataForDate(_ date: Date) {
    healthStore.requestAuthorization { [weak self] success in
      guard let self = self else { return }
      if success {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
        let dates = self.dates(fromStart: start, toEnd: end ?? Date(), component: .hour, value: 4)

        for stepIdx in 0..<6 {
          let startTime = dates[stepIdx]
          guard let endTime = dates[safe: stepIdx + 1] else { return }

          let startHH = Calendar.current.component(.hour, from: startTime)
          let endHH = Calendar.current.component(.hour, from: endTime)
          self.healthStore.getSteps(from: startTime, to: endTime) { steps in
            DispatchQueue.main.async {
              self.steps[stepIdx] = Step(value: steps, key: "\(startHH)-\(endHH)", color: stepIdx % 2 == 0 ?  Color("primary") : Color("secondary"))
            }
          }
        }
      }
    }
  }
  
  private func saveReceivedData(_ data: [SleepClassificationData]) {
    PersistenceController.shared.saveSleepData(data)
  }

  func fetchSleepDataForDate(date: Date) -> [SleepModel] {
    let stringDate = extractDate(date: date)
    let data = PersistenceController.shared.fetchRecordsForDate(dateString: stringDate)

    let filtered = data.filter { $0.sleepStage?.lowercased() != "awake" }

    return filtered.compactMap { datum -> SleepModel? in
      if let stage = datum.sleepStage,
         let start = datum.startTime,
         let end = datum.endTime {
        return SleepModel(stage: stage,
                          startTime: start,
                          endTime: end)
      } else {
        return nil
      }
    }
    .sorted(by: { $0.startTime < $1.endTime })

  }

  private func extractDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "MM/dd/yyyy"

    return formatter.string(from: date)
  }

  private func dates(fromStart start: Date,
             toEnd end: Date,
             component: Calendar.Component,
             value: Int) -> [Date] {
    var result = [Date]()
    var working = start
    repeat {
      result.append(working)
      guard let new = Calendar.current.date(byAdding: component, value: value, to: working) else { return result }
      working = new
    } while working <= end
    return result
  }
}
