//
//  CurrencyResponse.swift
//  Kur Takibi
//
//  Created by Adem Özcan on 26.03.2022.
//

import Foundation

// MARK: - CurrencyResponse
struct CurrencyResponse: Decodable {
    let data: CurrencyData

    enum CodingKeys: String, CodingKey {
        case data = "m"
    }
}

// MARK: - CurrencyData
struct CurrencyData: Decodable {
    let name: String
    let value: Double
    let changeRatio: Double

    enum CodingKeys: String, CodingKey {
        case name = "k"
        case value = "sn"
        case changeRatio = "cn"
    }
}
