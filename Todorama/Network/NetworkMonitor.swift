//
//  NetworkMonitor.swift
//  Todorama
//
//  Created by 최정안 on 3/22/25.
//

import Foundation
import Network
import RxSwift

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    private let innerStatus = BehaviorSubject<Bool>(value: true)
    
    var currentStatus: Observable<Bool> {
        return innerStatus.asObservable()
    }
    
    init(){}
    func startNetworkMonitor(){
        monitor.pathUpdateHandler = {[weak self] path in
            guard let self = self else {return}
            if path.status == .satisfied {
                self.innerStatus.onNext(true)
            } else {
                self.innerStatus.onNext(false)
            }
        }
        monitor.start(queue: queue)
    }
    func stopNetworkMonitor() {
            monitor.cancel()
        }
}

