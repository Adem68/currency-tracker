//
//  AppDelegate.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 24.03.2022.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarCurrencyViewModel: MenuBarCurrencyViewModel!
    var popoverCurrencyViewModel: PopoverCurrencyViewModel!
    var currencyService = CurrencyService()
    var statusItem: NSStatusItem!
    let popover = NSPopover()

    private lazy var contentView: NSView? = {
        let view = (statusItem.value(forKey: "window") as? NSWindow)?.contentView
        return view
    }()

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupCurrencyService()
        setupMenuBar()
        setupPopover()
    }

    func setupCurrencyService() {
        currencyService.connect()
        currencyService.startMonitorNetworkConnectivity()
    }
}

// MARK: - MENU BAR

extension AppDelegate {
    func setupMenuBar() {
        menuBarCurrencyViewModel = MenuBarCurrencyViewModel(service: currencyService)
        statusItem = NSStatusBar.system.statusItem(withLength: Constants.menuBarAppWidth)
        guard let contentView = self.contentView,
              let menuButton = statusItem.button else { return }

        let hostingView = NSHostingView(rootView: MenuBarCurrencyView(viewModel: menuBarCurrencyViewModel))
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingView)

        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hostingView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])

        menuButton.action = #selector(clickedToMenuButton)
    }

    @objc
    func clickedToMenuButton() {
        if popover.isShown {
            popover.performClose(nil)
            return
        }

        guard let menuButton = statusItem.button else { return }
        let positioningView = NSView(frame: menuButton.bounds)
        positioningView.identifier = NSUserInterfaceItemIdentifier("positioningView")
        menuButton.addSubview(positioningView)

        popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .maxY)
        menuButton.bounds = menuButton.bounds.offsetBy(dx: .zero, dy: menuButton.bounds.height)
        popover.contentViewController?.view.window?.makeKey()
    }
}

// MARK: - POPOVER

extension AppDelegate: NSPopoverDelegate {
    func setupPopover() {
        popoverCurrencyViewModel = .init(service: currencyService)
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = Constants.popoverContentSize
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(
            rootView: PopoverCurrencyView(viewModel: popoverCurrencyViewModel).frame(maxWidth: .infinity, maxHeight: .infinity).padding()
        )
        popover.delegate = self
    }

    func popoverDidClose(_ notification: Notification) {
        let positioningView = statusItem.button?.subviews.first {
            $0.identifier == NSUserInterfaceItemIdentifier("positioningView")
        }

        positioningView?.removeFromSuperview()
    }
}
