//
//  ActivityView.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 4.12.21.
//

import Foundation
import UIKit
import RxSwift
import CareKitUI

class ActivityView: UIViewController {
    
    let viewModel = ActivityViewModel()
    
    let disposeBag = DisposeBag()
    
    private let graphStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 7.0
        return stack
    }()
    
    private lazy var chartX: OCKCartesianChartView = {
        let chart = OCKCartesianChartView(type: .line)
        chart.graphView.yMinimum = -0.5
        chart.graphView.yMaximum = 0.5
        
        chart.graphView.xMaximum = 50
        chart.graphView.xMinimum = 0
        
        chart.headerView.titleLabel.text = "Acceleration X"
        chart.headerView.detailLabel.text = ""
        
        var dataSeries = OCKDataSeries(dataPoints: [CGPoint(x: 0, y: 0)], title: "")
        
        dataSeries.gradientStartColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
        dataSeries.gradientEndColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
        
        chart.graphView.dataSeries = [dataSeries]
        
        return chart
    }()
    
    private lazy var chartY: OCKCartesianChartView = {
        let chart = OCKCartesianChartView(type: .line)
        chart.graphView.yMinimum = -0.5
        chart.graphView.yMaximum = 0.5
        
        chart.graphView.xMaximum = 50
        chart.graphView.xMinimum = 0
        
        chart.headerView.titleLabel.text = "Acceleration Y"
        chart.headerView.detailLabel.text = ""
        
        var dataSeries = OCKDataSeries(dataPoints: [CGPoint(x: 0, y: 0)], title: "")
        
        dataSeries.gradientStartColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
        dataSeries.gradientEndColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
        
        chart.graphView.dataSeries = [dataSeries]
        
        return chart
    }()
    
    private lazy var chartZ: OCKCartesianChartView = {
        let chart = OCKCartesianChartView(type: .line)
        chart.graphView.yMinimum = -0.5
        chart.graphView.yMaximum = 0.5
        
        chart.graphView.xMaximum = 50
        chart.graphView.xMinimum = 0
        
        chart.headerView.titleLabel.text = "Acceleration Z"
        chart.headerView.detailLabel.text = ""
        
        var dataSeries = OCKDataSeries(dataPoints: [CGPoint(x: 0, y: 0)], title: "")
        
        dataSeries.gradientStartColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
        dataSeries.gradientEndColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
        
        chart.graphView.dataSeries = [dataSeries]
        
        return chart
    }()
    
    private lazy var activityPrediction: UILabel = {
       let label = UILabel()
        label.font = UIFont.regular(with: 17.0)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .label
        label.text = "test"
        return label
    }()
    
    private var timeXValue: CGFloat = 0.0
    private let frequencyTime: CGFloat = 1.0 / 50
    
    private let chartsStartGradient: UIColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
    private let chartsEndGradient: UIColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
    
    private var xValue: CGFloat = 0
    
    private var pointsX = [CGPoint]()
    private var pointsY = [CGPoint]()
    private var pointsZ = [CGPoint]()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGray6
        setupUI()
        setupBinding()
    }
    
    private func setupUI() {
        self.graphStackView.addArrangedSubview(chartX)
        self.graphStackView.addArrangedSubview(chartY)
        self.graphStackView.addArrangedSubview(chartZ)

        view.addSubview(graphStackView)
        view.addSubview(activityPrediction)
        
        self.graphStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5.0)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.activityPrediction.snp.top).inset(-15.0)
        }
        
        activityPrediction.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10.0)
            make.leading.trailing.equalToSuperview().inset(15.0)
            make.height.equalTo(20.0)
        }
    }
    
    private func setupBinding() {
        let points = Array(0..<50).map { i -> CGPoint in
            let point = CGPoint(x: CGFloat(i),
                                y: CGFloat.random(in: -0.5...0.5) + 2)
            return point
        }
        var data2 = OCKDataSeries(dataPoints: points,
                                      title: "")
        
        data2.gradientStartColor = self.chartsStartGradient
        data2.gradientEndColor = self.chartsEndGradient
        
        data2.size = 2
        
        self.chartX.graphView.dataSeries = [data2]
        self.chartY.graphView.dataSeries = [data2]
        self.chartZ.graphView.dataSeries = [data2]
        
        self.viewModel.accelerationData
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] data in
                guard let data = data.element,
                      let self = self
                else { return }
                
                self.xValue += 1
                
                self.pointsX.append(CGPoint(x: self.xValue, y: data.0 + 2))
                self.pointsY.append(CGPoint(x: self.xValue, y: data.1 + 2))
                self.pointsZ.append(CGPoint(x: self.xValue, y: data.2 + 2))
                
                if self.pointsX.count == 50 {
                    var dataSeriesX = OCKDataSeries(dataPoints: self.pointsX, title: "")
                    dataSeriesX.gradientStartColor = self.chartsStartGradient
                    dataSeriesX.gradientEndColor = self.chartsEndGradient
                    dataSeriesX.size = 2
                    
                    var dataSeriesY = OCKDataSeries(dataPoints: self.pointsY, title: "")
                    dataSeriesY.gradientStartColor = self.chartsStartGradient
                    dataSeriesY.gradientEndColor = self.chartsEndGradient
                    dataSeriesY.size = 2
                    
                    var dataSeriesZ = OCKDataSeries(dataPoints: self.pointsZ, title: "")
                    dataSeriesZ.gradientStartColor = self.chartsStartGradient
                    dataSeriesZ.gradientEndColor = self.chartsEndGradient
                    dataSeriesZ.size = 2
                    
                    DispatchQueue.main.async {
                        self.chartX.graphView.dataSeries = [dataSeriesX]
                        self.chartY.graphView.dataSeries = [dataSeriesY]
                        self.chartZ.graphView.dataSeries = [dataSeriesZ]
                        
                        self.pointsX.removeAll()
                        self.pointsY.removeAll()
                        self.pointsZ.removeAll()
                        self.xValue = 0
                    }
                }
            }.disposed(by: self.disposeBag)

        self.viewModel.labelPrediction
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] prediction in
                self?.activityPrediction.text = prediction
            }.disposed(by: self.disposeBag)
    }
}
