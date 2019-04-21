//
//  ChartsViewController.swift
//  Improcess
//
//  Created by MuMhu on 14/3/2562 BE.
//  Copyright (c) 2562 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Charts
import Firebase

protocol ChartsDisplayLogic: class
{
    func displayChart(viewModel: Charts.ChartsData.ViewModel)
    func displayDefect(viewModel: Charts.DefectData.ViewModel)
}

class ChartsViewController: UIViewController, ChartsDisplayLogic, ChartViewDelegate
{
    var interactor: ChartsBusinessLogic?
    var router: (NSObjectProtocol & ChartsRoutingLogic & ChartsDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ChartsInteractor()
        let presenter = ChartsPresenter()
        let router = ChartsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupChart()
        setupChart2()
        interactor?.getDefectData()
        interactor?.getChartData()
    }
    
    // MARK: Do something
    
    
    
    @IBOutlet weak var predictionChart: LineChartView!
    @IBOutlet weak var defectCharts: BarChartView!
    
    func displayChart(viewModel: Charts.ChartsData.ViewModel) {
        predictionChart.noDataText = "Loading"
        var entry = [ChartDataEntry]()
        
        for i in 0..<viewModel.predition.count{
            let temp = ChartDataEntry(x: Double(i), y: Double(viewModel.predition[i].predictionData))
            entry.append(temp)
        }
        
        
        let set1 = LineChartDataSet(values: entry, label: "Prediction")
        
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.setCircleColor(.gray)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 65/255
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        set1.colors = ChartColorTemplates.colorful()
        
        let data = LineChartData(dataSets: [set1])
        
        predictionChart.data = data
        predictionChart.notifyDataSetChanged()
        //        defectCharts.noDataText = "Loading"
        //        var entry = [BarChartDataEntry]()
        //
        //        for i in 0..<viewModel.predition.count{
        //            let temp = BarChartDataEntry(x: Double(i), y: Double(viewModel.predition[i].predictionData))
        //            entry.append(temp)
        //        }
        //
        //        let dataSet = BarChartDataSet(values: entry, label: "Tasks")
        //        let data = BarChartData(dataSets: [dataSet])
        //        defectCharts.data = data
        //        dataSet.colors = ChartColorTemplates.colorful()
        //
        //        defectCharts.notifyDataSetChanged()
    }
    
    func displayDefect(viewModel: Charts.DefectData.ViewModel) {
                predictionChart.noDataText = "Loading"
                var entry = [BarChartDataEntry]()
        
                for i in 0..<viewModel.defectQuantity.count{
                    let temp = BarChartDataEntry(x: Double(i), y: Double(viewModel.defectQuantity[i].numberOfDefects))
                    entry.append(temp)
                }
        
                let dataSet = BarChartDataSet(values: entry, label: "Tasks")
                let data = BarChartData(dataSets: [dataSet])
                defectCharts.data = data
                dataSet.colors = ChartColorTemplates.colorful()
        
                defectCharts.notifyDataSetChanged()
        //        let set1 = LineChartDataSet(values: entry, label: "Prediction")
        
        //        set1.axisDependency = .left
        //        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        //        set1.setCircleColor(.gray)
        //        set1.lineWidth = 2
        //        set1.circleRadius = 3
        //        set1.fillAlpha = 65/255
        //        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        //        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        //        set1.drawCircleHoleEnabled = false
        //        set1.colors = ChartColorTemplates.colorful()
        //
        //        let data = LineChartData(dataSets: [set1])
        //
        //        predictionChart.data = data
        //        predictionChart.notifyDataSetChanged()
    }
    
    func setupChart(){
        defectCharts.chartDescription?.enabled = false
        
        defectCharts.highlightPerTapEnabled = false
        defectCharts.dragEnabled = false
        defectCharts.setScaleEnabled(true)
        defectCharts.pinchZoomEnabled = false
        
        // ChartYAxis *leftAxis = chartView.leftAxis;
        
        let xAxis = defectCharts.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = DefaultAxisValueFormatter()
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = defectCharts.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        
        let rightAxis = defectCharts.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = defectCharts.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
    }
    
    func setupChart2(){
        predictionChart.delegate = self
        
        predictionChart.chartDescription?.enabled = false
        predictionChart.dragEnabled = true
        predictionChart.setScaleEnabled(true)
        predictionChart.pinchZoomEnabled = true
        
        let l = predictionChart.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .white
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = predictionChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = predictionChart.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.negativeSuffix = " %"
        leftAxisFormatter.positiveSuffix = " %"
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        
        let rightAxis = predictionChart.rightAxis
        rightAxis.labelTextColor = .red
        rightAxis.axisMaximum = 100
        rightAxis.axisMinimum = 0
        rightAxis.granularityEnabled = false
        
        let rightAxisFormatter = NumberFormatter()
        rightAxisFormatter.negativeSuffix = " %"
        rightAxisFormatter.positiveSuffix = " %"
        rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: rightAxisFormatter)
    }
    
}
