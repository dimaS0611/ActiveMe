//
//  UserParametersViewModel.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 28.11.21.
//

import Foundation
import RxSwift

protocol UserParametersViewModelProtocol {
    var didTapBack: (() -> ())? { get set }
    var didSelect: (() -> ())? { get set}
}

class UserParametersViewModel: UserParametersViewModelProtocol {
    var didTapBack: (() -> ())?
    
    var didSelect: (() -> ())?
    
    
    
    
}
