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
}

class HomeViewModel: HomeViewModelProtocol  {
    private let disposeBag = DisposeBag()
    private let model = ActivityClassifier()
    
    var labelPrediction: PublishSubject<String>
    var accelerationData: PublishSubject<(Double, Double, Double)>
    
    init() {
        self.labelPrediction = PublishSubject<String>()
        self.accelerationData = PublishSubject<(Double, Double, Double)>()
        
        setupBinding()
    }
    
    private func setupBinding() {
        self.model.prediction.subscribe { [weak self] prediction in
            self?.labelPrediction.onNext(prediction)
        }.disposed(by: self.disposeBag)

        self.model.accelerationData.subscribe { [weak self] data in
            self?.accelerationData.onNext(data)
        }.disposed(by: self.disposeBag)
    }
}
