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

    private enum DailyPlan: String, CaseIterable {
        case water
        case training
        case goodMood
    }
    
    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var chart: OCKCartesianChartView?
    
    init(storeManager: OCKSynchronizedStoreManager = CareStoreReferenceManager.shared.synchronizedStoreManager) {
        super.init(storeManager: storeManager)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoView = UIImageView()
        logoView.image = UIImage(named: "ActiveMeName")
        navigationController?.navigationItem.titleView = logoView
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
                case CareStoreReferenceManager.TaskIdentifiers.dailyTracker.rawValue:

                    let feelingCard = OCKChecklistTaskViewController(task: task,
                                                                     eventQuery: .init(for: date),
                                                                     storeManager: self.storeManager)
                    
                    feelingCard.taskView.headerView.detailLabel.text = ""
                    feelingCard.taskView.headerView.accessibilityLabel = ""
                    listViewController.appendViewController(feelingCard, animated: false)
                default:
                    return
                }
            }
        }
        
        chart = OCKCartesianChartView(type: .bar)
        
        var dataSeries = [OCKDataSeries]()
        for _ in 0..<24 {
            var series = OCKDataSeries(values: [CGFloat()], title: "")
            series.size = 27
            series.gradientStartColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
            series.gradientEndColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
            dataSeries.append(series)
        }
        
        self.chart?.graphView.dataSeries.append(contentsOf: dataSeries)
        
        /// If you do not specify the minimum and maximum of your graph, `OCKCartesianGraphView` will take care of the right scaling.
        /// This can be helpful if you do not know the range of your values but it makes it more difficult to animate the graphs.
        self.chart?.graphView.xMinimum = 1
        self.chart?.graphView.xMaximum = 24
        
        /// You can also set an array of strings to set custom labels on the x-axis.
        /// I am not sure if that works on the y-axis as well.
        self.chart?.graphView.horizontalAxisMarkers = ["steps"]
        
        /// With theses properties you can set a title and a subtitle for your graph.
        self.chart?.headerView.titleLabel.text = "Your daily activity: \(0) steps"
        self.chart?.headerView.detailLabel.text = ""
        
        if let chart = chart {
            listViewController.appendView(chart, animated: false)
        }
        DispatchQueue.main.async {
            self.setupChart(date: date)
        }
    }
    
    // MARK: - Setup chart (use it to show steps and activity info!!!!)
    
    private func setupChart(date: Date) {
        DispatchQueue.global(qos: .userInteractive).async {
            
            let steps = self.viewModel.obtainSetpsPerTime(date: date).sorted { $0.key < $1.key }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"

            var numberOfSteps = 0
            var dataSeries = [OCKDataSeries]()
            for (time, step) in steps {
                let hour = formatter.string(from: time.start)
                var series = OCKDataSeries(values: [CGFloat(step)], title: hour)
                series.size = 27
                series.gradientStartColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
                series.gradientEndColor = UIColor(rgb: Int.random(in: Range<Int>(0...2147483637)))
                dataSeries.append(series)
                numberOfSteps += step
            }
            
            DispatchQueue.main.async {
                self.chart?.graphView.dataSeries = dataSeries

                self.chart?.headerView.titleLabel.text = "Your daily activity: \(numberOfSteps) steps"
            }
        }
    }
    
    private func addValuesToGraph(data: [DateInterval:Int]) {
        var points = [CGPoint]()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        for (time, steps) in data {
            let hour = formatter.string(from: time.start)
            points.append(CGPoint(x: Int(hour)!, y: steps))
        }
        let dataSeries = OCKDataSeries(dataPoints: points, title: "Steps")
        chart?.graphView.dataSeries.append(dataSeries)
    }
}
