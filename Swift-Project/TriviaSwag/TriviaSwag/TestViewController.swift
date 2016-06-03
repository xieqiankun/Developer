//
//  TestViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/9/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class TestViewController: UIViewController,SimplePingDelegate {
    
    var pinger: SimplePing?
    var sendTimer: NSTimer?
    let hostName = "www.apple.com"


    override func viewDidLoad() {
        super.viewDidLoad()
              // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func test() {
        
        /*
        //let button1 = AlertButton(title: "aaaa", imageNames: [], style: .Normal,action: nil)
        let button2 = AlertButton(title: "aaa", imageNames: [], style: .Cancel,action: nil)
        
        let vc = StoryboardAlertViewControllerFactory().createAlertViewController([button2], title: "Slimy Connection!", message: "dasdasdasdjkflkadshfkadsfh adsfhadslkfh fasdfalks")
        presentViewController(vc, animated: true, completion: nil)
        */
        print("I am here")
        triviaCurrentUser = nil
//        let pinger = SimplePing(hostName: self.hostName)
//        self.pinger = pinger
//
//        pinger.delegate = self
//        pinger.start()
//        SimplePingClient.pingHost() { latency in
//            
//            print("Your latency is \(latency ?? "unknown")")
//        }
        
//        triviaFetchPurchesItems { (items, error) in
//            
//        }
        
        triviaFetchGifs { (store, error) in
            print(store?.correctGifs?[0].image)
        }
    }
    
    
    
    
    
    
    func sendPing() {
        self.pinger!.sendPingWithData(nil)
    }
    func stop() {
        NSLog("stop")
        self.pinger?.stop()
        self.pinger = nil
        
        self.sendTimer?.invalidate()
        self.sendTimer = nil
        
    }
    // MARK: pinger delegate callback
    
    func simplePing(pinger: SimplePing, didStartWithAddress address: NSData) {
        NSLog("pinging %@", TestViewController.displayAddressForAddress(address))
        
        // Send the first ping straight away.
        
        self.sendPing()
        
        // And start a timer to send the subsequent pings.
        
        assert(self.sendTimer == nil)
        self.sendTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(TestViewController.sendPing), userInfo: nil, repeats: true)
    }
    
    func simplePing(pinger: SimplePing, didFailWithError error: NSError) {
        NSLog("failed: %@", TestViewController.shortErrorFromError(error))
        
        self.stop()
    }
    
    func simplePing(pinger: SimplePing, didSendPacket packet: NSData, sequenceNumber: UInt16) {
        NSLog("#%u sent", sequenceNumber)
    }
    
    func simplePing(pinger: SimplePing, didFailToSendPacket packet: NSData, sequenceNumber: UInt16, error: NSError) {
        NSLog("#%u send failed: %@", sequenceNumber, TestViewController.shortErrorFromError(error))
    }
    
    func simplePing(pinger: SimplePing, didReceivePingResponsePacket packet: NSData, sequenceNumber: UInt16) {
        NSLog("#%u received, size=%zu", sequenceNumber, packet.length)
    }
    
    func simplePing(pinger: SimplePing, didReceiveUnexpectedPacket packet: NSData) {
        NSLog("unexpected packet, size=%zu", packet.length)
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
