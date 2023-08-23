//
//  NetworkMonitor.swift
//  Travelify
//
//  Created by Minh Tan Vu on 23/08/2023.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
//    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
//            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                print("We're connected!")
                // post connected notification
            } else {
                print("No connection.")
                DispatchQueue.main.async {
                    AppDelegate.scene?.routeToNoInternetAccess()
                }
            }
//            print(path.isExpensive)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
