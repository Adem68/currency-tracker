//
//  CurrencyService.swift
//  CurrencyTracker
//
//  Created by Adem Özcan on 24.03.2022.
//

import Combine
import Foundation
import Network

class CurrencyService: NSObject {
    private let session = URLSession(configuration: .default)
    private var wsTask: URLSessionWebSocketTask?
    private var pingTryCount = 0

    let currencyDictionarySubject = CurrentValueSubject<[String: Currency], Never>([:])
    var currencyDictionary: [String: Currency] { currencyDictionarySubject.value }

    let connectionStateSubject = CurrentValueSubject<Bool, Never>(false)
    var isConnected: Bool { connectionStateSubject.value }

    private let monitor = NWPathMonitor()

    deinit {
        currencyDictionarySubject.send(completion: .finished)
        connectionStateSubject.send(completion: .finished)
    }

    func connect() {
        let websocketURL = URL(string: Constants.websocketURLS.randomElement()!)!
        wsTask = session.webSocketTask(with: websocketURL, protocols: Constants.websocketProcotols)
        wsTask?.delegate = self
        wsTask?.resume()

        let randomUser = "/webkullanici_\(Int.random(in: 100..<1000))"
        let dictionary: [String : Any] = [
            "action": "auth",
            "data": [
                "username": "",
                "password": "",
                "joinTo": "info@\(Constants.currencies.joined(separator: ",")),\(randomUser)"
            ]
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let message = URLSessionWebSocketTask.Message.data(jsonData)
            wsTask?.send(message) { error in
                if let error = error {
                    debugPrint("WebSocket couldn’t send message because: \(error)")
                }
            }
        } catch {
            debugPrint("Error encoding message: \(error.localizedDescription)")
        }

        self.receiveMessage()
        self.schedulePing()
    }

    func startMonitorNetworkConnectivity() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            if path.status == .satisfied, self.wsTask == nil {
                self.connect()
            }

            if path.status != .satisfied {
                self.clearConnection()
            }
        }
        monitor.start(queue: .main)
    }

    private func receiveMessage() {
        wsTask?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    debugPrint("Received text message: \(text)")
                    if let data = text.data(using: .utf8) {
                        self.onReceiveData(data)
                    }
                case .data(let data):
                    debugPrint("Received binary message: \(data)")
                    self.onReceiveData(data)
                default: break
                }
                self.receiveMessage()
            case .failure(let error):
                debugPrint("Failed to receive message: \(error.localizedDescription)")
            }
        }
    }

    private func onReceiveData(_ data: Data) {
        guard let currencyData = try? JSONDecoder().decode(CurrencyResponse.self, from: data) else {
            return
        }

        var newDictionary = [String: Currency]()
        let currency = currencyData.data
        
        newDictionary[currency.name.lowercased()] = Currency(name: currency.name,
                                                             value: currency.value,
                                                             changeRatio: currency.changeRatio)

        let mergedDictionary = currencyDictionary.merging(newDictionary) { $1 }
        currencyDictionarySubject.send(mergedDictionary)
        debugPrint(currencyDictionarySubject.value)
    }

    private func schedulePing() {
        let identifier = self.wsTask?.taskIdentifier ?? -1
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self,
                  let task = self.wsTask,
                  task.taskIdentifier == identifier
            else {
                return
            }

            if task.state == .running, self.pingTryCount < 2 {
                self.pingTryCount += 1
                task.sendPing { [weak self] error in
                    if let error = error {
                        debugPrint("Ping failed: \(error.localizedDescription)")
                    } else if self?.wsTask?.taskIdentifier == identifier {
                        self?.pingTryCount = 0
                    }
                }
                self.schedulePing()
            } else {
                self.reconnect()
            }
        }
    }

    private func reconnect() {
        self.clearConnection()
        self.connect()
    }

    func clearConnection() {
        self.wsTask?.cancel()
        self.wsTask = nil
        self.pingTryCount = 0
        self.connectionStateSubject.send(false)
    }
}

extension CurrencyService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        self.connectionStateSubject.send(true)
    }

    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        self.connectionStateSubject.send(false)
    }
}
