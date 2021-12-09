//
//  BackgroundOperation.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/8/21.
//

import Foundation
import RxSwift
import NotificationCenter

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
    }
}
