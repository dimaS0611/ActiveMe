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
    private let storage = StorageService()
    
    var pedometerCounter = PublishSubject<(Int, Date, Date)>()
    
    let lock = NSRecursiveLock()
    
    static let shared = PedometerManager()
    
    private init() {}
}

extension PedometerManager: PedometerDelegate {
    
    func startActivityUpdater() {
        self.activityManager.startActivityUpdates(to: OperationQueue.main) { activity in
            guard let activity = activity else { return }
            var activityLabel = ""
            DispatchQueue.main.async {
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
            }
            
            self.lock.lock()
            DispatchQueue.global(qos: .utility).async {
                self.storage.storeActivity(model: ActivityStorable(date: Date(),
                                                                   start: activity.startDate,
                                                                   end: Calendar.current.date(byAdding: .second,
                                                                                              value: 1,
                                                                                              to: activity.startDate)!,
                                                                   activity: activityLabel))
            }
            self.lock.unlock()
        }
    }
    
    func startPedometerUpdater() {
        if CMPedometer.isStepCountingAvailable() {
            DispatchQueue.global(qos: .utility).async {
                self.pedometer.startUpdates(from: Date()) { data, error in
                    guard let pedometerData = data, error == nil else {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    self.lock.lock()
                    DispatchQueue.global(qos: .utility).async {
                        self.storage.storeSteps(model: StepsStorable(date: Date(),
                                                                     start: pedometerData.startDate,
                                                                     end: pedometerData.endDate,
                                                                     steps: pedometerData.numberOfSteps.intValue))
                    }
                    self.lock.unlock()
                }
            }
        }
    }
    
    func getPedometerDataSinceLastSession(completion: @escaping (Result<CMPedometerData, Error>) -> (Void)) {
        guard let lastSession = UserDefaultsManager.getObject(for: .endOfLastSession) as? Date else { return }
        
        pedometer.queryPedometerData(from: lastSession, to: Date()) { data, error in
            if let error = error {
                print(error.localizedDescription as Any)
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            DispatchQueue.global(qos: .utility).async {
                self.storage.storeSteps(model: StepsStorable(date: Date(),
                                                             start: data.startDate,
                                                             end: data.endDate,
                                                             steps: data.numberOfSteps.intValue))
            }
            
            completion(.success(data))
        }
    }
}
