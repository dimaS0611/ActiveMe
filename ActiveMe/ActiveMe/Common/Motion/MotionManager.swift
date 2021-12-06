//
//  MotionManager.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/5/21.
//

import Foundation
import CoreMotion

class MotionManager {
    static let shared = MotionManager()
    
    private let motionManager = CMMotionManager()
    
    func stopDeviceMotion() {
        guard motionManager.isDeviceMotionActive else {
            debugPrint("Core Motion Data Unavailable!")
            return
        }
        
        motionManager.stopDeviceMotionUpdates()
    }
    
    func startDeviceMotion() -> CMMotionManager {
        stopDeviceMotion()
        
        motionManager.startDeviceMotionUpdates()
        
        debugPrint("Core Motion started!")
        
        motionManager.accelerometerUpdateInterval = 1.0 / 80
        
        motionManager.showsDeviceMovementDisplay = true
        
        return motionManager
    }
    
}
