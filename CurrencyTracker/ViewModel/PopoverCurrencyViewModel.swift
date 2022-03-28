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
    @Published private(set) var titleTextColor: Color

    @Published private(set) var currencyTypes: [CurrencyType]
    @AppStorage("SelectedCurrencyType") var selectedCurrencyType = CurrencyType.dolar

    private let service: CurrencyService
    private var subscriptions = Set<AnyCancellable>()

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        formatter.currencySymbol = "₺"
        return formatter
    }()

    init(title: String = "",
         subtitle: String = "",
         titleTextColor: Color = .white,
         currencyTypes: [CurrencyType] = CurrencyType.allCases,
         service: CurrencyService = .init()
    ) {
        self.title = title
        self.subtitle = subtitle
        self.titleTextColor = .white
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
        if self.service.isConnected {
            if let selectedCurrency = self.service.currencyDictionary[selectedCurrencyType.description] {
                self.title = selectedCurrency.name

                if selectedCurrency.value > 0 {
                    self.currencyFormatter.maximumFractionDigits = 4
                    self.subtitle = self.currencyFormatter.string(from: NSNumber(value: selectedCurrency.value))!
                    self.titleTextColor = getChangeRatioColor(for: selectedCurrencyType)
                } else {
                    self.subtitle = "Güncelleniyor"
                }
            }
        } else {
            self.subtitle = "İnternet yok..."
        }
    }

    func getChangeRatio(for currencyType: CurrencyType) -> String {
        if let changeRatio = self.service.currencyDictionary[currencyType.description]?.changeRatio {
            return "%\(changeRatio.description)"
        } else { return "" }
    }

    func getChangeRatioColor(for currencyType: CurrencyType) -> Color {
        if let changeRatio = self.service.currencyDictionary[currencyType.description]?.changeRatio {
            if changeRatio == 0 { return .white }
            return changeRatio > 0 ? .green : .red
        } else { return .white }
    }

    func valueText(for currencyType: CurrencyType) -> String {
        if let currency = self.service.currencyDictionary[currencyType.description] {
            if currency.value > 0 {
                self.currencyFormatter.maximumFractionDigits = 2
                return self.currencyFormatter.string(from: NSNumber(value: currency.value)) ?? ""
            } else {
                return "Güncelleniyor"
            }
        } else {
            return "Veri yok"
        }
    }
}
