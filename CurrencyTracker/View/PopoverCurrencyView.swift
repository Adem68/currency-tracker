//
//  PopoverCurrencyView.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 24.03.2022.
//

import LaunchAtLogin
import Foundation
import SwiftUI

struct PopoverCurrencyView: View {
    @ObservedObject var viewModel: PopoverCurrencyViewModel
    @ObservedObject private var launchAtLogin = LaunchAtLogin.observable

    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Text(viewModel.title)
                    .font(.largeTitle)
                Text(viewModel.subtitle)
                    .foregroundColor(viewModel.titleTextColor)
                    .font(.title.bold())
            }

            Divider()

            Picker("Bir kur seç!", selection: $viewModel.selectedCurrencyType) {
                ForEach(viewModel.currencyTypes) { type in
                    HStack {
                        Text(type.description)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.headline)
                        Spacer()
                        HStack {
                            Text(viewModel.getChangeRatio(for: type))
                                .foregroundColor(viewModel.getChangeRatioColor(for: type))
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        Spacer()

                        Text(viewModel.valueText(for: type))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.body)
                    }
                    .tag(type)
                }
            }
            .pickerStyle(RadioGroupPickerStyle())
            .labelsHidden()

            Divider()

            Toggle("Açılışta başlat", isOn: $launchAtLogin.isEnabled)

            Button("Çıkış Yap") {
                NSApp.terminate(self)
            }

            Divider()

            HStack(spacing: 12) {
                Link(destination: Constants.repoURL) {
                    Text("GitHub")
                }

                Text(Constants.appVersion)
                    .foregroundColor(.gray)
            }.padding(.bottom, 12)
        }
        .onChange(of: viewModel.selectedCurrencyType) { _ in
            viewModel.updateView()
        }
        .onAppear {
            viewModel.subscribeToSocket()
        }
    }
}


struct PopoverCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverCurrencyView(
            viewModel: PopoverCurrencyViewModel(title: "Dolar", subtitle: "25")
        )
    }
}
