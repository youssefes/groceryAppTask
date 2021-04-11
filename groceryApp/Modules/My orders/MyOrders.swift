//
//  MyOrder.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyOrders : BaseWireFrame<MyOrdersViewModel> {
    
    
    @IBOutlet weak var noOrderLbl: UILabel!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "OrderCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func SetupTableView(){
        
        tableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
      
        
    }
    override func bind(ViewModel: MyOrdersViewModel) {
        // MARK: - SetupTableView
        SetupTableView()
        
        ViewModel.getShopper()
        tableView.rx.setDelegate(self).disposed(by: disposePag)
        
        // MARK: - bind OrderData
        ViewModel.successGetMyOrdersObservable.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: OrderCell.self)){ [weak self] (row,item,cell) in
            self?.loadingView.isHidden = true
            cell.selectionStyle = .none
            cell.cellConfigration(OrderModel: item)
        }.disposed(by: disposePag)
        
        // MARK: - Get myOrders  Request
        ViewModel.getMyOrders()
        
        Observable.zip(tableView.rx.itemSelected,tableView.rx.modelSelected(OrdersModelElement.self))
            .bind{[weak self] indexPath, model in
                guard let self = self else{return}
                guard let orderId = model.id else {return}
               let OrderDetailes = self.coordinator.mainNavigator.viewController(for: .orderDetailes(orderId: orderId))
                self.navigationController?.pushViewController(OrderDetailes, animated: true)
                
        }.disposed(by: disposePag)
        
    }
    
}


extension MyOrders :  UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
