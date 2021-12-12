//
//  ActivityViewModel.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 6.12.21.
//

import Foundation
import RxSwift

protocol ActivityViewModelProtocol: AnyObject {
    var labelPrediction: PublishSubject<String> { get }
    var accelerationData: PublishSubject<(Double, Double, Double)> { get }
    
    func viewDidDisappear()
}

class ActivityViewModel: ActivityViewModelProtocol  {
    private let disposeBag = DisposeBag()
    private let model = ActivityClassifier.shared
    private let pedometer = PedometerManager.shared
    
    var labelPrediction: PublishSubject<String>
    var accelerationData: PublishSubject<(Double, Double, Double)>
    
    init() {
        self.labelPrediction = PublishSubject<String>()
        self.accelerationData = PublishSubject<(Double, Double, Double)>()
        
        startServices()
        setupBinding()
    }
    
    private func startServices() {
        pedometer.startActivityUpdater()
        pedometer.startAccelerationDataUpdater()
    }
    
    private func setupBinding() {

        self.pedometer.activityLabel
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] label in
                guard let label = label.element else { return }
                self?.labelPrediction.onNext(label)
            }.disposed(by: self.disposeBag)
        
        self.pedometer.accelerationData
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] data in
                self?.accelerationData.onNext(data)
            }.disposed(by: self.disposeBag)
    }
    
    func viewDidDisappear() {
        model.stopClassifying()
    }
}
