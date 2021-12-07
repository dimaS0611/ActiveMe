//
//  ActivityClassifier.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/5/21.
//

import Foundation
import CoreML
import CoreMotion
import RxSwift

extension ActivityClassifier {
    struct ModelConstants {
        static let numOfFeatures = 3
        static let sensorUpdateFrequency = 1.0 / 80
        static let predictionWindowSize = 240
        static let hiddenInLenght = 20
        static let hiddenCellInLenghth = 200
        static let classLabels: [Int: String] = [0 : "Downstairs",
                                                  1 : "Jogging",
                                                  2 : "Sitting",
                                                  3 : "Standing",
                                                  4 : "Upstairs",
                                                  5 : "Walking"]
    }
}

class ActivityClassifier: ActivityClassifierProtocol {
    private let classifier = try? HARClassifier(contentsOf: HARClassifier.urlOfModelInThisBundle)
    private let modelName: String = "HARClassifier"
    private var currentIndexInPredictionWindow = 0
    
    let lock = NSRecursiveLock()
    
    private let accX = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize as NSNumber], dataType: MLMultiArrayDataType.float32)
    
    private let accY = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize as NSNumber], dataType: MLMultiArrayDataType.float32)
    
    private let accZ = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize as NSNumber], dataType: MLMultiArrayDataType.float32)
    
    let predictionWindowDataArray = try? MLMultiArray(shape: [1, ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.float32)
    
    var prediction = PublishSubject<String>()
    var accelerationData = PublishSubject<(Double, Double, Double)>()
    
    init() {
        startClassifying()
    }
    
    private func startClassifying() {
        MotionManager.shared.startDeviceMotion().startAccelerometerUpdates(to: .main) { data, error in
            guard let data = data else { return }
            
            self.addDataToArray(motionSample: data)
        }
    }
    
    func stopClassifying() {
        MotionManager.shared.stopDeviceMotion()
    }
    
    private func addDataToArray(motionSample: CMAccelerometerData) {
        guard let dataArray = predictionWindowDataArray else { return }
        
        DispatchQueue.global(qos: .utility).async {
            dataArray[[0, ModelConstants.numOfFeatures * self.currentIndexInPredictionWindow] as [NSNumber]] = motionSample.acceleration.x as NSNumber
            dataArray[[0, ModelConstants.numOfFeatures * self.currentIndexInPredictionWindow + 1] as [NSNumber]] = motionSample.acceleration.y as NSNumber
            dataArray[[0, ModelConstants.numOfFeatures * self.currentIndexInPredictionWindow + 2] as [NSNumber]] = motionSample.acceleration.z as NSNumber
            
            self.currentIndexInPredictionWindow += 1
            
            self.lock.lock()
            DispatchQueue.main.async {
                self.accelerationData.onNext((motionSample.acceleration.x,
                                              motionSample.acceleration.y,
                                              motionSample.acceleration.z))
            }
            self.lock.unlock()
            
            if self.currentIndexInPredictionWindow * 3 == ModelConstants.predictionWindowSize {
                DispatchQueue.main.async {
                    if let prediction = self.activityPrediction() {
                        self.prediction.onNext(prediction)
                    }
                }
                
                self.currentIndexInPredictionWindow = 0
            }
        }
    }
    
    private func activityPrediction() -> String? {
        guard let data = predictionWindowDataArray else { return "data array is empty!" }
        
        let modelPrediction = try? classifier?.prediction(input: HARClassifierInput(reshape_input: data))
        
        guard let length = modelPrediction?.Identity.count
        else {
            return "Failed to get length of array"
        }
        
        let doublePtr =  modelPrediction?.Identity.dataPointer.bindMemory(to: Double.self, capacity: length)
        let doubleBuffer = UnsafeBufferPointer(start: doublePtr, count: length)
        let convertedArray = Array(doubleBuffer)
        
        guard let maxProbability = convertedArray.max(by: { $0 > $1 }),
            let maxIdx = convertedArray.firstIndex(where: { $0 == maxProbability })
        else {
            return "Failed to find max idx!"
        }

        return ModelConstants.classLabels[maxIdx]
    }
}
