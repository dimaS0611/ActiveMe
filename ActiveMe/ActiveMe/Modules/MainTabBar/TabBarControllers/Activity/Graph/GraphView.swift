//
//  GraphView.swift
//  ActiveMe
//
//  Created by Dzmitry Semenovich on 6.12.21.
//

import Foundation
import CorePlot

class GraphView: CPTGraphHostingView {
    var plotData = [Double](repeating: 0.0, count: 100)
    var currentIndex: Double = 0.0
    
    var graph: CPTXYGraph?
    
    var plot: CPTScatterPlot?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20.0,
                                 height: 150.0))
        configureGraph()
        configureAxes()
        setupPlotSpace()
        configurePlot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureGraph() {
        self.allowPinchScaling = true
        plotData.removeAll()
        self.currentIndex = 0
        
        graph = CPTXYGraph(frame: hostedGraph?.hostingView?.bounds ?? .zero)
        graph?.plotAreaFrame?.masksToBorder = false
        hostedGraph = graph
        graph?.backgroundColor = UIColor.systemGray6.cgColor
        graph?.paddingBottom = 40.0
        graph?.paddingLeft = 40.0
        graph?.paddingTop = 30.0
        graph?.paddingRight = 15.0
    }
    
    private func configureAxes() {
        guard let axisSet = graph?.axisSet as? CPTXYAxisSet else { return }
        
        let axisTextStyle = CPTMutableTextStyle()
        axisTextStyle.color = CPTColor.init(nativeColor: UIColor.label)
        axisTextStyle.font = UIFont.thin(with: 12.0)
        axisTextStyle.textAlignment = .center
        
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineColor = CPTColor(nativeColor: UIColor(rgb: 0x178FB3))
        lineStyle.lineWidth = 5.0
        
        
        let gridLineStyle = CPTMutableLineStyle()
        gridLineStyle.lineColor = CPTColor.gray()
        gridLineStyle.lineWidth = 0.5
        
        if let x = axisSet.xAxis {
            x.majorIntervalLength = 20
            x.minorTicksPerInterval = 5
            x.labelTextStyle = axisTextStyle
            x.minorGridLineStyle = gridLineStyle
            x.axisLineStyle = lineStyle
            x.axisConstraints = CPTConstraints(lowerOffset: 0.0)
            x.delegate = self
        }
        
        if let y = axisSet.yAxis {
            y.majorIntervalLength   = 5
            y.minorTicksPerInterval = 5
            y.minorGridLineStyle = gridLineStyle
            y.labelTextStyle = axisTextStyle
            y.alternatingBandFills = [CPTFill(color: CPTColor.init(componentRed: 255, green: 255, blue: 255, alpha: 0.03)),CPTFill(color: CPTColor.black())]
            y.axisLineStyle = lineStyle
            y.axisConstraints = CPTConstraints(lowerOffset: 0.0)
            y.delegate = self
        }
    }
    
    private func setupPlotSpace() {
        let xMin = 0.0
        let xMax = 100.0
        let yMin = -3.0
        let yMax = 3.0
        guard let plotSpace = graph?.defaultPlotSpace as? CPTXYPlotSpace else { return }
        plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax - xMin))
        plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMin), lengthDecimal: CPTDecimalFromDouble(yMax - yMin))
    }
    
    
    private func configurePlot(){
        plot = CPTScatterPlot()
        
        let plotLineStile = CPTMutableLineStyle()
        plotLineStile.lineJoin = .round
        plotLineStile.lineCap = .round
        plotLineStile.lineWidth = 3
        plotLineStile.lineColor = CPTColor(nativeColor: UIColor(rgb: 0xF9743E))
        
        plot?.dataLineStyle = plotLineStile
        plot?.curvedInterpolationOption = .catmullCustomAlpha
        plot?.interpolation = .curved
        plot?.identifier = "coreplot-graph" as NSCoding & NSCopying & NSObjectProtocol
        
        guard let graph = hostedGraph,
              let plot = plot else { return }
        
        plot.dataSource = (self as CPTPlotDataSource)
        plot.delegate = (self as CALayerDelegate)
        graph.add(plot, to: graph.defaultPlotSpace)
    }
}

extension GraphView: CPTScatterPlotDataSource {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        UInt(plotData.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        switch CPTScatterPlotField(rawValue: Int(fieldEnum)) {
        case .X:
            return NSNumber(value: Int(idx) + Int(self.currentIndex) - self.plotData.count)
        case .Y:
            return self.plotData[Int(idx)] as NSNumber
        default:
            return 0
        }
    }
}

extension GraphView: CPTScatterPlotDelegate {
    
}
