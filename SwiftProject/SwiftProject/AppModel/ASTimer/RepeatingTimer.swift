//
//  RepeatingTimer.swift
//  Dojo
//
//  Created by Ankit Saini on 21/10/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

/// RepeatingTimer mimics the API of DispatchSourceTimer but in a way that prevents
/// crashes that occur from calling resume multiple times on a timer that is
/// already resumed (noted by https://github.com/SiftScience/sift-ios/issues/52

import Foundation

/// This will be used to start a repeating timer.
class RepeatingTimer {
    
    /// DispatchTimeInterval
    let timeInterval: DispatchTimeInterval
    
    /// Repeating Queue: DispatchQueue
    private let repeatingQueue = DispatchQueue(label: "com.app.queue_repeattimer", qos: .background)
    
    /// Initialize the RepeatingTimer
    ///
    /// - Parameter timeInterval: DispatchTimeInterval
    init(timeInterval: DispatchTimeInterval) {
        self.timeInterval = timeInterval
    }
    
    /// DispatchSourceTimer
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource(queue: repeatingQueue)
        t.schedule(deadline: .now(), repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    /// eventHandler
    var eventHandler: (() -> Void)?
    
    /// State Enum
    private enum State {
        /// suspended
        case suspended
        
        /// resumed
        case resumed
    }
    
    /// state
    private var state: State = .suspended
    
    /// deinit
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here
         https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }
    
    /// resume timer
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    /// suspend timer
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
