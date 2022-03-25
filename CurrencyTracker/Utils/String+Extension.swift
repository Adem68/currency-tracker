//
//  String+Extension.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 25.03.2022.
//

import Foundation

extension String {
    var asDouble: Double {
        let pure = self.replacingOccurrences(of: ".", with: "")
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = ","
        if let result = numberFormatter.number(from: pure) {
            return result.doubleValue
        }
        return 0
    }
}
