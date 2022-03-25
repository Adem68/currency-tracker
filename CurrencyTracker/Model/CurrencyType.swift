//
//  CurrencyType.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 24.03.2022.
//

import Foundation

enum CurrencyType: String, Identifiable, CaseIterable {
    case dolar = "dolar"
    case euro = "euro"
    case quarterGold = "ceyrek-altin"
    case gramGold = "gram-altin"
    case brentGasoline = "brent-petrol"

    var id: Self { self}
    var description: String { rawValue.description }
    var url: URL {
        switch self {
        case .dolar, .euro:
            return URL(string: Constants.currencyURL + rawValue)!
        case .quarterGold, .gramGold:
            return URL(string: Constants.goldenURL + rawValue)!
        case .brentGasoline:
            return URL(string: Constants.commodityURL + rawValue)!
        }
    }
}
