//
//  HomeViewModel.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/6/21.
//

import Foundation
import RxSwift

protocol HomeViewModelProtocol: AnyObject {
    var labelPrediction: PublishSubject<String> { get }
    var accelerationData: PublishSubject<(Double, Double, Double)> { get }
    var stepsPerTime: PublishSubject<[DateInterval : Int]> { get }
    
    func viewDidDisappear()
    func obtainSetpsPerTime(date: Date) -> [DateInterval : Int]
}

class HomeViewModel: HomeViewModelProtocol  {
    private let disposeBag = DisposeBag()
    private let activity: ActivityClassifierProtocol = ActivityClassifier.shared
    private let model: HomeModelProtocol = HomeModel()
    private let pedometer = PedometerManager.shared
    
    var labelPrediction: PublishSubject<String>
    var accelerationData: PublishSubject<(Double, Double, Double)>
    var stepsPerTime: PublishSubject<[DateInterval : Int]>
    
    init() {
        self.labelPrediction = PublishSubject<String>()
        self.accelerationData = PublishSubject<(Double, Double, Double)>()
        self.stepsPerTime = PublishSubject<[DateInterval : Int]>()
        
        setupBinding()
    }
    
    private func setupBinding() {
        pedometer.startActivityUpdater()
        
        pedometer.startPedometerUpdater()
        
       // activity.startClassifying()

//        self.model.prediction
//            .subscribe(on: MainScheduler.instance)
//            .subscribe { [weak self] prediction in
//                self?.labelPrediction.onNext(prediction)
//            }.disposed(by: self.disposeBag)
//
//        self.model.accelerationData
//            .subscribe(on: MainScheduler.instance)
//            .subscribe { [weak self] data in
//                self?.accelerationData.onNext(data)
//            }.disposed(by: self.disposeBag)
    }
    
    func obtainSetpsPerTime(date: Date) -> [DateInterval : Int] {
        pedometer.getPedometerDataSinceLastSession { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
        return self.model.obtainStepsPerTime(date: date)
    }
    
    func viewDidDisappear() {
    //    model.stopClassifying()
    }
}
