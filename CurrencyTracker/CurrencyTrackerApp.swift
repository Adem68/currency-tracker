//
//  CurrencyTrackerApp.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 24.03.2022.
//

import SwiftUI

@main
struct CurrencyTrackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            EmptyView().frame(width: .zero, height: .zero)
        }
    }
}
