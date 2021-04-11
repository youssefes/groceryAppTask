//
//  SignUpRepoitory.swift
//  delivery
//
//  Created by youssef on 3/13/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class OrdersRepository {
    let networkClient : NetworkClient
    init(networkClient : NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getMyOrders() -> Observable<OrdersModel>{
        Observable<OrdersModel>.create { [weak self] (items) -> Disposable in
            self?.networkClient.performRequest(OrdersModel.self, router: OrderRouter.MyOrders) { (resulte) in
                switch resulte{
                case .success(let data):
                    items.onNext(data)
                    items.onCompleted()
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
    func getShoppers() -> Observable<[Item]>{
           Observable<[Item]>.create { [weak self] (items) -> Disposable in
               self?.networkClient.performRequest([Item].self, router: OrderRouter.Shoppers) { (resulte) in
                   switch resulte{
                   case .success(let data):
                       items.onNext(data)
                       items.onCompleted()
                   case .failure(let error):
                       items.onError(error)
                   }
               }
               return Disposables.create()
           }
       }
    
    func getOrderData(parameters: Parameters) -> Observable<OrdersModelElement>{
          Observable<OrdersModelElement>.create { [weak self] (items) -> Disposable in
              self?.networkClient.performRequest(OrdersModelElement.self, router: OrderRouter.getOsrderdata(parameters: parameters)) { (resulte) in
                  switch resulte{
                  case .success(let data):
                      items.onNext(data)
                      items.onCompleted()
                  case .failure(let error):
                      items.onError(error)
                  }
              }
              return Disposables.create()
          }
      }
    
    
    func sendReview(parameters: Parameters) -> Observable<ReviewModel>{
        Observable<ReviewModel>.create { [weak self] (items) -> Disposable in
            self?.networkClient.performRequest(ReviewModel.self, router: OrderRouter.Reviews(parameters: parameters)) { (resulte) in
                switch resulte{
                case .success(let data):
                    items.onNext(data)
                    items.onCompleted()
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
}
