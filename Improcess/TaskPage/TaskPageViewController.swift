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
    func displayDropDown(viewmodel: TaskPage.DropDown.ViewModel)
}

class TaskPageViewController: UIViewController, TaskPageDisplayLogic, UITableViewDelegate, UITableViewDataSource
{
    var interactor: TaskPageBusinessLogic?
    var router: (NSObjectProtocol & TaskPageRoutingLogic & TaskPageDataPassing)?
    var tasks = [PhraseList]()
    var defects = [DefectList]()
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
        updateTableview()
        let metric1 = KeyMetricList(name: "Time")
        let metric2 = KeyMetricList(name: "Line of Code")
        metrics.append(metric1)
        metrics.append(metric2)
        setupMatrixTableView()
        addDefectView.allowTouchesOfViewsOutsideBounds = true
        addPhraseView.allowTouchesOfViewsOutsideBounds = true
        interactor?.loadDropDown()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.layoutIfNeeded()
        var viewHeight = 774
        updateTableview()
        let tableviewsHeightSummary = (120 * metrics.count) + ((defects.count + tasks.count) * 80)
        if tableviewsHeightSummary > 480 {
            viewHeight += tableviewsHeightSummary - 480
        }
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(viewHeight))
    }
    
    
    // MARK: Do something
    
    @IBOutlet weak var addPhraseView: UIView!
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
    @IBOutlet weak var defectsDropDown: DropDown!
    @IBOutlet weak var phraseDropDown: DropDown!
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    
    
    func displayDropDown(viewmodel: TaskPage.DropDown.ViewModel) {
        var defectsArray: [String] = []
        var phrasesArray: [String] = []
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else {
                return
            }
            
            for phrase in viewmodel.phraseList{
                phrasesArray.append(phrase.name!)
            }
            
            for defect in viewmodel.defectList{
                defectsArray.append(defect.name!)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.phraseDropDown.optionArray = phrasesArray
                self?.defectsDropDown.optionArray = defectsArray
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.planningTable{
            return metrics.count
        }
        if tableView == self.taskTable{
            return tasks.count
        }
        if tableView == self.defectTable{
            return defects.count
        }
        if tableView == self.summaryTable{
            return metrics.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.planningTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! MetricCell
            cell.name.text = "Expect "+metrics[indexPath.row].name!
            return cell
        }
        
        if tableView == self.taskTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! PhraseCell
            cell.name.text = tasks[indexPath.row].name
            cell.timer.text = String(describing: tasks[indexPath.row].timer!)
            cell.detail.text = tasks[indexPath.row].detail
            return cell
        }
        
        if tableView == self.defectTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefectCell", for: indexPath) as! DefectCell
            cell.name.text = defects[indexPath.row].name
            cell.timer.text = String(describing: defects[indexPath.row].timer!)
            cell.detail.text = defects[indexPath.row].detail
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
        cell.name.text = "Actual " + metrics[indexPath.row].name!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.planningTable{
            return 60
        }
        if tableView == self.summaryTable{
            return 60
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.taskTable{
            let ratingVC = TaskModalController(nibName: "TaskModalController", bundle: nil)
            ratingVC.name = tasks[indexPath.row].name
            // Create the dialog
            let popup = PopupDialog(viewController: ratingVC,
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .bounceDown,
                                    tapGestureDismissal: false,
                                    panGestureDismissal: false)
            
            // Create first button
            let buttonOne = CancelButton(title: "CANCEL", height: 50) {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            // Create second button
            let buttonTwo = DefaultButton(title: "DONE", height: 50) {
            }
            
            // Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])
            
            // Present dialog
            present(popup, animated: true, completion: nil)
        }
    }
    
    func setupMatrixTableView(){
        let metricsCount = metrics.count
        planTableHeight.constant = CGFloat((metricsCount) * 60)
        summaryTableHeight.constant = CGFloat((metricsCount) * 60)
        view.setNeedsLayout()
    }
    
    func updateTableview(){
        taskTableHeight.constant = CGFloat((tasks.count) * 80)
        defectTableHeight.constant = CGFloat((defects.count) * 80)
        taskTable.reloadData()
        defectTable.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func taskAdded(_ sender: Any) {
        guard phraseDropDown.selectedIndex != nil else {return}
        let task = PhraseList(name: phraseDropDown.text, timer: 00, detail: "")
        phraseDropDown.text = ""
        phraseDropDown.selectedIndex = nil
        tasks.append(task)
        view.setNeedsLayout()
    }
    
    @IBAction func defectAdded(_ sender: Any) {
        guard defectsDropDown.selectedIndex != nil else {return}
        let defect = DefectList(name: defectsDropDown.text, timer: 00, detail: "")
        defectsDropDown.text = ""
        defectsDropDown.selectedIndex = nil
        defects.append(defect)
        view.setNeedsLayout()
    }
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

