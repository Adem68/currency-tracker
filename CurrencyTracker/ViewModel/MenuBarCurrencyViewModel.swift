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
    @Published private(set) var prefixIcon: String
    @Published private(set) var name: String
    @Published private(set) var value: String
    @Published private(set) var prefixIconColor: Color
    @Published private(set) var valueTextColor: Color

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

    init(
        name: String = "",
        value: String = "",
        valueTextColor: Color = .white,
        prefixIcon: String = "exclamationmark.triangle",
        prefixIconColor: Color = .white,
        service: CurrencyService = .init()
    ) {
        self.name = name
        self.value = value
        self.valueTextColor = valueTextColor
        self.prefixIcon = prefixIcon
        self.prefixIconColor = prefixIconColor
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
        if self.service.isConnected {
            if let selectedCurrency = self.service.currencyDictionary[selectedCurrencyType.description] {
                self.name = selectedCurrency.name

                if selectedCurrency.value > .zero {
                    self.value = self.currencyFormatter.string(from: NSNumber(value: selectedCurrency.value))!

                    let isIncreased: Bool = selectedCurrency.changeRatio > .zero
                    self.prefixIcon = isIncreased ? "triangle.fill" : "arrowtriangle.down.fill"
                    
                    let color: Color = isIncreased ? .green : .red
                    self.prefixIconColor = color
                    self.valueTextColor = color
                } else {
                    self.value = "Güncelleniyor..."
                    self.prefixIcon = "goforward"
                }

            }
        } else {
            self.value = "İnternet yok..."
            self.prefixIcon = "exclamationmark.triangle"
            self.prefixIconColor = .red
            self.valueTextColor = .red
        }
    }
}
