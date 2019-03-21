//
//  StableCameraManager.swift
//  ARKitVision
//
//  Created by Terry Wang on 3/19/19.
//  Copyright © 2019 Accenture. All rights reserved.
//

import AVFoundation
import CoreMotion

protocol StableCameraDetectorDelegate {
    func cameraIsStable()
}

class StableCameraDetector {

    let threshold = (x: 0.1, y: 0.1, z: 0.1)

    static let queueName = "StableCameraDetectorQueue"
    private let queue = OperationQueue()

    private var delegate: StableCameraDetectorDelegate?

    var lastAccelerometerData: CMAccelerometerData?
    var doesPassThreshold: Bool {
        guard let lastAccelerometerData = lastAccelerometerData else { return false }
        return lastAccelerometerData.acceleration.x < abs(threshold.x)
        && lastAccelerometerData.acceleration.y < abs(threshold.y)
        && lastAccelerometerData.acceleration.z < abs(threshold.z)
    }

    var manager = CMMotionManager()

    /// Start listening to device acceleration updates.
    func start() {
        queue.name = StableCameraDetector.queueName
        guard manager.isAccelerometerAvailable else { return }
        manager.startAccelerometerUpdates(to: queue) { [weak self] (data: CMAccelerometerData?, error) in
            guard let data = data, error == nil else { return }
            //print("acceleration:", data)
            self?.lastAccelerometerData = data
            if self!.doesPassThreshold {
                print(self?.lastAccelerometerData!)
            }
        }
        manager.startDeviceMotionUpdates(to: .main) { (data, error) in
            guard let data = data, error == nil else { return }
            //print("motion:", data)
        }
    }

    /// Stops listening to device acceleration updates.
    func stop() { manager.stopAccelerometerUpdates() }

}

