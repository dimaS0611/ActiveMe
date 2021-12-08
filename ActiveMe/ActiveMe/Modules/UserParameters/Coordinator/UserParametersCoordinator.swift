//
//  GenderViewCoordinator.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 3.12.21.
//

import Foundation
import RxSwift
import UIKit

class UserParametersCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = GenderViewModel()
        let viewController = GenderView()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.interactivePopGestureRecognizer?.delegate = self

        viewController.viewModel = viewModel
        
        viewModel.showNextPage
            .subscribe { [weak self] _ in
                self?.showAgeView(in: navigationController)
            }.disposed(by: self.disposeBag)

        window.rootViewController = navigationController
        window.tintColor = UIColor(rgb: 0x178FB3)
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
}

extension UserParametersCoordinator {
    private func showHeightView(in navigationController: UINavigationController) {
        let parametersViewController = SliderParametersView(question: "Tell us your height", sliderRange: Range<Int>(100...250))
        parametersViewController.viewModel = SliderParametersViewModel()
        
        parametersViewController.viewModel?.showNextPage.subscribe(onNext: { [weak self] _ in
            self?.showWeightView(in: navigationController)
        }).disposed(by: self.disposeBag)
        
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        
        navigationController.pushViewController(parametersViewController, animated: true)
    }
    
    private func showWeightView(in navigationController: UINavigationController) {
        let parametersViewController = SliderParametersView(question: "Tell us your weight", sliderRange: Range<Int>(30...200))
        parametersViewController.viewModel = SliderParametersViewModel()
        
        parametersViewController.viewModel?.showNextPage.subscribe(onNext: { [weak self] _ in
            self?.coordinateToMainView()
        }).disposed(by: self.disposeBag)
        
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        
        navigationController.pushViewController(parametersViewController, animated: true)
    }
    
    private func showAgeView(in navigationController: UINavigationController) {
        let parametersViewController = SliderParametersView(question: "Tell us your age", sliderRange: Range<Int>(10...120))
        parametersViewController.viewModel = SliderParametersViewModel()
        
        parametersViewController.viewModel?.showNextPage.subscribe(onNext: { [weak self] _ in
            self?.showHeightView(in: navigationController)
        }).disposed(by: self.disposeBag)
        
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        
        navigationController.pushViewController(parametersViewController, animated: true)
    }
    
    private func coordinateToMainView() {
        coordinate(to: MainTabBarCoordinator(window: self.window))
    }
}

extension UserParametersCoordinator: UIGestureRecognizerDelegate {}
