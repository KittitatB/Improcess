//
//  DashboardViewController.swift
//  Improcess
//
//  Created by MuMhu on 9/4/2562 BE.
//  Copyright (c) 2562 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DashboardDisplayLogic: class
{
    func displaySomething(viewModel: Dashboard.Something.ViewModel)
}

class DashboardViewController: UIViewController, DashboardDisplayLogic, UITableViewDataSource, UITableViewDelegate
{
    var interactor: DashboardBusinessLogic?
    var router: (NSObjectProtocol & DashboardRoutingLogic & DashboardDataPassing)?
    var phraseList =  [PhraseTypeList]()
    var defectList = [DefectTypeList]()
    
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
        let interactor = DashboardInteractor()
        let presenter = DashboardPresenter()
        let router = DashboardRouter()
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
        doSomething()
        defectList = (interactor?.defectList)!
        phraseList = (interactor?.phraseList)!
        adjustTableviewHeight()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phraseTable: UITableView!
    @IBOutlet weak var defectTable: UITableView!
    @IBOutlet weak var phraseTableHeight: NSLayoutConstraint!
    @IBOutlet weak var defectTableHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    func doSomething()
    {
        let request = Dashboard.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Dashboard.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.defectTable){
            return defectList.count
        }else{
            return phraseList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.defectTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "dCell", for: indexPath) as! DashboardCell
            cell.name.text = defectList[indexPath.row].name
            cell.detail.text = defectList[indexPath.row].detail
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pCell", for: indexPath) as! DashboardCell
            cell.name.text = phraseList[indexPath.row].name
            cell.detail.text = phraseList[indexPath.row].detail
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func adjustTableviewHeight(){
        phraseTableHeight.constant = CGFloat(phraseList.count * 50)
        defectTableHeight.constant = CGFloat(defectList.count * 50)
    }
}
