//
//  MenuBarCurrencyViewModel.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 25.03.2022.
//

import Combine
import Foundation
import SwiftUI

class MenuBarCurrencyViewModel: ObservableObject {
    @Published private(set) var name: String
    @Published private(set) var value: String
    @Published private(set) var color: Color
    @AppStorage("SelectedCurrencyType") private(set) var selectedCurrencyType = CurrencyType.dolar

    private let service: CurrencyService
    private var subscriptions = Set<AnyCancellable>()
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 4
        formatter.currencyCode = "TRY"
        formatter.currencySymbol = "₺"
        return formatter
    }()

    init(name: String = "",
         value: String = "",
         color: Color = .white,
         service: CurrencyService = .init()
    ) {
        self.name = name
        self.value = value
        self.color = color
        self.service = service
    }

    func subscribeToSocket() {
        service.currencyDictionarySubject
            .combineLatest(service.connectionStateSubject)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.updateView() }
            .store(in: &subscriptions)
    }

    func updateView() {
        self.color = .green
        let selectedCurrencyName = selectedCurrencyType.description
        let currencyValue = self.service.currencyDictionary[selectedCurrencyName]?.asDouble ?? 0
        let currencyValueText = self.currencyFormatter.string(from: NSNumber(value: currencyValue))
        self.name = selectedCurrencyName

        if self.service.isConnected {
            if currencyValue > 0 {
                self.value = currencyValueText ?? ""
            } else {
                self.value = "Güncelleniyor..."
            }
        } else {
            self.value = "İnternet yok"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.color = .white
        }
    }
}
