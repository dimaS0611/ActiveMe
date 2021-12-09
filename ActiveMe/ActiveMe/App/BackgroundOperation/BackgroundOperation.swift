//
//  BackgroundOperation.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/8/21.
//

import Foundation
import RxSwift

class BackgroundOperation {
    static func getOperationsToFetchLatestEntries() -> [Operation] {
        let pedometer = BackgroudPedometer()
        let activityClassifier = BackgroundActivityClassifier()
        
        return [pedometer,
                 activityClassifier]
    }
}

class BackgroudPedometer: Operation {
    
    private let pedometer = PedometerManager.shared
    private let disposeBag = DisposeBag()
    private let storage = StorageService()
    
    override func main() {
        pedometer.startPedometerUpdater()
        pedometer.pedometerCounter.subscribe { [weak self] pedometer in
            self?.storage.storeSteps(model: StepsStorable(date: Date(),
                                                          start: pedometer.1,
                                                          end: pedometer.2,
                                                          steps: pedometer.0))
        }.disposed(by: self.disposeBag)
    }
}

class BackgroundActivityClassifier: Operation {
    
    private let activityClassifier = ActivityClassifier.shared
    private let disposeBag = DisposeBag()
    private let storage = StorageService()
    
    override func cancel() {
        super.cancel()
        activityClassifier.stopClassifying()
    }
    
    override func main() {
        activityClassifier.startClassifying()
        
        activityClassifier.prediction.subscribe { [weak self] prediction in
            self?.storage.storeActivity(model: ActivityStorable(date: Date(),
                                                                start: prediction.1,
                                                                end: prediction.2,
                                                                activity: prediction.0))
        }.disposed(by: self.disposeBag)
    }
}
