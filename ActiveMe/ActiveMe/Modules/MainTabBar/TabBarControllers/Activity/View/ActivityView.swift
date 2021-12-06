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
    
    let graph = GraphView()
    
    let viewModel = ActivityViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGray6
        setupUI()
        setupBinding()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       // viewModel.viewDidDisappear()
    }
    
    private func setupUI() {
        view.addSubview(graph)
        
        graph.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(300.0)
        }
    }
    
    func addPointToGraph(pointX: Double, pointY: Double) {
        let graph = graph.hostedGraph
        let plot = graph?.plot(withIdentifier: "coreplot-graph" as NSCopying)
        if((plot) != nil) {
            if(self.graph.plotData.count >= 100) {
                self.graph.plotData.removeFirst()
                plot?.deleteData(inIndexRange:NSRange(location: 0, length: 1))
            }
        }
        guard let plotSpace = graph?.defaultPlotSpace as? CPTXYPlotSpace else { return }
        
        let location: NSInteger
        if self.graph.currentIndex >= 100 {
            location = NSInteger(self.graph.currentIndex - 100 + 2)
        } else {
            location = 0
        }
        
        let range: NSInteger
        
        if location > 0 {
            range = location-1
        } else {
            range = 0
        }
        
        let oldRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(range)), lengthDecimal: CPTDecimalFromDouble(Double(100-2)))
        let newRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(location)), lengthDecimal: CPTDecimalFromDouble(Double(100-2)))
        
        CPTAnimation.animate(plotSpace, property: "xRange", from: oldRange, to: newRange, duration:0.3)
        
        self.graph.currentIndex += 1;
       // let point = Double.random(in: 75...85)
        self.graph.plotData.append(pointX)
        //        self.graph.xValue.text = #"X: \#(String(format:"%.2f",Double(self.plotData.last!)))"#
        //            yValue.text = #"Y: \#(UInt(self.currentIndex!)) Sec"#
        plot?.insertData(at: UInt(self.graph.plotData.count-1), numberOfRecords: 1)
    }
    
    private func setupBinding() {
        self.viewModel.accelerationData
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] data in
                guard let data = data.element else { return }
                self?.addPointToGraph(pointX: data.0, pointY: 1 / 80.0 )
            }.disposed(by: self.disposeBag)

    }
    
    
}
