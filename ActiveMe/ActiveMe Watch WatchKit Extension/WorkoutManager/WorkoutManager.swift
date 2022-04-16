//
//  WorkoutManager.swift
//  ActiveMe Watch WatchKit Extension
//
//  Created by Dzmitry Semenovich on 10.04.22.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {

  let healthStore = HKHealthStore()
  private var session: HKWorkoutSession?
  var builder: HKLiveWorkoutBuilder?

  @Published var showingSummaryView: Bool = false {
      didSet {
          if showingSummaryView == false {
              resetWorkout()
          }
      }
  }

  // The app's workout state.
  @Published var workoutHasStarted = false

  // MARK: - Workout Metrics
  @Published var heartRate: Double = 0
  @Published var averageHeartRate: Double = 0

  @Published var totalStepsCount: Int = 0
  @Published var stepsCount: Int = 0 {
    didSet(newValue) {
      totalStepsCount += newValue
    }
  }
  
  @Published var workout: HKWorkout?

  func requestAuthorization() {
    let typeToShare : Set = [
      HKQuantityType.workoutType()
    ]

    let typesToRead: Set = [
      HKQuantityType.quantityType(forIdentifier: .heartRate)!,
      HKQuantityType.quantityType(forIdentifier: .stepCount)!,
    ]

    healthStore.requestAuthorization(toShare: typeToShare, read: typesToRead) { success, error in
      if let error = error {
        debugPrint(error.localizedDescription)
      } else {
        debugPrint("Authorization was succesfully")
      }
    }
  }

  func startWorkoutTracking() {
    let configuration = HKWorkoutConfiguration()
    configuration.activityType = .other
    configuration.locationType = .indoor

    do {
      session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
      builder = session?.associatedWorkoutBuilder()
    } catch let error {
      debugPrint(error.localizedDescription)
      return
    }

    session?.delegate = self
    builder?.delegate = self

    // Set the workout builder's data source.
    builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                 workoutConfiguration: configuration)

    // Start the workout session and begin data collection.
    let startDate = Date()
    session?.startActivity(with: startDate)
    builder?.beginCollection(withStart: startDate) { success, error in
      if let error = error {
        debugPrint(error.localizedDescription)
      } else {
        debugPrint("The workout has started")
      }
    }
  }

  func updateForStatistics(_ statistics: HKStatistics?) {
      guard let statistics = statistics else { return }

      DispatchQueue.main.async {
          switch statistics.quantityType {
          case HKQuantityType.quantityType(forIdentifier: .heartRate):
              let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
              self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
              self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
          case HKQuantityType.quantityType(forIdentifier: .stepCount):
            let countUnit = HKUnit.count()
            self.stepsCount = Int(statistics.mostRecentQuantity()?.doubleValue(for: countUnit) ?? 0)
          default:
            print(statistics.quantityType.debugDescription)
          }
      }
  }

  func togglePause() {
      if workoutHasStarted == true {
          self.pause()
      } else {
          resume()
      }
  }

  func pause() {
      session?.pause()
  }

  func resume() {
      session?.resume()
  }

  func endWorkout() {
      session?.end()
      showingSummaryView = true
  }

  func resetWorkout() {
      builder = nil
      workout = nil
      session = nil
      heartRate = 0
      stepsCount = 0
  }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
  func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
    DispatchQueue.main.async {
      self.workoutHasStarted = toState == .running
    }

    // Wait for the session to transition states before ending the builder.
    if toState == .ended {
        builder?.endCollection(withEnd: date) { (success, error) in
            self.builder?.finishWorkout { (workout, error) in
                DispatchQueue.main.async {
                    self.workout = workout
                }
            }
        }
    }
  }

  func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
  }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
  func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
    for type in collectedTypes {
        guard let quantityType = type as? HKQuantityType else {
            return // Nothing to do.
        }

        let statistics = workoutBuilder.statistics(for: quantityType)

        // Update the published values.
        updateForStatistics(statistics)
    }
  }

  func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
  }
}
