//
//  PickUpLocationViewController.swift
//  PickUpLocations
//
//  Created by Ravi Vora on 19/8/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import UIKit
import CoreLocation

protocol PickUpListView {
    func displayPickUpList(axPickUpList: [PickUpListModel.ViewModel])
    func showLoading()
    func hideLoading()
    func showAlertError()
}

class PickUpLocationViewController: UIViewController {
    
    @IBOutlet weak var pickupListTableView: UITableView!
    var interactor: PickUpListBusinessLogic!
    var router: PickUpListRouterInterface!
    private var request = PickUpListModel.Request()
    private var pickupList: [PickUpListModel.ViewModel]! = []
    
    
    // MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil:
        Bundle?) {
        super.init(nibName: nibNameOrNil, bundle:nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(interatcor: PickUpListBusinessLogic? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = interatcor
    }
    
    // MARK: - Setup
    private func setup() {
        let router = PickUpListRouter()
        router.viewController = self
        
        let presenter = PickUpListPresenter(viewController: self)
        presenter.pickUpListView = self
        
        let interactor = PickUpListInteractor(presenter: presenter)
        interactor.presenter = presenter
        
        self.interactor = interactor
        self.router = router
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setUpPickUpTableView()
        setupUI()
        self.fetchPickUpList()
    }
    
    override func viewDidLayoutSubviews() {
        self.pickupListTableView.frame = view.bounds
    }
    
    func setupUI() {
        self.pickupListTableView.rowHeight = UITableView.automaticDimension
        self.pickupListTableView.estimatedRowHeight = 100
        self.pickupListTableView.isHidden = true
    }
    
    func setUpPickUpTableView() {
        self.pickupListTableView.separatorInset = .zero
        self.pickupListTableView.layoutMargins = .zero
        self.pickupListTableView.contentInsetAdjustmentBehavior = .never
        self.pickupListTableView.tableFooterView = UIView(frame: .zero)

        self.pickupListTableView.register(UINib(nibName: "PickUpLocationCell", bundle: nil), forCellReuseIdentifier: "PickUpLocationCell")
        self.pickupListTableView.accessibilityIdentifier = "tableView--pickupListTableView"
    }
    
    /*
     * This method will setup NavigationBar
     */
    func setupNavigationBar() {
        self.navigationItem.title = "Pomelo Pick Up"
        self.navigationController?.navigationBar.isTranslucent = false
        
        let leftbutton = RefreshButton.init(type: .custom)
        leftbutton.setImage(UIImage.init(named:UIConstant.Images.refreshIcon), for: .normal)
        leftbutton.addTarget(self, action: #selector(self.refreshClicked), for: .touchUpInside)
        leftbutton.tintColor = UIColor.black
        let leftBarButton = UIBarButtonItem.init(customView: leftbutton)
        leftBarButton.accessibilityIdentifier = "navigation-refresh"
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let rightbutton = LocationButton.init(type: .custom)
        rightbutton.setImage(UIImage.init(named:UIConstant.Images.locationIcon), for: .normal)
        rightbutton.addTarget(self, action: #selector(self.locationbuttonClicked), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem.init(customView: rightbutton)
        rightBarButton.accessibilityIdentifier = "navigation-location"
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func refreshClicked() {
        self.fetchPickUpList()
    }
    
    @objc func locationbuttonClicked() {
        let locationManager = UserLocationManager.sharedManager
        locationManager.delegate = self
    }
    
    private func fetchPickUpList() {
        self.request.shopID = 1
        DispatchQueue.main.async {
            self.interactor.showLoading()
        }
        self.interactor.fetchPickupList(request: self.request)
    }
}

extension PickUpLocationViewController: PickUpListView {
    
    func displayPickUpList(axPickUpList: [PickUpListModel.ViewModel]) {

       self.pickupList = axPickUpList
        
        DispatchQueue.main.async {
            self.pickupListTableView.isHidden = false
            self.pickupListTableView.delegate = self
            self.pickupListTableView.dataSource = self
            self.pickupListTableView.reloadData()
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            Tools.shared.showProgressHUD()
        }
    }
    
    func hideLoading() {
        Tools.shared.hideProgressHUD()
    }
    
    func showAlertError() {
        Tools.shared.alert(sMessage: SERVER_ERROR, handler: nil)
    }
}

extension PickUpLocationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.pickupList {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PickUpLocationCell", for: indexPath) as? PickUpLocationCell {
            cell.accessibilityIdentifier = "PickUpLocationCell\(indexPath.row)"
            cell.checkButton.tag = indexPath.row
            cell.delegate = self
            let data = self.pickupList[indexPath.row]
            cell.prepareCell(with: data)
            return cell
        }
        return UITableViewCell()
    }
}

extension PickUpLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}


extension PickUpLocationViewController: UserLocationManagerDelegate {
    
    func locationdidUpdateToLocation(location: CLLocation) {
        print("location updated")
        self.pickupList.sort(by: location)
        self.pickupListTableView.reloadData()
    }
}


extension PickUpLocationViewController: SelectButtonDelegate {
    
    func selectButtonClicked(isSelected: Bool, tag: Int) {
        
        let currentPickUp: PickUpListModel.ViewModel = self.pickupList[tag]
        
        if isSelected == true {
            currentPickUp.isSelected = false
        } else {
            currentPickUp.isSelected = true
        }
        self.pickupList[tag] = currentPickUp
        let indexPath = IndexPath(row: tag, section: 0)
        self.pickupListTableView.beginUpdates()
        self.pickupListTableView.reloadRows(at: [indexPath], with: .fade)
        self.pickupListTableView.endUpdates()
    }
}
