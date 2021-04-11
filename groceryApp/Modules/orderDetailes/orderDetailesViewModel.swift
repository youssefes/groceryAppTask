//
//  orderDetailesViewModel.swift
//  delivery
//
//  Created by youssef on 3/15/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
class orderDetailesViewModel {
    
    private var orderId : Int
    init(orderId : Int) {
        self.orderId = orderId
    }
    
    private let ordersRepository = OrdersRepository()
    private let dispoBag = DisposeBag()
    
    private let successGetOrder : PublishSubject<OrdersModelElement> = .init()
    lazy var successGetOrderObservable : Observable<OrdersModelElement> = successGetOrder.asObservable()
    
    private let successGetItemsOfOrder : PublishSubject<[Item]> = .init()
       lazy var successGetItemsOfOrderObservable : Observable<[Item]> = successGetItemsOfOrder.asObservable()
    
    func getOrderData(){
        
        let parameters: Parameters = [
            "id" : orderId
        ]
        ordersRepository.getOrderData(parameters: parameters).subscribe(onNext: { (OrderData) in
            self.successGetOrder.onNext(OrderData)
            guard let items = OrderData.items else {return}
            self.successGetItemsOfOrder.onNext(items)
        }, onError: { (error) in
            self.successGetOrder.onError(error)
        }).disposed(by: dispoBag)
    }
    
}
