//
//  TaskPageViewController.swift
//  Improcess
//
//  Created by MuMhu on 17/12/2561 BE.
//  Copyright (c) 2561 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import PopupDialog
import iOSDropDown

protocol TaskPageDisplayLogic: class
{
    func displaySomething(viewModel: TaskPage.Something.ViewModel)
}

class TaskPageViewController: UIViewController, TaskPageDisplayLogic, UITableViewDelegate, UITableViewDataSource, TaskLogic
{
    var interactor: TaskPageBusinessLogic?
    var router: (NSObjectProtocol & TaskPageRoutingLogic & TaskPageDataPassing)?
    var tasks = [PhraseList]()
    var metrics = [KeyMetricList]()
    
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
        let interactor = TaskPageInteractor()
        let presenter = TaskPagePresenter()
        let router = TaskPageRouter()
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
        let task = PhraseList(name: "aa", timer: 90, detail:"lorem dsasasadasdadsdsaasasdsad")
        tasks.append(task)
        let metric = KeyMetricList(name: "bb")
        metrics.append(metric)
        planningTable.reloadData()
        taskTable.reloadData()
        defectTable.reloadData()
        summaryTable.reloadData()
        dropDown.optionArray = ["Option 1", "Option 2", "Option 3"]
        //Its Id Values and its optional
        dropDown.optionIds = [1,23,54,22]
        addDefectView.allowTouchesOfViewsOutsideBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.layoutIfNeeded()
        var viewHeight = 774
        updateTableview()
        if (metrics.count + (tasks.count + 1) + (tasks.count + 1) + metrics.count) > 6 {
            viewHeight += ((metrics.count + (tasks.count + 1) + (tasks.count + 1) + metrics.count - 6)*80)
        }
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(viewHeight))
    }
    
    
    // MARK: Do something

    @IBOutlet weak var addDefectView: UIView!
    @IBOutlet weak var planningTable: UITableView!
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var defectTable: UITableView!
    @IBOutlet weak var summaryTable: UITableView!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var planTableHeight: NSLayoutConstraint!
    @IBOutlet weak var taskTableHeight: NSLayoutConstraint!
    @IBOutlet weak var defectTableHeight: NSLayoutConstraint!
    @IBOutlet weak var summaryTableHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addDefectViewHeight: NSLayoutConstraint!
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething()
    {
        let request = TaskPage.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: TaskPage.Something.ViewModel)
    {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.planningTable{
            return metrics.count
        }
        
        if tableView == self.taskTable{
            return tasks.count + 1
        }
        
        if tableView == self.defectTable{
            return tasks.count
        }
        
        if tableView == self.summaryTable{
            return metrics.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.planningTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! MetricCell
            cell.name.text = metrics[indexPath.row].name
            return cell
        }
        
        if tableView == self.taskTable{
            if indexPath.row == tasks.count{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskCell", for: indexPath) as! AddTaskCell
                cell.cellInteractor = self
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! PhraseCell
                cell.name.text = tasks[indexPath.row].name
                cell.timer.text = String(describing: tasks[indexPath.row].timer)
                cell.detail.text = tasks[indexPath.row].detail
                return cell}
        }
        
        if tableView == self.defectTable{
            if indexPath.row == tasks.count{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddDefectCell", for: indexPath) as! AddDefectCell
                cell.cellInteractor = self
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefectCell", for: indexPath) as! DefectCell
                cell.name.text = tasks[indexPath.row].name
                cell.timer.text = String(describing: tasks[indexPath.row].timer)
                cell.detail.text = tasks[indexPath.row].detail
                return cell}
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
        cell.name.text = metrics[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func addTask() {
        //        let task = PhraseList(name: "aa", timer: 90, detail:"lorem dsasasadasdadsdsaasasdsad")
        //        tasks.append(task)
        //        updateTableview()
        //        self.view.setNeedsLayout()
        let ratingVC = TaskModalController(nibName: "TaskModalController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: false,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 50) {
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "DONE", height: 50) {
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    func updateTableview(){
        taskTableHeight.constant = CGFloat((tasks.count + 1) * 80)
        defectTableHeight.constant = CGFloat((tasks.count + 1) * 80)
        taskTable.reloadData()
        defectTable.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // The list of array to display. Can be changed dynamically
    
    @IBOutlet weak var dropDown: DropDown!
    
}

public extension UIView {
    
    private struct ExtendedTouchAssociatedKey {
        static var outsideOfBounds = "viewExtensionAllowTouchesOutsideOfBounds"
    }
    
    /// This propery is set on the parent of the view that first clips the content you want to be touchable
    /// outside of the bounds
    var allowTouchesOfViewsOutsideBounds:Bool {
        get {
            return objc_getAssociatedObject(self, &ExtendedTouchAssociatedKey.outsideOfBounds) as? Bool ?? false
        }
        set {
            UIView.swizzlePointInsideIfNeeded()
            subviews.forEach({$0.allowTouchesOfViewsOutsideBounds = newValue})
            objc_setAssociatedObject(self, &ExtendedTouchAssociatedKey.outsideOfBounds, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func hasSubview(at point:CGPoint) -> Bool {
        
        if subviews.count == 0 {
            return self.bounds.contains(point)
        }
        return subviews.contains(where: { (subview) -> Bool in
            let converted = self.convert(point, to: subview)
            return subview.hasSubview(at: converted)
        })
        
    }
    
    static private var swizzledMethods:Bool = false
    
    @objc func _point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if allowTouchesOfViewsOutsideBounds {
            return  _point(inside:point,with:event) || hasSubview(at: point)
        }
        return _point(inside:point,with:event)
    }
    
    static private func swizzlePointInsideIfNeeded() {
        if swizzledMethods {
            return
        }
        swizzledMethods = true
        let aClass: AnyClass! = UIView.self
        let originalSelector = #selector(point(inside:with:))
        let swizzledSelector = #selector(_point(inside:with:))
        swizzling(aClass, originalSelector, swizzledSelector)
    }
}

private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    let originalMethod = class_getInstanceMethod(forClass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}

