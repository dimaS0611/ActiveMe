  //
  //  SleepClassifier.swift
  //  ActiveMe WatchKit Extension
  //
  //  Created by Dima Semenovich on 8.05.22.
  //

import Foundation
import CoreML
import Combine
import CoreMotion

extension SleepClassifier {
  struct ModelConstants {
    static let numOfFeatures = 5
    static let sensorUpdateFrequency = 1.0
    static let predictionWindowSize = 165
    static let stateInWindowSize = 400
    static let classLabels: [String: String] = ["stage0" : "awake",
                                                "stage1" : "n1",
                                                "stage2" : "n2",
                                                "stage3" : "n3", // deep sleep
                                                "stage5" : "REM"]
  }
}

final class SleepClassifier: ObservableObject {
  // MARK: Classifier entities
  private let classifier = try? SleepClassifierNN(contentsOf: SleepClassifierNN.urlOfModelInThisBundle)
  private let modelName: String = "Sleep Classifier"
  private var currentIndexInPredictionWindow = 0
  
  
  @Published var pause: Bool = false
  
  // MARK: Process values
  @Published var sleepStage: String = ""
  @Published private var currentHeartRate: Double = 70
  @Published private var lastStepsRecord: Int = 0
  @Published private var stepsCount: Int = 0  {
    didSet(newValue) {
      lastStepsRecord = abs(newValue - stepsCount)
    }
  }
  
  // MARK: Classification data
  private let heartRate = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize as NSNumber], dataType: MLMultiArrayDataType.double)
  
  private let stepCount = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize as NSNumber], dataType: MLMultiArrayDataType.double)
  
  private let moveX = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize as NSNumber], dataType: MLMultiArrayDataType.double)
  private let moveY = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize as NSNumber], dataType: MLMultiArrayDataType.double)
  private let moveZ = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize as NSNumber], dataType: MLMultiArrayDataType.double)
  
  private var stateIn = try? MLMultiArray(shape: [ModelConstants.stateInWindowSize as NSNumber], dataType: MLMultiArrayDataType.double)
  
  private let predictionWindowDataArray = try? MLMultiArray(shape: [1, ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
  
  private var startWindowRecordingDate = Date()
  private var endWindowRecordingDate = Date()
  
  // MARK: Supportion managers
  private var workoutManager: WorkoutManager
  
  private var motionManager: MotionManager
  
  private var sleepDataProcessor: SleepDataProcessor
  
  private var disposeBag = Set<AnyCancellable>()
  
  private var processDataQueue = DispatchQueue(label: "processDataQueue", qos: .userInitiated)
  
  init(workoutManager: WorkoutManager,
       motionManager: MotionManager,
       sleepDataProcessor: SleepDataProcessor) {
    self.workoutManager = workoutManager
    self.motionManager = motionManager
    self.sleepDataProcessor = sleepDataProcessor
  }
  
  func startClassification() {
    bindInputs()
    observeMotionData()
  }
  
  func stopClassification() {
    motionManager.stopDeviceMotion()
    sleepDataProcessor.saveSession()
    sleepDataProcessor.pushToPhone()
  }
  
  func toggleClassification() {
    if pause {
      resumeClassification()
    } else {
      pauseClassification()
    }
  }
  
  private func pauseClassification() {
    pause = true
    motionManager.stopDeviceMotion()
  }
  
  private func resumeClassification() {
    pause = false
    observeMotionData()
  }
  
  private func bindInputs() {
    workoutManager
      .$heartRate
      .receive(on: DispatchQueue.main)
      .assign(to: \.currentHeartRate, on: self)
      .store(in: &disposeBag)
    
    workoutManager
      .$lastStepsRecord
      .receive(on: DispatchQueue.main)
      .assign(to: \.stepsCount, on: self)
      .store(in: &disposeBag)
  }
  
  private func observeMotionData() {
    motionManager.startDeviceMotion().startAccelerometerUpdates(to: .main) { data, error in
      guard let data = data else { return }
      self.addDataToArray(motionSample: data)
    }
  }
  
  private func addDataToArray(motionSample: CMAccelerometerData) {
    processDataQueue.async { [weak self] in
      guard let self = self else { return }
      self.moveX?[self.currentIndexInPredictionWindow] = motionSample.acceleration.x as NSNumber
      self.moveY?[self.currentIndexInPredictionWindow] = motionSample.acceleration.y as NSNumber
      self.moveZ?[self.currentIndexInPredictionWindow] = motionSample.acceleration.z as NSNumber
      self.heartRate?[self.currentIndexInPredictionWindow] = self.currentHeartRate / 100 as NSNumber
      self.stepCount?[self.currentIndexInPredictionWindow] = self.lastStepsRecord as NSNumber
      
      debugPrint("current Index window: \(self.currentIndexInPredictionWindow)")
      debugPrint("curent hr: \(self.currentHeartRate)")
      debugPrint("curent steps: \(self.lastStepsRecord)")
      
      DispatchQueue.main.async {
        self.lastStepsRecord = 0
      }
      
      self.currentIndexInPredictionWindow += 1
      
      self.checkClassificationPosibility()
    }
  }
  
  private func checkClassificationPosibility() {
    if currentIndexInPredictionWindow == ModelConstants.predictionWindowSize {
      self.endWindowRecordingDate = Date()
      self.currentIndexInPredictionWindow = 0
      
      if let prediction = activityPrediction() {
        DispatchQueue.main.async {
          self.sleepStage = prediction
          self.sleepDataProcessor.appendData(SleepStage(stage: prediction,
                                                        startTime: self.startWindowRecordingDate,
                                                        endTime: self.endWindowRecordingDate))
          
          print("classification label: \(prediction)")
        }
      }
      
      self.startWindowRecordingDate = Date()
    }
  }
  
  private func activityPrediction() -> String? {
    guard let heartRate = heartRate,
          let stepsCount = stepCount,
          let moveX = moveX,
          let moveY = moveY,
          let moveZ = moveZ,
          let stateIn = stateIn
    else { return "data array is empty!" }
    
    debugPrint("classification started")
    
    let modelPrediction = try? classifier?.prediction(heart_rate: heartRate,
                                                      step_count: stepsCount,
                                                      x_move: moveX,
                                                      y_move: moveY,
                                                      z_move: moveZ,
                                                      stateIn: stateIn)
    
    debugPrint("classification label: \(String(describing: modelPrediction?.label))")
    self.stateIn = modelPrediction?.stateOut
    return ModelConstants.classLabels[modelPrediction?.label ?? ""]
  }
}
