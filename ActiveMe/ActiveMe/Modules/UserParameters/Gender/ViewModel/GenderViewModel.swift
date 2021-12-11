//
//  UserParametersViewModel.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 28.11.21.
//

import Foundation
import RxSwift

protocol GenderViewModelProtocol: AnyObject {
    var chooseGender: PublishSubject<Gender> { get set }
}

class GenderViewModel: GenderViewModelProtocol {
    let disposeBag = DisposeBag()
    
    var chooseGender: PublishSubject<Gender>
    var showNextPage: Observable<Gender>
    
    init() {
        self.chooseGender = PublishSubject<Gender>()
        self.showNextPage = chooseGender.asObservable()
        
        setupBinding()
    }
    
    private func setupBinding() {
        self.chooseGender.subscribe { [weak self] gender in
            guard let gender = gender.element else { return }
            UserDefaultsManager.saveObject(for: .genderValue, value: gender)
        }.disposed(by: self.disposeBag)

    }
}
