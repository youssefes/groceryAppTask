//
//  OrderModel.swift
//  groceryApp
//
//  Created by youssef on 4/11/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation

// MARK: - OrdersModelElement
struct OrdersModelElement: Codable {
    let id: Int?
    let name, phoneNumber, timeToDeliver, shopper: String?
    let location: Location?
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let name: String?
    let count: Int?
}

// MARK: - Location
struct Location: Codable {
    let type: Int?
    let value: Value?
}

// MARK: - Value
struct Value: Codable {
    let latitude, longitude: Double?
}


typealias OrdersModel = [OrdersModelElement]


