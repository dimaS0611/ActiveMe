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
import CareKitUI
import CareKit

final class HomeView: OCKDailyPageViewController {
    init(storeManager: OCKSynchronizedStoreManager = CareStoreReferenceManager.shared.synchronizedStoreManager) {
        super.init(storeManager: storeManager)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "ActiveMeName")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
    
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController, prepare listViewController: OCKListViewController, for date: Date) {
        let identifiers = CareStoreReferenceManager.TaskIdentifiers.allCases.map { $0.rawValue }
        var query = OCKTaskQuery(for: date)
        query.ids = identifiers
        query.excludesTasksWithNoEvents = true
        
        storeManager.store.fetchAnyTasks(query: query,
                                         callbackQueue: .main) { result in
            guard let tasks = try? result.get() else { return }
            
            tasks.forEach { task in
                switch task.id {
                case CareStoreReferenceManager.TaskIdentifiers.feelling.rawValue:
                    
                    let feelingCard = OCKGridTaskViewController(task: task,
                                                                eventQuery: .init(for: date),
                                                                storeManager: self.storeManager)
                    
                    listViewController.appendViewController(feelingCard, animated: false)

                case CareStoreReferenceManager.TaskIdentifiers.steps.rawValue:
                    let stepsSeries = OCKDataSeriesConfiguration(taskID: "steps",
                                                                 legendTitle: "Today's steps",
                                                                 gradientStartColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),
                                                                 gradientEndColor: UIColor(rgb: 0x178FB3),
                                                                 markerSize: 10,
                                                                 eventAggregator: OCKEventAggregator.countOutcomeValues)
                    
                    let stepsChart = OCKCartesianChartViewController(plotType: .bar,
                                                                     selectedDate: date,
                                                                     configurations: [stepsSeries],
                                                                     storeManager: self.storeManager)
                    
                    stepsChart.chartView.headerView.titleLabel.text = "Today's steps"
                    //stepsChart.chartView.headerView.detailLabel.text = ""
                    
                    listViewController.appendViewController(stepsChart, animated: false)
                default:
                    return
                }
            }
        }
        setupChart()
        
        listViewController.appendView(chart, animated: false)
    }
    
    let chart = OCKCartesianChartView(type: .line)

    // MARK: - Setup chart (use it to show steps and activity info!!!!)
    
    private func setupChart() {
        /// First create an array of CGPoints that you will use to generate your data series.
        /// We use the handy map method to generate some random points.
        let dataPoints = Array(0...20).map { _ in CGPoint(x: CGFloat.random(in: 0...20),
                                                          y: CGFloat.random(in: 1...5)) }

        /// Now you create an instance of `OCKDataSeries` from your array of points, give it a title and a color. The title is used for the label below the graph (just like in Microsoft Excel)
        var data = OCKDataSeries(dataPoints: dataPoints,
                                 title: "Random stuff",
                                 color: .green)

        /// You can create as many data series as you like 🌈
        let dataPoints2 = Array(0...20).map { _ in CGPoint(x: CGFloat.random(in: 0...20),
                                                           y: CGFloat.random(in: 1...5)) }
        var data2 = OCKDataSeries(dataPoints: dataPoints2,
                                  title: "Other random stuff",
                                  color: .red)

        /// Set the pen size for the data series...
        data.size = 2
        data2.size = 1

        /// ... and gradients if you like.
        /// Gradients and colors will be used for the graph as well as the color indicator of your label that shows the title of your data series.
        data.gradientStartColor = .blue
        data.gradientEndColor = .red

        /// Finally you add the prepared data series to your graph view.
        chart.graphView.dataSeries = [data, data2]

        /// If you do not specify the minimum and maximum of your graph, `OCKCartesianGraphView` will take care of the right scaling.
        /// This can be helpful if you do not know the range of your values but it makes it more difficult to animate the graphs.
        chart.graphView.yMinimum = 0
        chart.graphView.yMaximum = 6
        chart.graphView.xMinimum = 0
        chart.graphView.xMaximum = 10

        /// You can also set an array of strings to set custom labels on the x-axis.
        /// I am not sure if that works on the y-axis as well.
        chart.graphView.horizontalAxisMarkers = ["123", "hello"]

        /// With theses properties you can set a title and a subtitle for your graph.
        chart.headerView.titleLabel.text = "Hello"
        chart.headerView.detailLabel.text = "I am a graph"
        
      }
    
}

//class HomeView: UIViewController {
//
//    private let disposeBag = DisposeBag()
//
//    let viewModel = HomeViewModel()
//
//    lazy var prediction: UILabel = {
//       let label = UILabel()
//        label.lineBreakMode = .byWordWrapping
//        label.textColor = .label
//        return label
//    }()
//
//    lazy var accData: UILabel = {
//       let label = UILabel()
//        label.lineBreakMode = .byWordWrapping
//        label.textColor = .label
//        return label
//    }()
//
//    override func viewDidLoad() {
//        view.backgroundColor = .systemBlue
//        setupUI()
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//       // viewModel.viewDidDisappear()
//    }
//
//    private func setupUI() {
//        view.addSubview(prediction)
//        view.addSubview(accData)
//
//        setupConstraints()
//        setupBinding()
//    }
//
//    private func setupConstraints() {
//        prediction.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.height.equalTo(100.0)
//        }
//
//        accData.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().inset(-50.0)
//            make.height.equalTo(50.0)
//            make.width.equalTo(150.0)
//        }
//    }
//
//    private func setupBinding() {
//        viewModel.labelPrediction
//            .subscribe(on: MainScheduler.instance)
//            .subscribe { [weak self] prediction in
//                DispatchQueue.main.async {
//                    self?.prediction.text = prediction
//                }
//            }.disposed(by: self.disposeBag)
//
//        viewModel.accelerationData
//            .subscribe(on: MainScheduler.instance)
//            .subscribe { [weak self] data in
//                guard let acc = data.element else { return }
//                DispatchQueue.main.async {
//                    self?.accData.text = "\(acc.0), \(acc.1), \(acc.2)"
//                }
//            }.disposed(by: self.disposeBag)
//    }
//}
