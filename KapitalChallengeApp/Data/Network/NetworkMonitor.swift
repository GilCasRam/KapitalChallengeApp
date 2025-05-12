//
//  NetworkMonitor.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import Network

/// A singleton class used to monitor the network connectivity status.
final class NetworkMonitor {

    /// Shared instance of the network monitor (singleton pattern)
    static let shared = NetworkMonitor()

    /// Internal network path monitor provided by Apple's Network framework
    private let monitor = NWPathMonitor()

    /// Dispatch queue on which the monitor will run
    private let queue = DispatchQueue(label: "NetworkMonitor")

    /// Indicates whether the device is currently connected to the internet
    private(set) var isConnected: Bool = true

    /// Private initializer to ensure only one instance is created
    private init() {
        // Set the handler that gets called whenever the network status changes
        monitor.pathUpdateHandler = { path in
            // Update the isConnected property based on the current network status
            self.isConnected = path.status == .satisfied
        }

        // Start monitoring on the specified queue
        monitor.start(queue: queue)
    }
}

