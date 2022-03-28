//
//  MenuBarCurrencyView.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 24.03.2022.
//

import SwiftUI

struct MenuBarCurrencyView: View {
    @ObservedObject var viewModel: MenuBarCurrencyViewModel

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: viewModel.prefixIcon)
                .foregroundColor(viewModel.prefixIconColor)

            VStack(alignment: .center, spacing: -2) {
                Text(viewModel.name)
                Text(viewModel.value)
                    .foregroundColor(viewModel.valueTextColor)
                    .bold()
            }
            .font(.caption)
        }
        .onChange(of: viewModel.selectedCurrencyType) { _ in
            viewModel.updateView()
        }
        .onAppear {
            viewModel.subscribeToSocket()
        }
    }
}

struct MenuBarCoinView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarCurrencyView(
            viewModel: .init(name: "Dolar", value: "50000", prefixIconColor: .green)
        )
    }
}
