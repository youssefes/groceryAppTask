//
//  signRouter.swift
//  Opportunities
//
//  Created by youssef on 12/21/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation
import Alamofire

enum OrderRouter: APIRouter {

    case MyOrders
    case getOsrderdata(parameters : Parameters)
    case Shoppers
    case Reviews(parameters : Parameters)
    case RegisterOrder(parameters : Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .MyOrders,.Shoppers:
            return .get
        case .getOsrderdata, .Reviews, .RegisterOrder:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .MyOrders, .getOsrderdata, .RegisterOrder:
            return "Orders"
        case .Shoppers:
            return "Shoppers"
        case .Reviews:
            return "Reviews"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .MyOrders, .Shoppers:
            return nil
        case .getOsrderdata(let parameters):
            return parameters
        case .Reviews(let parameters):
            return parameters
        case .RegisterOrder(let parameters):
            return parameters
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .MyOrders ,  .getOsrderdata, .Shoppers, .Reviews, .RegisterOrder:
            return JSONEncoding.default
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .MyOrders , .getOsrderdata , .Shoppers, .Reviews, .RegisterOrder:
            let header = HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json; charset=UTF-8")])
            return header
        }
    }

}
