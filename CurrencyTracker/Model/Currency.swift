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

    enum CurrencyType: String, Decodable {
        case dolar = "dolar"
        case euro = "euro"
        case quarterGold = "ceyrek-altin"
        case gramGold = "gram-altin"
        case brentGasoline = "brent-petrol"
    }

    enum CodingKeys: String, CodingKey {
        case name = "SecuritySlug"
        case lastPrice = "LastPrice"
    }
}
