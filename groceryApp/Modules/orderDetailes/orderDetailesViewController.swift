//
//  orderDetailesViewController.swift
//  delivery
//
//  Created by youssef on 3/15/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
class orderDetailesViewController: BaseWireFrame<orderDetailesViewModel> {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var clientNameLbl: UILabel!
    
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderNameLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    

    let cellIdentifier = "ItemOfOrderTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func bind(ViewModel: orderDetailesViewModel) {
        // MARK: - SetupTableView
        SetupTableView()
        
        // MARK: - bind OrderData
        ViewModel.successGetItemsOfOrderObservable.bind(to: itemsTableView.rx.items(cellIdentifier: cellIdentifier, cellType: ItemOfOrderTableViewCell.self)){ (row, item , cell) in
            cell.selectionStyle = .none
            cell.configaration(item: item)
        }.disposed(by: disposePag)
        
        ViewModel.successGetOrderObservable.subscribe(onNext: { (orderData) in
            self.clientNameLbl.text = orderData.shopper
            self.orderIdLbl.text = "\(orderData.id ?? 0)"
            self.orderNumber.text = orderData.phoneNumber
            self.orderNameLbl.text = orderData.name
            self.containerView.isHidden = false
        }, onError: { (error) in
             self.presentAlertWith(msg: error.localizedDescription, {})
        }).disposed(by: disposePag)
        
         // MARK: - getOrderData
        ViewModel.getOrderData()
    }
    
    func SetupTableView(){
        itemsTableView.rx.setDelegate(self).disposed(by: disposePag)
          itemsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
      }
    
    @IBAction func addRate(_ sender: Any) {
        let rateingVC = coordinator.mainNavigator.viewController(for: .AddRate)
        rateingVC.modalPresentationStyle = .overFullScreen
        present(rateingVC, animated: true, completion: nil)
    }
    
}

extension orderDetailesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ItemOfOrderTableViewCell
        cell.countLbl.textColor = #colorLiteral(red: 0.05824901909, green: 0.3847238421, blue: 0.412258476, alpha: 1)
        cell.nameLb.textColor = #colorLiteral(red: 0.05824901909, green: 0.3847238421, blue: 0.412258476, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
