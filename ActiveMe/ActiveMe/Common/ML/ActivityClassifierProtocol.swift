//
//  ActivityClassifierProtocol.swift
//  ActiveMe
//
//  Created by Dzmitry Semianovich on 12/6/21.
//

import Foundation
import RxSwift

protocol ActivityClassifierProtocol: AnyObject {
    var prediction: PublishSubject<(String, Date, Date)> { get }
    var accelerationData: PublishSubject<(Double, Double, Double)> { get }
    
    func stopClassifying()
    func startClassifying()
}
