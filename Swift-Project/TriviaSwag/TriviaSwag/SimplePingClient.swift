//
//  SimplePingClient.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/10/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import Foundation

public typealias SimplePingClientCallback = (String?)->()

class SimplePingClient: NSObject {
    static let singletonPC = SimplePingClient()
    
    let hostName = "www.google.com"
    
    private var resultCallback: SimplePingClientCallback?
    
    var dict = [Int: NSDate]()
    
    var pinger: SimplePing?
    var sendTimer: NSTimer?
    
    static func pingHost(resultCallback callback: SimplePingClientCallback?) {
        singletonPC.pingHost(resultCallback: callback)
    }
    
    private func pingHost(resultCallback callback: SimplePingClientCallback?) {
        resultCallback = callback
        dict.removeAll()
        let pinger = SimplePing(hostName: self.hostName)
        self.pinger = pinger
        pinger.addressStyle = .ICMPv4
        pinger.delegate = self
        pinger.start()
    }
    
    /// Called by the table view selection delegate callback to stop the ping.
    func stop() {
        NSLog("stop")
        self.pinger?.stop()
        self.pinger = nil
        
        self.sendTimer?.invalidate()
        self.sendTimer = nil
        
    }
    /// Sends a ping.
    ///
    /// Called to send a ping, both directly (as soon as the SimplePing object starts up) and
    /// via a timer (to continue sending pings periodically).
    func sendPing() {
        self.pinger!.sendPingWithData(nil)
    }
    
    // MARK: utilities
    
    /// Returns the string representation of the supplied address.
    ///
    /// - parameter address: Contains a `(struct sockaddr)` with the address to render.
    ///
    /// - returns: A string representation of that address.
    
    static func displayAddressForAddress(address: NSData) -> String {
        var hostStr = [Int8](count: Int(NI_MAXHOST), repeatedValue: 0)
        
        let success = getnameinfo(
            UnsafePointer(address.bytes),
            socklen_t(address.length),
            &hostStr,
            socklen_t(hostStr.count),
            nil,
            0,
            NI_NUMERICHOST
            ) == 0
        let result: String
        if success {
            result = String.fromCString(hostStr)!
        } else {
            result = "?"
        }
        return result
    }
    
    /// Returns a short error string for the supplied error.
    ///
    /// - parameter error: The error to render.
    ///
    /// - returns: A short string representing that error.
    
    static func shortErrorFromError(error: NSError) -> String {
        if error.domain == kCFErrorDomainCFNetwork as String && error.code == Int(CFNetworkErrors.CFHostErrorUnknown.rawValue) {
            if let failureObj = error.userInfo[kCFGetAddrInfoFailureKey] {
                if let failureNum = failureObj as? NSNumber {
                    if failureNum.intValue != 0 {
                        let f = gai_strerror(failureNum.intValue)
                        if f != nil {
                            return String.fromCString(f)!
                        }
                    }
                }
            }
        }
        if let result = error.localizedFailureReason {
            return result
        }
        return error.localizedDescription
    }

}

extension SimplePingClient: SimplePingDelegate {
   
    // MARK: pinger delegate callback
    
    func simplePing(pinger: SimplePing, didStartWithAddress address: NSData) {
        print("pinging \( SimplePingClient.displayAddressForAddress(address))")
        NSLog("  ")
        // Send the first ping straight away.
        
        self.sendPing()
        // And start a timer to send the subsequent pings.
        if self.sendTimer != nil{
            self.sendTimer?.invalidate()
            self.sendTimer = nil
        }
        assert(self.sendTimer == nil)
        self.sendTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(SimplePingClient.sendPing), userInfo: nil, repeats: true)
    }
    
    func simplePing(pinger: SimplePing, didFailWithError error: NSError) {
        NSLog("failed: %@", SimplePingClient.shortErrorFromError(error))
        
        self.stop()
    }
    
    func simplePing(pinger: SimplePing, didSendPacket packet: NSData, sequenceNumber: UInt16) {
        NSLog("#%u sent", sequenceNumber)
        
        dict[Int(sequenceNumber)] = NSDate()
    }
    
    func simplePing(pinger: SimplePing, didFailToSendPacket packet: NSData, sequenceNumber: UInt16, error: NSError) {
        NSLog("#%u send failed: %@", sequenceNumber, TestViewController.shortErrorFromError(error))
        
    }
    
    func simplePing(pinger: SimplePing, didReceivePingResponsePacket packet: NSData, sequenceNumber: UInt16) {
        NSLog("#%u received, size=%zu", sequenceNumber, packet.length)
        
        if let date = dict[Int(sequenceNumber)]{
            self.stop()
            let latency = NSDate().timeIntervalSinceDate(date) * 1000
            resultCallback?(String(format: "%.f", latency))
        }
        

    }
    
    func simplePing(pinger: SimplePing, didReceiveUnexpectedPacket packet: NSData) {
        NSLog("unexpected packet, size=%zu", packet.length)
        
    }



}