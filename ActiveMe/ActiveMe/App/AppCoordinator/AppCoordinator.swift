//
//  AppCoordinator.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 28.11.21.
//

import Foundation
import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        if UserDefaultsManager.getRegisterData() {
            let mainCoordinator = MainTabBarCoordinator(window: window)
            return coordinate(to: mainCoordinator)
        } else {
            let registerCoordinator = UserParametersCoordinator(window: window)
            return coordinate(to: registerCoordinator)
        }
        
    }
}
