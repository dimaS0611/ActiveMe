//
//  HeightViewModel.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 3.12.21.
//

import Foundation
import RxSwift

protocol SliderParametersViewModelProtocol {
    var chooseValue: PublishSubject<Int> { get set }
    var showNextPage: Observable<Int> {get set }
}

class SliderParametersViewModel: SliderParametersViewModelProtocol {
    let disposeBag = DisposeBag()
    
    var chooseValue: PublishSubject<Int>
    var showNextPage: Observable<Int>
    
    init() {
        self.chooseValue = PublishSubject<Int>()
        self.showNextPage = chooseValue.asObservable()
        
        setupBinding()
    }
    
    private func setupBinding() {
        self.chooseValue.subscribe { [weak self] value in
            print(value)
        }.disposed(by: self.disposeBag)
    }
}
