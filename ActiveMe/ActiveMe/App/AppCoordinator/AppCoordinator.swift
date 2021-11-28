//
//  AppCoordinator.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 28.11.21.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() {
        /// preparing root view
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        let coordinator = ActiveMeCoordinator(router: router)
        
        /// store child coordinator
        self.store(coordinator: coordinator)
        coordinator.start()
        
        router.push(coordinator, isAnimated: true) { [weak self, weak coordinator] in
            guard let self = self,
                  let coordinator = coordinator
            else { return }
            self.free(coordinator: coordinator)
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        
        /// delete when free it
        coordinator.isCompleted = { [weak self] in
            self?.free(coordinator: coordinator)
        }
    }
}
