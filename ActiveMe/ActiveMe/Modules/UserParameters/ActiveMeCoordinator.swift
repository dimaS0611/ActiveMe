//
//  ActiveMeCoordinator.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 28.11.21.
//

import Foundation
import UIKit

class ActiveMeCoordinator: BaseCoordinator {
    var router: RouterProtocol?
    
    lazy var startViewController: UIViewController? = {
        let view = UserParametersView()
        view.viewModel = UserParametersViewModel()
        return view
    }()
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    override func start() {
        
    }
}

extension ActiveMeCoordinator: Drawable {
    var viewController: UIViewController? { return startViewController }
}
