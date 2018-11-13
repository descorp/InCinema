//
//  Throttler.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 12/11/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import UIKit
import Foundation

public class Throttler {
    
    private let queue: DispatchQueue
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private var minimumDelay: TimeInterval
    
    init(miliseconds: TimeInterval, queue: DispatchQueue = DispatchQueue.global()) {
        self.minimumDelay = miliseconds
        self.queue = queue
    }
    
    func throttle(block: @escaping () -> ()) {
        workItem.cancel()
        workItem = DispatchWorkItem(){ [weak self] in
            self?.previousRun = Date()
            block()
        }

        let delay = previousRun.timeIntervalSinceNow > minimumDelay ? 0 : minimumDelay
        queue.asyncAfter(deadline: .now() + Double(delay), execute: workItem)
    }
}

private extension Date {
    static func miliseconds(from referenceDate: Date) -> Int {
        return Int((Date().timeIntervalSince(referenceDate) * 1000.0).rounded())
    }
}
