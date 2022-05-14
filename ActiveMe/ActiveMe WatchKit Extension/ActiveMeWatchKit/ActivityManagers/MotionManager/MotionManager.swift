  //
  //  MotionManager.swift
  //  ActiveMe WatchKit Extension
  //
  //  Created by Dima Semenovich on 8.05.22.
  //

import Foundation
import CoreMotion

final class MotionManager {
  static let shared = MotionManager()
  
  private let motionManager = CMMotionManager()
  
  func stopDeviceMotion() {
    motionManager.stopDeviceMotionUpdates()
    motionManager.stopAccelerometerUpdates()
  }
  
  func startDeviceMotion() -> CMMotionManager {
    stopDeviceMotion()
    
    debugPrint("Core Motion started!")
    
    motionManager.accelerometerUpdateInterval = 1.0
    
    motionManager.showsDeviceMovementDisplay = true
    
    return motionManager
  }
}
