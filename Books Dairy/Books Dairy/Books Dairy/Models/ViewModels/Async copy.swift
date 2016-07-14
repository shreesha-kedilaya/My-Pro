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
    class func main(closer: AsyncCloser) {
        dispatch_async(dispatch_get_main_queue(), closer)
    }
    /// Asynchronous execution on a global queue and returns immediately
    class func global(priority: dispatch_queue_priority_t = DISPATCH_QUEUE_PRIORITY_DEFAULT,  closer: AsyncCloser) {
        dispatch_async(dispatch_get_global_queue(priority, 0), closer)
    }
    /// Asynchronous execution on a dispatch queue and returns after specified time interval
    class func after(interval: Double, closer: AsyncCloser) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * interval))
        
        dispatch_after(time, dispatch_get_main_queue(), closer)
    }
    
}
