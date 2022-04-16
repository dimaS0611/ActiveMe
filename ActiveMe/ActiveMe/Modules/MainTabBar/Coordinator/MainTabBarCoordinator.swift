//
//  MainTabBarConfigurator.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 4.12.21.
//

import UIKit
import RxSwift

class MainTabBarCoordinator: BaseCoordinator<Void> {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewController =  MainTabBarView()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        window.tintColor = UIColor(rgb: 0x178FB3)
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
}
