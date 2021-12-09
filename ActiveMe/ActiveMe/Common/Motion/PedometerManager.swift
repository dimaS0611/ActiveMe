//
//  PedometerManager.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/8/21.
//

import Foundation
import CoreMotion
import RxSwift

protocol PedometerDelegate: AnyObject {
    var pedometerCounter: PublishSubject<(Int,Date,Date)> { get }
    
    func startActivityUpdater()
    func startPedometerUpdater()
}

class PedometerManager {
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    var pedometerCounter = PublishSubject<(Int, Date, Date)>()
    
    static let shared = PedometerManager()
    
    private init() {}
}

extension PedometerManager: PedometerDelegate {
    
    func startActivityUpdater() {
        self.activityManager.startActivityUpdates(to: OperationQueue.main) { activity in
            guard let activity = activity else { return }
            
            DispatchQueue.main.async {
                if activity.stationary {
                    print("stationary")
                } else if activity.walking {
                    print("walking")
                } else if activity.running {
                    print("running")
                } else if activity.automotive {
                    print("automative")
                }
            }
        }
    }
    
    func startPedometerUpdater() {
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { data, error in
                guard let pedometerData = data, error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    self.pedometerCounter.onNext((pedometerData.numberOfSteps.intValue, pedometerData.startDate, pedometerData.endDate))
                    print("start: \(pedometerData.startDate)")
                    print("end: \(pedometerData.endDate)")
                    print("steps: \(pedometerData.numberOfSteps.intValue)")
                }
            }
        }
    }
}
