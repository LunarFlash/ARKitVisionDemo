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

    static let queueName = "StableCameraDetectorQueue"
    private let queue = OperationQueue()

    private var delegate: StableCameraDetectorDelegate?

    var lastAccelerometerData: CMAccelerometerData?
    

    var manager = CMMotionManager()

    /// Start listening to device acceleration updates.
    func start() {
        queue.name = StableCameraDetector.queueName
        guard manager.isAccelerometerAvailable else { return }
        manager.startAccelerometerUpdates(to: queue) { [weak self] (data: CMAccelerometerData?, error) in
            guard let data = data, error == nil else { return }
            self?.lastAccelerometerData = data
        }
    }

    /// Stops listening to device acceleration updates.
    func stop() { manager.stopAccelerometerUpdates() }

}

