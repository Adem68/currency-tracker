//
//  Constants.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 25.03.2022.
//

import Foundation

public struct Constants {
    static let websocketURL: URL = URL(string: "wss://nc.ciner.com.tr/sub/dot")!
    static let menuBarAppWidth: CGFloat = 128
    static let popoverContentSize: NSSize = .init(width: 260, height: 300)
    static let currencyURL = "https://www.bloomberght.com/doviz/"
    static let goldenURL = "https://www.bloomberght.com/altin/"
    static let commodityURL = "https://www.bloomberght.com/emtia/"
    static var applicationVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    static var appVersion: String {
        return "v\(applicationVersion)"
    }
}
