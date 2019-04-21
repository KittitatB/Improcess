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
    func displayPhrases(viewmodel: TaskPage.Phrase.ViewModel)
    func displayDefects(viewmodel: TaskPage.Defect.ViewModel)
    func displayPlan(viewmodel: TaskPage.Estimate.ViewModel)
    func displayActual(viewmodel: TaskPage.Actual.ViewModel)
}

class TaskPageViewController: UIViewController, TaskPageDisplayLogic, UITableViewDelegate, UITableViewDataSource
{
    var interactor: TaskPageBusinessLogic?
    var router: (NSObjectProtocol & TaskPageRoutingLogic & TaskPageDataPassing)?
    var tasks = [PhraseList]()
    var defects = [DefectList]()
    var planMetrics = [PlanMetric]()
    var actualMetrics = [ActualMetric]()
    lazy var defectsArray: [String] = []
    lazy var phrasesArray: [String] = []
    
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
        addDefectView.allowTouchesOfViewsOutsideBounds = true
        addPhraseView.allowTouchesOfViewsOutsideBounds = true
        self.hideKeyboardWhenTappedAround()
        interactor?.loadDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tasks.removeAll()
        interactor?.loadPlanMetrics()
        interactor?.loadPhrase()
        interactor?.loadDefect()
        interactor?.loadActualMetrics()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.layoutIfNeeded()
        var viewHeight = 950
        let tableviewsHeightSummary = (120 * planMetrics.count) + ((defects.count + tasks.count) * 80)
        if tableviewsHeightSummary > 300 {
            viewHeight += tableviewsHeightSummary - 300
        }
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(viewHeight))
        scrollHeight.constant = scrollView.contentSize.height - 750
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
    @IBOutlet weak var problemTextfield: UITextField!
    @IBOutlet weak var improvementTextfield: UITextField!
    @IBOutlet weak var mainView: UIView!
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func displayActual(viewmodel: TaskPage.Actual.ViewModel) {
        actualMetrics = viewmodel.metrics
        setupMatrixTableView()
    }
    
    func displayPlan(viewmodel: TaskPage.Estimate.ViewModel) {
        planMetrics = viewmodel.metrics
        setupMatrixTableView()
    }
    
    func displayPhrases(viewmodel: TaskPage.Phrase.ViewModel){
        tasks = viewmodel.phrases
        updateTableview()
    }
    
    func displayDefects(viewmodel: TaskPage.Defect.ViewModel) {
        defects = viewmodel.defects
        updateTableview()
    }
    
    func displayDropDown(viewmodel: TaskPage.DropDown.ViewModel) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else {
                return
            }
            
            for phrase in viewmodel.phraseList{
                self.phrasesArray.append(phrase.name!)
            }
            
            for defect in viewmodel.defectList{
                self.defectsArray.append(defect.name!)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.phraseDropDown.optionArray = (self?.phrasesArray)!
                self?.defectsDropDown.optionArray = (self?.defectsArray)!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.planningTable{
            return planMetrics.count
        }
        if tableView == self.taskTable{
            return tasks.count
        }
        if tableView == self.defectTable{
            return defects.count
        }
        if tableView == self.summaryTable{
            return actualMetrics.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.planningTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! MetricCell
            cell.name.text = planMetrics[indexPath.row].name!
            cell.field.text = planMetrics[indexPath.row].value!
            cell.project = interactor!.projectDetail
            cell.task = interactor?.selectedTask?.name
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
            cell.detail.text = defects[indexPath.row].detail
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
        cell.name.text = actualMetrics[indexPath.row].name!
        cell.field.text = actualMetrics[indexPath.row].value!
        cell.project = interactor!.projectDetail
        cell.task = interactor?.selectedTask?.name
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
            ratingVC.commentText = tasks[indexPath.row].detail
            ratingVC.time = tasks[indexPath.row].timer!
            
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
                self.tasks[indexPath.row].timer = ratingVC.time
                self.tasks[indexPath.row].detail = ratingVC.commentTextField.text
                self.interactor?.addPhrase(phrase: self.tasks[indexPath.row])
                self.taskTable.reloadData()
            }
            
            // Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])
            
            // Present dialog
            present(popup, animated: true, completion: nil)
        }
        
        if tableView == self.defectTable{
            let ratingVC = DefectModalController(nibName: "DefectModalController", bundle: nil)
            ratingVC.phrasesArray = phrasesArray
            ratingVC.type = defects[indexPath.row].name
            ratingVC.commentText = defects[indexPath.row].detail
            ratingVC.injected = defects[indexPath.row].injected ?? ""
            ratingVC.removed = defects[indexPath.row].removed ?? ""
            
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
                self.defects[indexPath.row].detail = ratingVC.comment.text
                self.defects[indexPath.row].injected = ratingVC.injectedPhrase.text
                self.defects[indexPath.row].removed = ratingVC.removedPhrase.text
                self.interactor?.addDefect(defect: self.defects[indexPath.row])
                self.defectTable.reloadData()
            }
            
            // Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])
            
            // Present dialog
            present(popup, animated: true, completion: nil)
        }
    }
    
    func setupMatrixTableView(){
        let metricsCount = actualMetrics.count
        planTableHeight.constant = CGFloat((metricsCount) * 60)
        summaryTableHeight.constant = CGFloat((metricsCount) * 60)
        planningTable.reloadData()
        summaryTable.reloadData()
        view.setNeedsLayout()
    }
    
    func updateTableview(){
        taskTableHeight.constant = CGFloat((tasks.count) * 80)
        defectTableHeight.constant = CGFloat((defects.count) * 80)
        taskTable.reloadData()
        defectTable.reloadData()
        view.setNeedsLayout()
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
        updateTableview()
    }
    
    @IBAction func defectAdded(_ sender: Any) {
        guard defectsDropDown.selectedIndex != nil else {return}
        let defect = DefectList(name: defectsDropDown.text,injected:"",removed:"", detail: "")
        defectsDropDown.text = ""
        defectsDropDown.selectedIndex = nil
        defects.append(defect)
        updateTableview()
    }
    
    
    @IBAction func finishUpTask(_ sender: Any) {
        interactor?.finishingUp(problem: problemTextfield.text ?? "" , improvement: improvementTextfield.text ?? "")
        var viewControllers = self.navigationController?.viewControllers
        viewControllers?.removeLast(1) // views to pop
        self.navigationController?.setViewControllers(viewControllers!, animated: true)
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

