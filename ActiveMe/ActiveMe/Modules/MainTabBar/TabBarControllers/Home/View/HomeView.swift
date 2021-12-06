//
//  HomeView.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 4.12.21.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

class HomeView: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let viewModel = HomeViewModel()
    
    lazy var prediction: UILabel = {
       let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        return label
    }()
    
    lazy var accData: UILabel = {
       let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        return label
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBlue
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       // viewModel.viewDidDisappear()
    }
    
    private func setupUI() {
        view.addSubview(prediction)
        view.addSubview(accData)
        
        setupConstraints()
        setupBinding()
    }
    
    private func setupConstraints() {
        prediction.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100.0)
        }
        
        accData.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(-50.0)
            make.height.equalTo(50.0)
            make.width.equalTo(150.0)
        }
    }
    
    private func setupBinding() {
        viewModel.labelPrediction
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] prediction in
                DispatchQueue.main.async {
                    self?.prediction.text = prediction
                }
            }.disposed(by: self.disposeBag)
        
        viewModel.accelerationData
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] data in
                guard let acc = data.element else { return }
                DispatchQueue.main.async {
                    self?.accData.text = "\(acc.0), \(acc.1), \(acc.2)"
                }
            }.disposed(by: self.disposeBag)
    }
}
