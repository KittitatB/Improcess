//
//  ProducivilityPageViewController.swift
//  Improcess
//
//  Created by MuMhu on 17/2/2562 BE.
//  Copyright (c) 2562 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Charts
import Firebase

protocol ProducivilityPageDisplayLogic: class
{
    func displayProducivility(viewModel: ProducivilityPage.Producivility.ViewModel)
}

class ProducivilityPageViewController: UIViewController, ProducivilityPageDisplayLogic, ChartViewDelegate
{
    var interactor: ProducivilityPageBusinessLogic?
    var router: (NSObjectProtocol & ProducivilityPageRoutingLogic & ProducivilityPageDataPassing)?
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
        let interactor = ProducivilityPageInteractor()
        let presenter = ProducivilityPagePresenter()
        let router = ProducivilityPageRouter()
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
        loadData()
         self.title = "Project Infomation"
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var chartView: CombinedChartView!
    @IBOutlet weak var totalLineLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    func setupChart(){
        
        self.title = "Producivility Chart"
        
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
        xAxis.valueFormatter = TaskAxisFormatter(tasks: (self.interactor?.tasks)!)

        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " Line/Hour"
        leftAxisFormatter.positiveSuffix = " Line/Hour"

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
        let data = CombinedChartData()
        data.lineData = generateLineData(tasks: viewModel.tasksProducivility)
        data.barData = generateBarData(tasks: viewModel.tasksProducivility)
        
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
        
        totalLineLabel.text = "\(Int(totalLine)) Line"
        totalTimeLabel.text = "\(Int(totalTime)) Sec"
        averageLabel.text = "\(product/Float(tasks.count)) Line/Hours"
        
    }
    
    func loadData(){
        interactor?.getAllTaskProducivility()
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


public class TaskAxisFormatter: IAxisValueFormatter{
    var tasks: [ProjectTask]?
    
    init(tasks: [ProjectTask]) {
        self.tasks = tasks.filter{ $0.status == "Close"}.sorted {$0.timestamp < $1.timestamp}
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let taskID = tasks![Int(value)].name
        return taskID
    }
    
    
}
