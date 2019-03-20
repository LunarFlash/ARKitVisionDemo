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

    private var delegate: StableCameraDetectorDelegate?

    var manager = CMMotionManager()

    /// Start listening to device acceleration updates.
    func start() {
        guard manager.isAccelerometerAvailable else { return }
        manager.startAccelerometerUpdates(to: .main) { [weak self] (data: CMAccelerometerData?, error) in
            guard let data = data, error == nil else { return }
            print("receiving accelerometer data:", data)
        }
    }

    /// Stops listening to device acceleration updates.
    func stop() { manager.stopAccelerometerUpdates() }

}

