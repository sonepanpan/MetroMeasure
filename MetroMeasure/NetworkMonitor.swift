//
//  NetworkMonitor.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/10/14.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
//    static let shared = NetworkMonitor()
    
    let queue = DispatchQueue(label: "Monitor")
    let monitor = NWPathMonitor()
    
    @Published var isConnected = false
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
}
