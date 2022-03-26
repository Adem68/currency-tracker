//
//  CurrencyType.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 24.03.2022.
//

import Foundation

enum CurrencyType: String, Decodable, Identifiable, CaseIterable {
    case dolar = "USD"
    case euro = "EUR"
    case pound = "GBP"
    case bitcoin = "bitcoin"
    case quarterGold = "ceyrek-altin"
    case gramGold = "gram-altin"

    var id: Self { self}
    var description: String { rawValue.description }
}
