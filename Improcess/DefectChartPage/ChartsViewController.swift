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
    func displayProducivility(viewModel: ProducivilityPage.Producivility.ViewModel)
}

class ChartsViewController: UIViewController, ChartsDisplayLogic, ChartViewDelegate
{
    var interactor: ChartsBusinessLogic?
    var router: (NSObjectProtocol & ChartsRoutingLogic & ChartsDataPassing)?
    var counter = 0.0
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
        self.tabBarController?.title = "Project Analysis"
        super.viewDidLoad()
        setupChart()
        setupChart3()
        setupChart2()
    }
    
    // MARK: Do something
    override func viewDidAppear(_ animated: Bool) {
        interactor?.getDefectData()
        interactor?.getChartData()
        interactor?.getAllTaskProducivility()
    }
    
    
    @IBOutlet weak var predictionChart: CombinedChartView!
    @IBOutlet weak var defectCharts: CombinedChartView!
    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var totalDefectLabel: UILabel!
    @IBOutlet weak var averageDefectLabel: UILabel!
    @IBOutlet weak var chartView: CombinedChartView!
    @IBOutlet weak var totalLineLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    func setupChart(){
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.drawBarShadowEnabled = false
        chartView.highlightFullBarEnabled = false
        
        
        chartView.drawOrder = [DrawOrder.bar.rawValue,
                                     DrawOrder.line.rawValue]
        
        chartView.chartDescription?.enabled = false
        
        chartView.highlightPerTapEnabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        
        // ChartYAxis *leftAxis = chartView.leftAxis;
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.axisMaximum = counter + 0.5
        xAxis.labelPosition = .bothSided
        xAxis.axisMinimum = -0.5
        xAxis.valueFormatter = TaskAxisFormatter(tasks: self.interactor!.tasks!)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " L/H"
        leftAxisFormatter.positiveSuffix = " L/H"
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = chartView.legend
        l.enabled = false
    }
    
    func displayProducivility(viewModel: ProducivilityPage.Producivility.ViewModel)
    {
        counter = Double(viewModel.tasksProducivility.count)
        let sortedTask = viewModel.tasksProducivility.sorted {$0.timestamp! < $1.timestamp!}
        
        let data = CombinedChartData()
        data.lineData = generateLineData(tasks: sortedTask)
        data.barData = generateBarData(tasks: sortedTask)
        
        chartView.xAxis.axisMaximum = data.xMax + 0.5
        chartView.data = data
        
        chartView.notifyDataSetChanged()
        
        updateDetail(tasks: viewModel.tasksProducivility)
    }
    
    func updateDetail(tasks: [TaskProducivility]){
        var totalTime: Float = 0.0
        var totalLine: Float = 0.0
        var product: Float = 0.0
        
        for task in tasks{
            totalTime += task.time!
            totalLine += task.line!
            product += task.taskProducivility!
        }
        
        if(Int(totalLine) == tasks.count){
            viewHeight.constant = 1220
            chartView.isHidden = true
        }
        
        totalLineLabel.text = "\(Int(totalLine)) Line"
        totalTimeLabel.text = "\(String(format: "%.01f",product/Float(tasks.count))) Line/Hours"
        averageLabel.text = "\(Int(totalTime)) Minutes"
        
    }
    
    func displayChart(viewModel: Charts.ChartsData.ViewModel) {
        predictionChart.noDataText = "Loading"
        let data = CombinedChartData()
        let sortedTask = viewModel.predition.sorted {$0.timestamp < $1.timestamp}
        
        data.lineData = generateLineData(tasks: sortedTask)
        data.barData = generateBarData(tasks: sortedTask)
        
        var totalPredict = 0.0
        
        for predict in viewModel.predition{
            totalPredict += Double(predict.predictionData)
        }
        
        let predictText = String(format: "%.01f", totalPredict/Double(viewModel.predition.count)) + " %"
        
        predictLabel.text = predictText
        
        predictionChart.xAxis.axisMaximum = data.xMax + 0.5
        predictionChart.data = data
        
        predictionChart.notifyDataSetChanged()
    }
    
    func displayDefect(viewModel: Charts.DefectData.ViewModel) {
        predictionChart.noDataText = "Loading"
        
        var totalDefect = 0
        for defect in viewModel.defectQuantity{
            totalDefect += defect.numberOfDefects
        }
        
        totalDefectLabel.text = "\(totalDefect)"
        averageDefectLabel.text = "\(String(format: "%.01f", Float(totalDefect)/Float(viewModel.defectQuantity.count)))"
        
        let data = CombinedChartData()
        let sortedTask = viewModel.defectQuantity.sorted {$0.timestamp < $1.timestamp}
        
        data.lineData = generateLineData(tasks: sortedTask)
        data.barData = generateBarData(tasks: sortedTask)
        
        defectCharts.xAxis.axisMaximum = data.xMax + 0.5
        defectCharts.data = data
        
        defectCharts.notifyDataSetChanged()
        
    }
    
    func setupChart3(){
        defectCharts.delegate = self
        
        defectCharts.chartDescription?.enabled = false
        defectCharts.drawBarShadowEnabled = false
        defectCharts.highlightFullBarEnabled = false
        
        
        defectCharts.drawOrder = [DrawOrder.bar.rawValue,
                                  DrawOrder.line.rawValue]
        
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
        //        xAxis.axisMaximum = counter + 0.5
        xAxis.labelPosition = .bothSided
        xAxis.axisMinimum = -0.5
        xAxis.valueFormatter = TaskAxisFormatter(tasks: self.interactor!.tasks!)
        //        defectCharts.pinchZoomEnabled = false
        
        // ChartYAxis *leftAxis = chartView.leftAxis;
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = defectCharts.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        
        let rightAxis = defectCharts.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = defectCharts.legend
        l.enabled = false
    }
    
    func setupChart2(){

        predictionChart.delegate = self
        
        predictionChart.chartDescription?.enabled = false
        predictionChart.drawBarShadowEnabled = false
        predictionChart.highlightFullBarEnabled = false
        
        
        predictionChart.drawOrder = [DrawOrder.bar.rawValue,
                                  DrawOrder.line.rawValue]
        
        predictionChart.chartDescription?.enabled = false
        
        predictionChart.highlightPerTapEnabled = false
        predictionChart.dragEnabled = false
        predictionChart.setScaleEnabled(true)
        predictionChart.pinchZoomEnabled = false
        
        let xAxis = predictionChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        //        xAxis.axisMaximum = counter + 0.5
        xAxis.labelPosition = .bothSided
        xAxis.axisMinimum = -0.5
        xAxis.valueFormatter = TaskAxisFormatter(tasks: self.interactor!.tasks!)
        
        
        let leftAxis = predictionChart.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.negativeSuffix = " %"
        leftAxisFormatter.positiveSuffix = " %"
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        
        let rightAxis = predictionChart.rightAxis
        rightAxis.labelTextColor = .red
        rightAxis.axisMinimum = 0
        rightAxis.granularityEnabled = false
        
        let rightAxisFormatter = NumberFormatter()
        rightAxisFormatter.negativeSuffix = " %"
        rightAxisFormatter.positiveSuffix = " %"
        rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: rightAxisFormatter)
        
        let l = predictionChart.legend
        l.enabled = false
        
    }
    
    func generateLineData(tasks: [DefectChartData]) -> LineChartData {
        let entry = (0..<tasks.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: Double(tasks[i].numberOfDefects))
        }
        
        let set = LineChartDataSet(entries: entry, label: "Tasks")
        set.colors = ChartColorTemplates.joyful()
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    func generateBarData(tasks: [DefectChartData]) -> BarChartData {
        
        let entry = (0..<tasks.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(tasks[i].numberOfDefects))
        }
        
        let dataSet = BarChartDataSet(entries: entry, label: "Tasks")
        let data = BarChartData(dataSets: [dataSet])
        //        chartView.data = data
        dataSet.colors = ChartColorTemplates.colorful()
        dataSet.axisDependency = .left
        
        return data
    }
    
    func generateLineData(tasks: [PredictionChartsData]) -> LineChartData {
        let entry = (0..<tasks.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: Double(tasks[i].predictionData))
        }
        
        let set = LineChartDataSet(entries: entry, label: "Tasks")
        set.colors = ChartColorTemplates.joyful()
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    func generateBarData(tasks: [PredictionChartsData]) -> BarChartData {
        
        let entry = (0..<tasks.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(tasks[i].predictionData))
        }
        
        let dataSet = BarChartDataSet(entries: entry, label: "Tasks")
        let data = BarChartData(dataSets: [dataSet])
        //        chartView.data = data
        dataSet.colors = ChartColorTemplates.colorful()
        dataSet.axisDependency = .left
        
        return data
    }
    
    func generateLineData(tasks: [TaskProducivility]) -> LineChartData {
        let entry = (0..<tasks.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: Double(tasks[i].taskProducivility!))
        }
        
        let set = LineChartDataSet(entries: entry, label: "Tasks")
        set.colors = ChartColorTemplates.joyful()
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    func generateBarData(tasks: [TaskProducivility]) -> BarChartData {
        
        let entry = (0..<tasks.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(tasks[i].taskProducivility!))
        }
        
        let dataSet = BarChartDataSet(entries: entry, label: "Tasks")
        let data = BarChartData(dataSets: [dataSet])
        //        chartView.data = data
        dataSet.colors = ChartColorTemplates.colorful()
        dataSet.axisDependency = .left
        
        return data
    }
    
}
