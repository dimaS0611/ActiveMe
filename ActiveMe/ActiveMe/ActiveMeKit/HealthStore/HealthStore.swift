//
//  HealthStore.swift
//  ActiveMe WatchKit Extension
//
//  Created by Dima Semenovich on 8.05.22.
//

import Foundation
import HealthKit

class HealthStore: ObservableObject {

  @Published var steps: Double = 0
  @Published var energyBurned: Double = 0

  var healthStore: HKHealthStore?
  var stepsQuery: HKStatisticsCollectionQuery?
  
  init() {
    if HKHealthStore.isHealthDataAvailable() {
      healthStore = HKHealthStore()
    }
  }

  func getCalories(date: Date, completion: @escaping (Double) -> Void) {
    let energySampleType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!

    let startOfDay = Calendar.current.startOfDay(for: date)
    let endOfDate = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
    let predicate = HKQuery.predicateForSamples(
      withStart: startOfDay,
      end: endOfDate,
      options: .strictStartDate
    )

    let query = HKStatisticsQuery(
      quantityType: energySampleType,
      quantitySamplePredicate: predicate,
      options: .cumulativeSum
    ) { _, result, _ in
      guard let result = result, let sum = result.sumQuantity() else {
        completion(0.0)
        return
      }
      completion(sum.doubleValue(for: HKUnit.kilocalorie()))
    }

    healthStore?.execute(query)
  }

  func getSteps(date: Date, completion: @escaping (Double) -> Void) {
    let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

    let startOfDay = Calendar.current.startOfDay(for: date)
    let endOfDate = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
    let predicate = HKQuery.predicateForSamples(
      withStart: startOfDay,
      end: endOfDate,
      options: .strictStartDate
    )

    let query = HKStatisticsQuery(
      quantityType: stepsQuantityType,
      quantitySamplePredicate: predicate,
      options: .cumulativeSum
    ) { _, result, _ in
      guard let result = result, let sum = result.sumQuantity() else {
        completion(0.0)
        return
      }
      completion(sum.doubleValue(for: HKUnit.count()))
    }

    healthStore?.execute(query)
  }

  func getSteps(from: Date, to: Date, completion: @escaping (Double) -> Void) {
    let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

    let predicate = HKQuery.predicateForSamples(
      withStart: from,
      end: to,
      options: .strictStartDate
    )

    let query = HKStatisticsQuery(
      quantityType: stepsQuantityType,
      quantitySamplePredicate: predicate,
      options: .cumulativeSum
    ) { _, result, _ in
      guard let result = result, let sum = result.sumQuantity() else {
        completion(0.0)
        return
      }
      completion(sum.doubleValue(for: HKUnit.count()))
    }

    healthStore?.execute(query)
  }

  func requestAuthorization(completion: @escaping (Bool) -> Void) {
    let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    let energyBurnedType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
    
    guard let healthStore = healthStore else {
      return completion(false)
    }

    healthStore.requestAuthorization(toShare: [],
                                     read: [stepType, heartRateType, energyBurnedType]) { success, error in
      completion(success)
    }
  }
}
