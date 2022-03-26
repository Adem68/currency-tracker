//
//  Currency.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 24.03.2022.
//

import Foundation

struct Currency: Decodable {
    let name: CurrencyType
    let lastPrice: String
}
