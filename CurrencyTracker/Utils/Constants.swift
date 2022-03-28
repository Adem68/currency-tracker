//
//  Constants.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 25.03.2022.
//

import Foundation

public struct Constants {
    static let menuBarAppWidth: CGFloat = 128
    static let popoverContentSize: NSSize = .init(width: 320, height: 360)
    static var applicationVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    static var appVersion: String {
        return "v\(applicationVersion)"
    }

    static let repoURL: URL = URL(string: "https://github.com/Adem68/currency-tracker")!

    static let websocketURLS = [
        "wss://ws1.doviz.com:5224/",
        "wss://ws2.doviz.com:5224/",
        "wss://ws3.doviz.com:5224/",
        "wss://ws4.doviz.com:5224/",
        "wss://ws5.doviz.com:5224/",
        "wss://ws6.doviz.com:5224/",
        "wss://ws7.doviz.com:5224/",
        "wss://ws8.doviz.com:5224/",
        "wss://ws9.doviz.com:5224/",
        "wss://ws10.doviz.com:5224/"
    ]

    static let websocketProcotols = ["nokta-chat-json"]
    
    static let currencies = [
        "gram-altin",
        "ceyrek-altin",
        "USD",
        "EUR",
        "GBP",
    ]
}
