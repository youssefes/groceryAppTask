//
//  AddRateViewController.swift
//  groceryApp
//
//  Created by youssef on 4/11/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import Cosmos

class AddRateViewController: BaseWireFrame<AddrateViewModel> {

    @IBOutlet weak var RatingView: CosmosView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bind(ViewModel: AddrateViewModel) {
        ViewModel.successsuccessSendReviewObservable.subscribe(onNext: { [weak self] (reViewRespond) in
            guard let self = self  else {return}
            print(reViewRespond)
            self.dismiss(animated: true, completion: nil)
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposePag)
        
    }
    @IBAction func DoneBtn(_ sender: Any) {
        let rating = RatingView.rating
        let parameters : Parameters = [
            "Review" : rating
        ]
        viewModel.SendReview(parameters: parameters)
    }
    
    @IBAction func SkipBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
