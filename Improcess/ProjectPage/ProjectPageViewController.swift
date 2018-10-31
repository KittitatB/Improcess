//
//  ProjectPageViewController.swift
//  Improcess
//
//  Created by MuMhu on 30/10/2561 BE.
//  Copyright (c) 2561 Kittitat Boonkarn. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ProjectPageDisplayLogic: class
{
    func displayProject(viewModel: ProjectPage.Project.ViewModel)
}

class ProjectPageViewController: UIViewController, ProjectPageDisplayLogic, UITableViewDataSource, UITableViewDelegate
{
    var interactor: ProjectPageBusinessLogic?
    var router: (NSObjectProtocol & ProjectPageRoutingLogic & ProjectPageDataPassing)?
    var projectTask = [ProjectTask]()
    // MARK: Object lifecycle
    
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectDescription: UITextView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
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
        let interactor = ProjectPageInteractor()
        let presenter = ProjectPagePresenter()
        let router = ProjectPageRouter()
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
        let a = ProjectTask(name: "aa")
        let b = ProjectTask(name: "bb")
        projectTask.append(a)
        projectTask.append(b)
        loadData()
        print(projectTask)
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func displayProject(viewModel: ProjectPage.Project.ViewModel)
    {
        projectName.text = viewModel.project.name
        projectDescription.text = viewModel.project.detail
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectTask.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == projectTask.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addingCell3", for: indexPath) as! AddingCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
            cell.taskNameLabel.text = projectTask[indexPath.row].name
            return cell
        }
    }
    
    func loadData(){
        interactor?.receiveProject()
        updateTableview()
    }
    
    func adjustHeight(){
        var viewHeight = 667
        if projectTask.count > 1{
            viewHeight += (projectTask.count - 1)
        }
        scrollHeight.constant = CGFloat(viewHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        adjustHeight()
    }
    
    func updateTableview(){
        tableviewHeight.constant = CGFloat((projectTask.count + 1) * 45)
        tableview.reloadData()
    }
}
