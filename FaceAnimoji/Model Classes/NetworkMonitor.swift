//
//  NetworkMonitor.swift
//  FaceAnimoji
//
//  Created by Justin Peters on 5/11/21.
//  Copyright © 2021 ashutosh.dingankar. All rights reserved.
//


//This class is used to check if the app is currently connected to the internet.
//It is needed to prevent crashes associated with utilizing the VERN API without connecting to the internet
//This Script was scrapped since it didn't perform the needs I wanted to.
//While the value would change in real time in this class, I needed that value changed to be picked up in the main menu class.
//I set up a didset property for a bool that was equal to the isConnected bool in this script, but when isConnected changed, it did not trigger the didset propperty for the mainmenu class like I hoped.
//I instead needed to put this network functionality into the main menu view controller
import Foundation
import Network

final class NetworkMonitor{
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    static let monitor = NWPathMonitor()
    
    public private(set) var isConnected: Bool = false
    
    public private(set) var connectionType: ConnectionType? = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
//    private init(){
//        monitor = NWPathMonitor()
//    }
    
    public func startMonitoring(){
        NetworkMonitor.monitor.start(queue: queue)
        NetworkMonitor.monitor.pathUpdateHandler = {[weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.getConnectionType(path)
//            if(self!.isConnected){
//                print("Connected to the internet")
//            }
//            else{
//                print("Not connected")
//            }
        }
    }
    
    public func stopMonitoring(){
        NetworkMonitor.monitor.cancel()
    }
    
    private func getConnectionType(_ path:NWPath){
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        }
        else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        }
        else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        }
        else{
            connectionType = .unknown
        }
    }
}
