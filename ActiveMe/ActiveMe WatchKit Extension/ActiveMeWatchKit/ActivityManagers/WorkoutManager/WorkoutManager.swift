  //
  //  WorkoutManager.swift
  //  ActiveMe WatchKit Extension
  //
  //  Created by Dima Semenovich on 8.05.22.
  //

import Foundation
import HealthKit
import Combine
import SwiftUI

class WorkoutManager: NSObject, ObservableObject {
  
  let healthStore = HKHealthStore()
  var builder: HKLiveWorkoutBuilder?
  private var session: HKWorkoutSession?
  private var pedometer = PedometerManager()
  
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
  @Published var heartRate: Double = 70
  @Published var averageHeartRate: Double = 0
  @Published var lastStepsRecord: Int = 0
  
  @Published var workout: HKWorkout?
  
  private var disposeBag = Set<AnyCancellable>()
  
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
    
    pedometer.startPedometerUpdater()
    
    pedometer
      .$lastStepsRecord
      .receive(on: DispatchQueue.main)
      .assign(to: \.lastStepsRecord, on: self)
      .store(in: &disposeBag)
  }
  
  func updateForStatistics(_ statistics: HKStatistics?) {
    guard let statistics = statistics else { return }
    
    DispatchQueue.main.async {
      switch statistics.quantityType {
      case HKQuantityType.quantityType(forIdentifier: .heartRate):
        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
        self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
      default:
        break
      }
    }
  }
  
  func togglePause() {
    if workoutHasStarted {
      WKInterfaceDevice.current().play(.stop)
      pause()
    } else {
      WKInterfaceDevice.current().play(.start)
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
    lastStepsRecord = 0
    pedometer.resetUpdating()
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
