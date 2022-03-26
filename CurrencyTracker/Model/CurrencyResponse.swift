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

// MARK: - M
struct CurrencyData: Decodable {
    let name: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case name = "k"
        case value = "s"
    }
}
