//
//  BaseWireFrame.swift
//  Opportunities
//
//  Created by youssef on 12/14/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire

//import NVActivityIndicatorView

class BaseWireFrame <T>: UIViewController {
    var viewModel : T!
    var coordinator : Coordinator!
  lazy var disposePag : DisposeBag = {
        return DisposeBag()
    }()
    init(ViewModel : T, coordinator : Coordinator) {
        self.viewModel = ViewModel
        self.coordinator = coordinator
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        bind(ViewModel: viewModel)
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(ViewModel : T) {
        fatalError("please Override the bind Function")
        
    }
    
}
