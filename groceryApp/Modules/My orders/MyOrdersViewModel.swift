//
//  MyOrdersViewModel.swift
//  groceryApp
//
//  Created by youssef on 4/11/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
class MyOrdersViewModel {
    
    private let ordersRepository = OrdersRepository()
    private let dispoBag = DisposeBag()
    
    private let successGetMyOrders : PublishSubject<OrdersModel> = .init()
    lazy var successGetMyOrdersObservable : Observable<OrdersModel> = successGetMyOrders.asObservable()
    
    func getMyOrders(){
        ordersRepository.getMyOrders().subscribe(onNext: { (MyOrders) in
            self.successGetMyOrders.onNext(MyOrders)
        }, onError: { (error) in
            self.successGetMyOrders.onError(error)
        }).disposed(by: dispoBag)
    }
    
    
    func getShopper(){
        ordersRepository.getShoppers().subscribe(onNext: { (Shopper) in
            print(Shopper)
        }, onError: { (error) in
             print(error)
        }).disposed(by: dispoBag)
    }
}
