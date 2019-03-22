//
//  SteadyCameraManager.swift
//
//  Created by Terry Wang on 3/19/19.
//  Copyright © 2019 Terry Wang. All rights reserved.
//


import CoreMotion

/**
 A class that detects whether the current device is steady or not.
 - Remark: Use start(), and stop() to start and stop the CoreMotion manager and receive device acceleration updates.
 Use isSteady to find out if the device is currently steady.
 */
public class SteadyDeviceDetector {

    /// Threshold for variance between accelerometer reads stored in the pastAccelerometerReads property.
    public let varianceThreshold = (x: 0.02, y: 0.02, z: 0.02)

    /// Operation queue to handle listening to accelerometer data.
    private lazy var operationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "SteadyDeviceDetectorOperationQueue"
        return queue
    }()

    /// Past 2 accelerometer reads of type CMAccelerometerData?
    public var pastAccelerometerReads: (current: CMAccelerometerData?, last: CMAccelerometerData?)

    /// Calculates whether the device is currently stable.
    public var isSteady: Bool {
        guard let current = pastAccelerometerReads.current, let last = pastAccelerometerReads.last
            else { return false }
        return abs(current.acceleration.x - last.acceleration.x) < varianceThreshold.x &&
        abs(current.acceleration.y - last.acceleration.y) < varianceThreshold.y &&
        abs(current.acceleration.z - last.acceleration.z) < varianceThreshold.z
    }

    /// Core motion manager used to detect device motion
    private var motion = CMMotionManager()

    /// Enqueues the newest CMAccelerometerData to pastAccelerometerReads.
    /// - Parameter data: A CMAccelerometerData to enqueue
    private func enqueue(_ data: CMAccelerometerData) {
        pastAccelerometerReads.last = pastAccelerometerReads.current
        pastAccelerometerReads.current = data
    }

    /// Start listening to device acceleration updates.
    public func start() {
        guard motion.isAccelerometerAvailable else { return }
        motion.accelerometerUpdateInterval = 1.0 / 10.0 // 10 Hz - updates 10 times per second.
        motion.startAccelerometerUpdates(to: operationQueue) { [weak self] (data: CMAccelerometerData?, error) in
            guard let data = data, let self = self, error == nil else { return }
            self.enqueue(data)
        }
    }

    /// Stop listening to device acceleration updates.
    public func stop() { motion.stopAccelerometerUpdates() }
}



