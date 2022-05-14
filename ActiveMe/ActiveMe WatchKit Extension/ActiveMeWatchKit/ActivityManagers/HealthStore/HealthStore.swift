//
//  HealthStore.swift
//  ActiveMe WatchKit Extension
//
//  Created by Dima Semenovich on 8.05.22.
//

import Foundation
import HealthKit

class HealthStore {
  
  var healthStore: HKHealthStore?
  var stepsQuery: HKStatisticsCollectionQuery?
  
  init() {
    if HKHealthStore.isHealthDataAvailable() {
      healthStore = HKHealthStore()
    }
  }
  
  func calculateSteps(startDate: Date, endDate: Date, completion: @escaping (HKStatisticsCollection?) -> Void) {
    let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    
    stepsQuery = HKStatisticsCollectionQuery(quantityType: stepType,
                                             quantitySamplePredicate: predicate,
                                             options: .cumulativeSum,
                                             anchorDate: Date(),
                                             intervalComponents: DateComponents(second: 1))
    
  }
  
  func requestAuthorization(completion: @escaping (Bool) -> Void) {
    let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    
    guard let healthStore = healthStore else {
      return completion(false)
    }

    healthStore.requestAuthorization(toShare: [],
                                     read: [stepType, heartRateType]) { success, error in
      completion(success)
    }
  }
}
