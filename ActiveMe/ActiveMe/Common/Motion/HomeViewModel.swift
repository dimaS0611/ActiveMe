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
    
    func viewDidDisappear()
}

class HomeViewModel: HomeViewModelProtocol  {
    private let disposeBag = DisposeBag()
   // private let model: ActivityClassifierProtocol = ActivityClassifier()
    private let pedometer = PedometerManager()
    var labelPrediction: PublishSubject<String>
    var accelerationData: PublishSubject<(Double, Double, Double)>
    
    init() {
        self.labelPrediction = PublishSubject<String>()
        self.accelerationData = PublishSubject<(Double, Double, Double)>()
        
        setupBinding()
    }
    
    private func setupBinding() {
        pedometer.startActivityUpdater()
        pedometer.startPedometerUpdater()
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
    
    func viewDidDisappear() {
    //    model.stopClassifying()
    }
}
