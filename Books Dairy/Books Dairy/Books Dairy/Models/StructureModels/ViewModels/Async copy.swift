//
//  Async.swift
//  Media
//
//  Created by Y Media Labs on 10/5/15.
//  Copyright © 2015 Y Media Labs. All rights reserved.
//

import Foundation
/// Completion handler for Async class
typealias AsyncCloser = () -> ()

/** For handling Asynchronise API calls
 
 - Customized methods to handle API response
 
 */
final class Async {
    /// Asynchronous execution on a dispatch queue and returns immediately
    class func main(_ closer: @escaping AsyncCloser) {
        DispatchQueue.main.async(execute: closer)
    }
    /// Asynchronous execution on a global queue and returns immediately
    class func global(_ priority: dispatch_queue_priority_t = DispatchQueue.GlobalQueuePriority.default,  closer: AsyncCloser) {
        DispatchQueue.global(priority: priority).async(execute: closer)
    }
    /// Asynchronous execution on a dispatch queue and returns after specified time interval
    class func after(_ interval: Double, closer: @escaping AsyncCloser) {
        let time = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * interval)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: closer)
    }
    
}
