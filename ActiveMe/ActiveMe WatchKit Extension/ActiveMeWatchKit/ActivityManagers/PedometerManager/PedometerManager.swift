  //
  //  PedometerManager.swift
  //  ActiveMe WatchKit Extension
  //
  //  Created by Dima Semenovich on 8.05.22.
  //
import Foundation
import CoreMotion
import Combine

final class PedometerManager: ObservableObject {
  private let activityManager = CMMotionActivityManager()
  private let pedometer = CMPedometer()
  private let motion = MotionManager.shared
  
  @Published var pedometerCounter: Int = 0
  @Published var lastStepsRecord: Int = 0
  @Published var accelerationData: (Double, Double, Double)?
  @Published var activityLabel: String = ""
}

extension PedometerManager {
  
  func resetUpdating() {
    activityManager.stopActivityUpdates()
    pedometer.stopEventUpdates()
    motion.stopDeviceMotion()
  }
  
  func startActivityUpdater() {
    self.activityManager.startActivityUpdates(to: OperationQueue.main) { activity in
      guard let activity = activity else { return }
      var activityLabel = ""
      if activity.stationary {
        print("stationary")
        activityLabel = "standing"
      } else if activity.walking {
        print("walking")
        activityLabel = "walking"
      } else if activity.running {
        print("running")
        activityLabel = "running"
      } else if activity.automotive {
        print("automative")
        activityLabel = "automative"
      }
      self.activityLabel = activityLabel
    }
  }
  
  func startPedometerUpdater() {
    if CMPedometer.isStepCountingAvailable() {
        self.pedometer.startUpdates(from: Date()) { data, error in
          guard let pedometerData = data, error == nil else {
            print(error?.localizedDescription as Any)
            return
          }
          
          self.lastStepsRecord = pedometerData.numberOfSteps.intValue
        }
    }
  }
  
  func startAccelerationDataUpdater() {
    motion.startDeviceMotion().startAccelerometerUpdates(to: .main) { data, error in
      guard let data = data else { return }
      
      self.accelerationData = (data.acceleration.x,
                                    data.acceleration.y,
                                    data.acceleration.z)
    }
  }
  
  func getPedometerData(since: Date, completion: @escaping (Result<CMPedometerData, Error>) -> (Void)) {
    pedometer.queryPedometerData(from: since, to: Date()) { data, error in
      if let error = error {
        print(error.localizedDescription as Any)
        completion(.failure(error))
        return
      }
      guard let data = data else { return }
      completion(.success(data))
    }
  }
}
