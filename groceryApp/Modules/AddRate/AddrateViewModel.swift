//
//  AddrateViewModel.swift
//  groceryApp
//
//  Created by youssef on 4/11/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class AddrateViewModel {
    private let ordersRepository = OrdersRepository()
    private let dispoBag = DisposeBag()
       
       private let successSendReview : PublishSubject<ReviewModel> = .init()
       lazy var successsuccessSendReviewObservable : Observable<ReviewModel> = successSendReview.asObservable()
       
       func SendReview(parameters: Parameters){
           ordersRepository.sendReview(parameters: parameters).subscribe(onNext: { (ReviewRespond) in
               self.successSendReview.onNext(ReviewRespond)
           }, onError: { (error) in
               self.successSendReview.onError(error)
           }).disposed(by: dispoBag)
       }
       
}
