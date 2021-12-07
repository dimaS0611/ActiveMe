//
//  ActivityView.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 4.12.21.
//

import Foundation
import UIKit
import CorePlot
import RxSwift

class ActivityView: UIViewController {
    
    let accXGraph = GraphView(identifier: "acc x")
    
    let accYGraph = GraphView(identifier: "acc y")
    
    let accZGraph = GraphView(identifier: "acc z")
    
    let viewModel = ActivityViewModel()
    
    let disposeBag = DisposeBag()
    
    lazy var activityPrediction: UILabel = {
       let label = UILabel()
        label.font = UIFont.regular(with: 17.0)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGray6
        setupUI()
        setupBinding()
    }
    
    private func setupUI() {
        view.addSubview(accXGraph)
        view.addSubview(accYGraph)
        view.addSubview(accZGraph)
        view.addSubview(activityPrediction)
        
        accXGraph.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.lessThanOrEqualTo(200.0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5.0)
        }
        
        accYGraph.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.lessThanOrEqualTo(200.0)
            make.top.equalTo(accXGraph.snp.bottom).inset(5.0)
        }

        accZGraph.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.lessThanOrEqualTo(200.0)
            make.top.equalTo(accYGraph.snp.bottom).inset(5.0)
        }
        
        activityPrediction.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10.0)
            make.leading.trailing.equalToSuperview().inset(15.0)
        }
    }
    
    private func setupBinding() {
        self.viewModel.accelerationData
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] data in
                guard let data = data.element else { return }
                self?.accXGraph.addPoint(x: 1 / 80.0, y: data.0)
                self?.accYGraph.addPoint(x: 1 / 80.0, y: data.1)
                self?.accZGraph.addPoint(x: 1 / 80.0, y: data.2)
            }.disposed(by: self.disposeBag)

        self.viewModel.labelPrediction
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] prediction in
                self?.activityPrediction.text = prediction
            }.disposed(by: self.disposeBag)
    }
    
    
}
