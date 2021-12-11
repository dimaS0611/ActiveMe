//
//  HeightViewModel.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 3.12.21.
//

import Foundation
import RxSwift

protocol SliderParametersViewModelProtocol {
    var chooseValue: PublishSubject<(Int, SliderQuestionType)> { get set }
    var showNextPage: Observable<(Int, SliderQuestionType)> {get set }
}

class SliderParametersViewModel: SliderParametersViewModelProtocol {
    let disposeBag = DisposeBag()
    
    var chooseValue: PublishSubject<(Int, SliderQuestionType)>
    var showNextPage: Observable<(Int, SliderQuestionType)>
    
    init() {
        self.chooseValue = PublishSubject<(Int, SliderQuestionType)>()
        self.showNextPage = chooseValue.asObservable()
        
        setupBinding()
    }
    
    private func setupBinding() {
        self.chooseValue.subscribe { [weak self] value in
            guard let value = value.element else { return }
            switch value.1 {
            case .height:
                UserDefaultsManager.saveObject(for: .heightValue, value: value.0)
            case .age:
                UserDefaultsManager.saveObject(for: .ageValue, value: value.0)
            case .weight:
                UserDefaultsManager.saveObject(for: .weightValue, value: value.0)
            }
        }.disposed(by: self.disposeBag)
    }
}
