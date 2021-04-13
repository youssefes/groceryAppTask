//
//  MainNavigator.swift
//  Opportunities
//
//  Created by youssef on 12/9/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation
import UIKit

class MainNavigator : Navigator {
    
    var coordinator: Coordinator
    
    enum Destination {
        case OrdersViewController
        case orderDetailes(orderId : Int)
        case AddRate
        case ShowMap
        case RegisterOrder
 
    }
    required init(coordintor: Coordinator) {
        self.coordinator = coordintor
    }
    
    func viewController(for destination: MainNavigator.Destination) -> UIViewController {
        
        switch destination {
        case .OrdersViewController:
             let orderViewModel = MyOrdersViewModel()
            let view = MyOrders(ViewModel: orderViewModel, coordinator: coordinator)
            return view
        case .orderDetailes(let orderId):
            let orderDetaileViewModel = orderDetailesViewModel(orderId: orderId)
            let view = orderDetailesViewController(ViewModel: orderDetaileViewModel, coordinator: coordinator)
            return view
        case .AddRate:
            let addRateViewModel = AddrateViewModel()
            let view = AddRateViewController(ViewModel: addRateViewModel, coordinator: coordinator)
            return view
        case .ShowMap:
            let mapviewModel = mapViewModel()
            let view = mapViewController(ViewModel: mapviewModel, coordinator: coordinator)
            return view
        case .RegisterOrder:
            let RegisterviewModel = RegisterOrderViewModel()
            let view = RegisterOrdersViewController(ViewModel: RegisterviewModel, coordinator: coordinator)
            return view
        }
    }
    
}
