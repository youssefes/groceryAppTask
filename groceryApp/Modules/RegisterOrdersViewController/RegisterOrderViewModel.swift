//
//  RegisterOrderViewModel.swift
//  groceryApp
//
//  Created by youssef on 4/13/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class RegisterOrderViewModel{
    
    private let ordersRepository = OrdersRepository()
    private let dispoBag = DisposeBag()
    
    private let successGetShopper : PublishSubject<[Item]> = .init()
    lazy var successGetShopperObservable : Observable<[Item]> = successGetShopper.asObservable()
    
    private let successRegisterOrder : PublishSubject<OrdersModelElement> = .init()
    lazy var ssuccessRegisterOrderObservable : Observable<OrdersModelElement> = successRegisterOrder.asObservable()
    
    
    func getShopper(){
        ordersRepository.getShoppers().subscribe(onNext: {[weak self] (Shopper) in
            guard let self = self else {return}
            self.successGetShopper.onNext(Shopper)
        }, onError: { (error) in
            self.successGetShopper.onError(error)
        }).disposed(by: dispoBag)
    }
    
    func RegisterOrder(parameters : Parameters){
        ordersRepository.RegisterOrder(parameters: parameters).subscribe(onNext: {[weak self] (Shopper) in
            guard let self = self else {return}
            self.successRegisterOrder.onNext(Shopper)
            }, onError: { (error) in
                self.successGetShopper.onError(error)
        }).disposed(by: dispoBag)
    }
    
}
