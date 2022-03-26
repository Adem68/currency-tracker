//
//  PopoverCurrencyViewModel.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 25.03.2022.
//

import Combine
import Foundation
import SwiftUI

class PopoverCurrencyViewModel: ObservableObject {
    @Published private(set) var title: String
    @Published private(set) var subtitle: String
    @Published private(set) var currencyTypes: [CurrencyType]
    @AppStorage("SelectedCurrencyType") var selectedCurrencyType = CurrencyType.dolar

    private let service: CurrencyService
    private var subscriptions = Set<AnyCancellable>()

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "TRY"
        formatter.currencySymbol = "₺"
        return formatter
    }()

    init(title: String = "",
         subtitle: String = "",
         currencyTypes: [CurrencyType] = CurrencyType.allCases,
         service: CurrencyService = .init()
    ) {
        self.title = title
        self.subtitle = subtitle
        self.currencyTypes = currencyTypes
        self.service = service
    }

    func subscribeToSocket() {
        service.currencyDictionarySubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.updateView() }
            .store(in: &subscriptions)
    }


    func updateView() {  
        let selectedCurrencyName = selectedCurrencyType.description
        let currencyValue = self.service.currencyDictionary[selectedCurrencyName]?.asDouble ?? 0
        let currencyValueText = self.currencyFormatter.string(from: NSNumber(value: currencyValue))
        self.title = selectedCurrencyName

        if currencyValue > 0 {
            self.subtitle = currencyValueText ?? ""
        } else {
            self.subtitle = "Güncelleniyor"
        }
    }

    func valueText(for currencyType: CurrencyType) -> String {
        if let value = self.service.currencyDictionary[currencyType.description]?.asDouble, value > 0 {
            return self.currencyFormatter.string(from: NSNumber(value: value)) ?? ""
        } else {
            return "Güncelleniyor"
        }
    }

}
